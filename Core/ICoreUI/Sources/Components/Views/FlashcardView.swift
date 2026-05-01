//
//  FlashcardView.swift
//  ICoreUI
//
//  Apple HIG vocabulary flashcard — surface card, no hard border, soft shadow,
//  oversized centered word, optional phonetic transcription, ghost reveal CTA,
//  and an internal 3D flip that reveals image + translation + example + example
//  translation on the back face. Tap or horizontal swipe to flip.
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
//    NOT its own Button — the entire card surface is the tap/drag target so
//    the user can interact anywhere on the card. Do NOT add an icon next to
//    the reveal label.
//  - Back face: optional AsyncImage from URL on top, then bold
//    translation, then italic example sentence, then muted example
//    translation. Order is fixed; only non-empty pieces render.
//  - The back face is enabled when ANY of translation / example /
//    exampleTranslation / imageURL is non-empty/non-nil. In that
//    case the card supports BOTH:
//      • Tap anywhere to flip (animated, .easeInOut(duration: 0.5)).
//      • Horizontal swipe to flip interactively — rotation tracks the drag
//        in real time; on release the card snaps to the nearest face based
//        on predicted-end velocity. Vertical scroll is unaffected because
//        the gesture uses minimumDistance: 12.
//    Front/back opacity uses a custom Animatable modifier that derives
//    visibility from the LIVE interpolated rotation angle (snaps at 90°
//    and 270°). Do NOT animate opacity with a separate timed delay — it
//    desyncs from the drag.
//    `onReveal` (when provided) fires every time the card transitions
//    front→back (tap or drag) so callers can track analytics or run side
//    effects. It does NOT fire on the back→front transition.
//  - When NO back content is provided, behavior is unchanged: tapping
//    the card forwards to `onReveal` (legacy behavior, preserved for
//    backwards compatibility). The drag gesture is not attached.
//  - Public API is backwards compatible and additive only.
//  - Accessibility: front combines word + phonetic into a single element
//    ("<word>, pronounced <phonetic>"). Back combines image + translation +
//    example + example translation into a single element. When the card is
//    interactive it exposes the .isButton trait + a "Flip" custom action
//    so VoiceOver users (who cannot drag) can still flip via the rotor.
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
    private let imageURL: URL?
    private let onPlaySound: (() -> Void)?
    private let onReveal: (() -> Void)?
    private let onNext: (() -> Void)?

    /// Continuous rotation angle in degrees. Tap and drag both write here.
    @State private var displayRotation: Double = 0
    /// Snapshot of `displayRotation` taken at the start of an in-flight drag.
    @State private var dragStartRotation: Double = 0
    @State private var isDragging: Bool = false

    /// pt of horizontal drag per degree of rotation. Lower = more sensitive.
    private let dragSensitivity: CGFloat = 1.6
    /// Minimum drag distance before the gesture is recognised as a swipe.
    /// Tap-through still works for shorter touches.
    private let dragMinimumDistance: CGFloat = 12

    public init(
        word: String,
        phonetic: String = "",
        revealLabel: String = "Flip to reveal",
        minHeight: CGFloat = 360,
        translation: String = "",
        example: String = "",
        exampleTranslation: String = "",
        imageURL: URL? = nil,
        onPlaySound: (() -> Void)? = nil,
        onReveal: (() -> Void)? = nil,
        onNext: (() -> Void)? = nil
    ) {
        self.word = word
        self.phonetic = phonetic
        self.revealLabel = revealLabel
        self.minHeight = minHeight
        self.translation = translation
        self.example = example
        self.exampleTranslation = exampleTranslation
        self.imageURL = imageURL
        self.onPlaySound = onPlaySound
        self.onReveal = onReveal
        self.onNext = onNext
    }

    public var body: some View {
        if isInteractive {
            interactiveCard
        } else {
            card
        }
    }

    // MARK: - Interactive shell

    @ViewBuilder
    private var interactiveCard: some View {
        let view = card
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onTapGesture { handleTap() }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(combinedAccessibilityLabel)
            .accessibilityAddTraits(.isButton)
            .accessibilityAction(named: Text("Flip")) { handleTap() }

        if hasBackContent {
            view.gesture(flipDragGesture)
        } else {
            view
        }
    }

    // MARK: - Card

    private var card: some View {
        ZStack {
            front
                .modifier(FlashcardFaceVisibility(rotation: displayRotation, isBack: false))

            back
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .modifier(FlashcardFaceVisibility(rotation: displayRotation, isBack: true))
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
        .aspectRatio(1, contentMode: .fit)
        .cardStyle(
            paddingHorizontal: medium,
            paddingVertical: medium,
            backgroundColor: .surface,
            borderColor: nil,
            cornerStyle: .large,
            shadow: .small
        )
        .rotation3DEffect(.degrees(displayRotation), axis: (x: 0, y: 1, z: 0))
        .scaleEffect(isDragging ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: isDragging)
    }

    // MARK: - Front

    private var front: some View {
        VStack(spacing: medium) {
            Spacer(minLength: 0)
            wordBlock

            if onPlaySound != nil {
                Button {
                    onPlaySound?()
                } label: {
                    Icon(.speaker, size: .large, color: .primaryBlue)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Play pronunciation")
                .padding(.top, smallMedium)
            }

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
        VStack(spacing: mediumBig) {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(Color.foregroundMuted)
                    default:
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: minHeight * 0.4)
                .clipCornerStyle(.medium)
                .accessibilityHidden(true)
            } else {
                Spacer(minLength: 0)
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

            if let onNext {
                Button {
                    onNext()
                } label: {
                    Text("Next")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Next card")
            } else {
                Text("Tap or swipe to flip back")
                    .font(.caption)
                    .foregroundStyle(Color.foregroundMuted)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Gesture

    private var flipDragGesture: some Gesture {
        DragGesture(minimumDistance: dragMinimumDistance)
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                    dragStartRotation = displayRotation
                }
                displayRotation = dragStartRotation
                    + Double(value.translation.width / dragSensitivity)
            }
            .onEnded { value in
                let predictedDelta = Double(value.predictedEndTranslation.width / dragSensitivity)
                let predictedRotation = dragStartRotation + predictedDelta
                let snappedTarget = (predictedRotation / 180).rounded() * 180

                let wasShowingBack = Self.isShowingBack(at: dragStartRotation)
                let willShowBack = Self.isShowingBack(at: snappedTarget)

                isDragging = false
                withAnimation(.easeInOut(duration: 0.3)) {
                    displayRotation = snappedTarget
                }

                if !wasShowingBack && willShowBack {
                    onReveal?()
                }
            }
    }

    // MARK: - Behavior

    private func handleTap() {
        guard hasBackContent else {
            onReveal?()
            return
        }
        let target = displayRotation + 180
        let wasShowingBack = Self.isShowingBack(at: displayRotation)
        let willShowBack = Self.isShowingBack(at: target)

        withAnimation(.easeInOut(duration: 0.5)) {
            displayRotation = target
        }

        if !wasShowingBack && willShowBack {
            onReveal?()
        }
    }

    // MARK: - Derived state

    private var hasBackContent: Bool {
        !translation.isEmpty
            || !example.isEmpty
            || !exampleTranslation.isEmpty
            || imageURL != nil
    }

    private var isInteractive: Bool {
        hasBackContent || onReveal != nil
    }

    private var showsRevealHint: Bool {
        isInteractive
    }

    private var isCurrentlyShowingBack: Bool {
        Self.isShowingBack(at: displayRotation)
    }

    /// True when the card is rotated such that the back face is the visible side.
    static func isShowingBack(at angle: Double) -> Bool {
        let normalized = ((angle.truncatingRemainder(dividingBy: 360)) + 360)
            .truncatingRemainder(dividingBy: 360)
        return normalized > 90 && normalized < 270
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

    private var combinedAccessibilityLabel: String {
        isCurrentlyShowingBack ? backAccessibilityLabel : frontAccessibilityLabel
    }
}

// MARK: - Animatable face visibility

/// Drives front/back opacity from the LIVE interpolated rotation angle so the
/// faces swap exactly when the card is edge-on (90° / 270°). Works for both
/// `withAnimation`-driven flips and live drag gestures.
private struct FlashcardFaceVisibility: ViewModifier, Animatable {
    var rotation: Double
    let isBack: Bool

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    func body(content: Content) -> some View {
        let showingBack = FlashcardView.isShowingBack(at: rotation)
        let visible = isBack ? showingBack : !showingBack
        return content.opacity(visible ? 1 : 0)
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
                    imageURL: URL(string: "https://picsum.photos/seed/gracias/200"),
                    onReveal: {}
                )

                FlashcardView(
                    word: "ephemeral",
                    phonetic: "/əˈfɛm.ər.əl/",
                    revealLabel: "Show meaning",
                    translation: "lasting for a very short time",
                    example: "The beauty of cherry blossoms is ephemeral.",
                    exampleTranslation: "Cherry blossoms only bloom for a few days each spring.",
                    imageURL: URL(string: "https://picsum.photos/seed/ephemeral/200"),
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
                    imageURL: URL(string: "https://picsum.photos/seed/beispiel/200"),
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
