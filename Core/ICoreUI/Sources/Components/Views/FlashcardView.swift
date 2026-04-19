//
//  FlashcardView.swift
//  ICoreUI
//
//  Apple HIG vocabulary flashcard — surface card, no hard border, soft shadow,
//  oversized centered word, optional phonetic transcription, ghost reveal CTA,
//  and an internal 3D flip that reveals image + translation + example + example
//  translation on the back face.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - Container: Color.surface, continuous .large corners (16pt), .small soft
//    shadow. Do NOT add 2-3pt borders or hard offset shadows.
//  - Layout is centered: word + phonetic vertically centered with Spacers,
//    reveal CTA pinned to the bottom. Use a comfortable minHeight so the card
//    feels like a presentation surface (default 360pt).
//  - Word uses .largeTitle.weight(.heavy) so it dominates the surface and
//    supports Dynamic Type. Truncation is allowed via lineLimit on extreme
//    sizes — never hardcode point sizes.
//  - Phonetic uses .title3.italic() in .foregroundMuted. Convention is the
//    IPA-style "/word/" wrapping; the caller passes the already-wrapped
//    string so the component does not impose orthography.
//  - The reveal CTA is rendered as a text label that visually matches the
//    `.appGhost` ButtonStyle (.body.weight(.semibold) in .primaryRed). It is
//    NOT its own Button — the entire card surface is the tap target so the
//    user can tap anywhere on the card to flip / reveal. Do NOT add an icon
//    next to the reveal label. When no back content is provided AND
//    `onReveal` is nil, the hint is omitted entirely.
//  - Back face: optional SF Symbol image on top in .primaryBlue, then bold
//    translation, then italic example sentence, then muted example
//    translation. Order is fixed; only non-empty pieces render.
//  - The back face is enabled when ANY of translation / example /
//    exampleTranslation / imageSystemName is non-empty/non-nil. In that
//    case tapping anywhere on the card flips it via .rotation3DEffect on
//    the Y axis. Rotation uses .easeInOut(duration: 0.5); the front/back
//    opacity SWAPS instantly at the midpoint (delay 0.25s, duration 0.001s)
//    so the back content does not bleed through during rotation.
//    `onReveal` (when provided) fires on the front→back transition
//    so callers can track analytics or run side effects.
//  - When NO back content is provided, behavior is unchanged: tapping
//    the card forwards to `onReveal` (legacy behavior, preserved for
//    backwards compatibility).
//  - Public API is backwards compatible and additive only.
//  - Accessibility: front combines word + phonetic into a single element
//    ("<word>, pronounced <phonetic>"). Back combines image + translation +
//    example + example translation into a single element with a clear
//    spoken label. The ghost button keeps its own .isButton trait.
//  - Previews: light + dark, covering with/without phonetic, with/without
//    back content, with/without reveal CTA, and a long-word truncation case.
//  - Demo: Core/ICoreUI/Example/Components/Views/FlashcardViewDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever the public API changes.
//

import SwiftUI

public struct FlashcardView: View {
    private let word: String
    private let phonetic: String
    private let revealLabel: String
    private let minHeight: CGFloat
    private let translation: String
    private let example: String
    private let exampleTranslation: String
    private let imageSystemName: String?
    private let onReveal: (() -> Void)?

    @State private var isFlipped: Bool = false

    public init(
        word: String,
        phonetic: String = "",
        revealLabel: String = "Tap to reveal",
        minHeight: CGFloat = 360,
        translation: String = "",
        example: String = "",
        exampleTranslation: String = "",
        imageSystemName: String? = nil,
        onReveal: (() -> Void)? = nil
    ) {
        self.word = word
        self.phonetic = phonetic
        self.revealLabel = revealLabel
        self.minHeight = minHeight
        self.translation = translation
        self.example = example
        self.exampleTranslation = exampleTranslation
        self.imageSystemName = imageSystemName
        self.onReveal = onReveal
    }

    public var body: some View {
        if isInteractive {
            Button(action: handleTap) { card }
                .buttonStyle(FlashcardCardButtonStyle())
        } else {
            card
        }
    }

    // MARK: - Card

    private var card: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
                .animation(.linear(duration: 0.001).delay(0.25), value: isFlipped)
                .accessibilityHidden(isFlipped)

            back
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
                .animation(.linear(duration: 0.001).delay(0.25), value: isFlipped)
                .accessibilityHidden(!isFlipped)
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
        .cardStyle(
            paddingHorizontal: medium,
            paddingVertical: mediumBig,
            backgroundColor: .surface,
            borderColor: nil,
            cornerStyle: .large,
            shadow: .small
        )
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.5), value: isFlipped)
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Front

    private var front: some View {
        VStack(spacing: medium) {
            Spacer(minLength: 0)

            wordBlock
                .accessibilityElement(children: .combine)
                .accessibilityLabel(frontAccessibilityLabel)

            Spacer(minLength: 0)

            if showsRevealHint {
                revealHint
            }
        }
    }

    private var revealHint: some View {
        Text(revealLabel)
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.primaryRed)
            .padding(.horizontal, medium)
            .padding(.vertical, smallMedium)
            .frame(minHeight: 44)
            .accessibilityHidden(true)
    }

    private var wordBlock: some View {
        VStack(spacing: small) {
            Text(word)
                .font(.largeTitle.weight(.heavy))
                .foregroundStyle(Color.foreground)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
                .fixedSize(horizontal: false, vertical: true)

            if !phonetic.isEmpty {
                Text(phonetic)
                    .font(.title3.italic())
                    .foregroundStyle(Color.foregroundMuted)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
    }

    // MARK: - Back

    private var back: some View {
        VStack(spacing: medium) {
            Spacer(minLength: 0)

            if let imageSystemName, !imageSystemName.isEmpty {
                Image(systemName: imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 96, maxHeight: 96)
                    .foregroundStyle(Color.primaryBlue)
                    .accessibilityHidden(true)
            }

            if !translation.isEmpty {
                Text(translation)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.foreground)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !example.isEmpty || !exampleTranslation.isEmpty {
                VStack(spacing: extraSmall) {
                    if !example.isEmpty {
                        Text(example)
                            .font(.body.italic())
                            .foregroundStyle(Color.foreground)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if !exampleTranslation.isEmpty {
                        Text(exampleTranslation)
                            .font(.subheadline)
                            .foregroundStyle(Color.foregroundMuted)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            Spacer(minLength: 0)

            Text("Tap to flip back")
                .font(.caption)
                .foregroundStyle(Color.foregroundMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(backAccessibilityLabel)
    }

    // MARK: - Behavior

    private func handleTap() {
        if hasBackContent {
            let willReveal = !isFlipped
            isFlipped.toggle()
            if willReveal { onReveal?() }
        } else {
            onReveal?()
        }
    }

    private var hasBackContent: Bool {
        !translation.isEmpty
            || !example.isEmpty
            || !exampleTranslation.isEmpty
            || (imageSystemName.map { !$0.isEmpty } ?? false)
    }

    private var isInteractive: Bool {
        hasBackContent || onReveal != nil
    }

    private var showsRevealHint: Bool {
        isInteractive
    }

    // MARK: - Accessibility

    private var frontAccessibilityLabel: String {
        if phonetic.isEmpty { return word }
        return "\(word), pronounced \(phonetic)"
    }

    private var backAccessibilityLabel: String {
        var parts: [String] = []
        if !translation.isEmpty { parts.append(translation) }
        if !example.isEmpty { parts.append("Example, \(example)") }
        if !exampleTranslation.isEmpty { parts.append(exampleTranslation) }
        return parts.isEmpty ? "Card back" : parts.joined(separator: ". ")
    }
}

// MARK: - Button Style

private struct FlashcardCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.95 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.85), value: configuration.isPressed)
    }
}

// MARK: - Preview

private struct FlashcardPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                FlashcardView(
                    word: "gracias",
                    phonetic: "/'gra.sjas/",
                    translation: "thank you",
                    example: "Muchas gracias por tu ayuda.",
                    exampleTranslation: "Thank you very much for your help.",
                    imageSystemName: "hand.wave.fill",
                    onReveal: {}
                )

                FlashcardView(
                    word: "ephemeral",
                    phonetic: "/əˈfɛm.ər.əl/",
                    revealLabel: "Show meaning",
                    translation: "lasting for a very short time",
                    example: "The beauty of cherry blossoms is ephemeral.",
                    exampleTranslation: "Cherry blossoms only bloom for a few days each spring.",
                    imageSystemName: "leaf.fill",
                    onReveal: {}
                )

                FlashcardView(word: "hola", onReveal: {})

                FlashcardView(
                    word: "serendipity",
                    phonetic: "/ˌsɛr.ənˈdɪp.ə.ti/"
                )

                FlashcardView(
                    word: "Anwendungsbeispiel",
                    phonetic: "/ˈanvɛndʊŋsbaɪˌʃpiːl/",
                    minHeight: 280,
                    translation: "usage example",
                    imageSystemName: "text.book.closed.fill",
                    onReveal: {}
                )
            }
            .padding(medium)
        }
        .background(.background)
    }
}

#Preview("Light Mode") {
    FlashcardPreview().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    FlashcardPreview().preferredColorScheme(.dark)
}
