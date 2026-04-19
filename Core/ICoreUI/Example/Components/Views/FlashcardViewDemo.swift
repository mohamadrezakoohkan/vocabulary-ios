//
//  FlashcardViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct FlashcardViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "FlashcardView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var word: String = "gracias"
    @State private var phonetic: String = "/'gra.sjas/"
    @State private var revealLabel: String = "Tap to reveal"
    @State private var minHeight: CGFloat = 360
    @State private var translation: String = "thank you"
    @State private var example: String = "Muchas gracias por tu ayuda."
    @State private var exampleTranslation: String = "Thank you very much for your help."
    @State private var imageSystemName: String = "hand.wave.fill"
    @State private var hasOnReveal: Bool = true

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                FlashcardView(
                    word: word,
                    phonetic: phonetic,
                    revealLabel: revealLabel,
                    minHeight: minHeight,
                    translation: translation,
                    example: example,
                    exampleTranslation: exampleTranslation,
                    imageSystemName: imageSystemName.isEmpty ? nil : imageSystemName,
                    onReveal: hasOnReveal ? {} : nil
                )
            }

            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Front") {
                TextFieldRow(label: "Word",         text: $word)
                TextFieldRow(label: "Phonetic",     text: $phonetic)
                TextFieldRow(label: "Reveal label", text: $revealLabel)
                SliderRow(label: "Min height", value: $minHeight, range: 200...520, step: 20)
                Toggle("Has onReveal", isOn: $hasOnReveal).font(.subheadline)
            }

            ControlsSection(title: "Back (flip)") {
                TextFieldRow(label: "Image symbol",        text: $imageSystemName)
                TextFieldRow(label: "Translation",         text: $translation)
                TextFieldRow(label: "Example",             text: $example)
                TextFieldRow(label: "Example translation", text: $exampleTranslation)
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "FlashcardView",
            positional: [],
            arguments: [
                ("word",               swiftStringLiteral(word)),
                ("phonetic",           swiftStringLiteral(phonetic)),
                ("revealLabel",        swiftStringLiteral(revealLabel)),
                ("minHeight",          String(format: "%.0f", Double(minHeight))),
                ("translation",        swiftStringLiteral(translation)),
                ("example",            swiftStringLiteral(example)),
                ("exampleTranslation", swiftStringLiteral(exampleTranslation)),
                ("imageSystemName",    imageSystemName.isEmpty ? nil : swiftStringLiteral(imageSystemName)),
                ("onReveal",           hasOnReveal ? "{ /* reveal */ }" : nil),
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Full back content (image + all text)") {
                FlashcardView(
                    word: "gracias",
                    phonetic: "/'gra.sjas/",
                    translation: "thank you",
                    example: "Muchas gracias por tu ayuda.",
                    exampleTranslation: "Thank you very much for your help.",
                    imageSystemName: "hand.wave.fill",
                    onReveal: {}
                )
            }

            CombinationGroup(title: "Image + translation only") {
                FlashcardView(
                    word: "manzana",
                    phonetic: "/manˈθana/",
                    translation: "apple",
                    imageSystemName: "applelogo",
                    onReveal: {}
                )
            }

            CombinationGroup(title: "Translation + example (no image)") {
                FlashcardView(
                    word: "ephemeral",
                    phonetic: "/əˈfɛm.ər.əl/",
                    revealLabel: "Show meaning",
                    translation: "lasting for a very short time",
                    example: "The beauty of cherry blossoms is ephemeral.",
                    exampleTranslation: "Cherry blossoms only bloom for a few days.",
                    onReveal: {}
                )
            }

            CombinationGroup(title: "Translation only") {
                FlashcardView(
                    word: "hola",
                    translation: "hello",
                    onReveal: {}
                )
            }

            CombinationGroup(title: "No back content (legacy reveal)") {
                FlashcardView(
                    word: "serendipity",
                    phonetic: "/ˌsɛr.ənˈdɪp.ə.ti/",
                    onReveal: {}
                )
            }

            CombinationGroup(title: "Static (no CTA, no back)") {
                FlashcardView(
                    word: "merci",
                    phonetic: "/mɛʁ.si/"
                )
            }

            CombinationGroup(title: "Long word + back content") {
                FlashcardView(
                    word: "Anwendungsbeispiel",
                    phonetic: "/ˈanvɛndʊŋsbaɪˌʃpiːl/",
                    translation: "usage example",
                    example: "Das ist ein gutes Anwendungsbeispiel.",
                    exampleTranslation: "That is a good usage example.",
                    imageSystemName: "text.book.closed.fill",
                    onReveal: {}
                )
            }

            CombinationGroup(title: "Compact (minHeight 240)") {
                FlashcardView(
                    word: "arigatou",
                    phonetic: "/a.ɾi.ɡa.toː/",
                    minHeight: 240,
                    translation: "thank you",
                    imageSystemName: "hands.sparkles.fill",
                    onReveal: {}
                )
            }
        }
    }
}

#Preview {
    NavigationStack { FlashcardViewDemo() }
}
