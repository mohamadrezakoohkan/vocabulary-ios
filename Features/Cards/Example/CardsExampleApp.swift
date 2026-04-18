//
//  CardsExampleApp.swift
//  PROJECT_NAME
//
//  Created by Mohammad reza on 17/4/26.
//

import SwiftUI
import Cards
import ICoreFoundation
import ICoreNetwork
import ICoreModels

@main
struct CardsExampleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TextToSpeechPreview()
                    .tabItem { Label("Speech", systemImage: "speaker.wave.2") }
                ImageServicePreview()
                    .tabItem { Label("Image", systemImage: "photo") }
                WordServicePreview()
                    .tabItem { Label("Words", systemImage: "textformat.abc") }
            }
        }
    }
}

private struct TextToSpeechPreview: View {

    let tts = TextToSpeechService(
        language: "en-US",
        rate: 0.2,
        pitchMultiplier: 1.3
    )

    @State private var rate: Float = 0.2
    @State private var pitchMultiplier: Float = 1.3

    private let samples: [(label: String, language: String, text: String)] = [
        ("English (US)", "en-US", "Hello! This is a text to speech preview in English."),
        ("Persian", "fa-IR", "سلام! این یک پیش‌نمایش تبدیل متن به گفتار به زبان فارسی است."),
        ("Spanish", "es-ES", "Hola! Esta es una vista previa de texto a voz en espanol.")
    ]

    var body: some View {
        List {
            Section("Controls") {
                VStack(alignment: .leading) {
                    Text("Rate: \(String(format: "%.2f", rate))")
                        .font(.subheadline)
                    Slider(value: Binding(get: { Double(rate) }, set: { rate = Float($0) }),
                           in: 0.0...1.0, step: 0.01)
                }

                VStack(alignment: .leading) {
                    Text("Pitch: \(String(format: "%.2f", pitchMultiplier))")
                        .font(.subheadline)
                    Slider(value: Binding(get: { Double(pitchMultiplier) }, set: { pitchMultiplier = Float($0) }),
                           in: 0.5...2.0, step: 0.05)
                }
            }

            Section("Languages") {
                ForEach(samples, id: \.language) { sample in
                    Button {
                        tts.rate = rate
                        tts.pitchMultiplier = pitchMultiplier
                        tts.language = sample.language
                        tts.speak(sample.text)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sample.label)
                                .font(.headline)
                            Text(sample.text)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Text to Speech")
    }
}

// MARK: - Image Service Preview

private struct ImageServicePreview: View {

    @State private var query = ""
    @State private var imageData: Data?
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let imageService = ImageService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    TextField("Search (e.g. red apple fruit)", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    Button("Fetch") {
                        Task { await fetchImage() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(query.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                }
                .padding(.horizontal)

                if isLoading {
                    ProgressView("Fetching image...")
                } else if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Image Search")
        }
    }

    private func fetchImage() async {
        let words = query
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }

        isLoading = true
        errorMessage = nil
        imageData = nil

        do {
            let data = try await imageService.fetchImage(query: words)
            imageData = data
            if data == nil {
                errorMessage = "No image found for \"\(query)\""
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

// MARK: - Word Service Preview

private struct WordServicePreview: View {

    @State private var wordService = WordService()

    @State private var currentWord: Word?
    @State private var history: [Word] = []

    var body: some View {
        NavigationStack {
            List {
                Section("Current Word") {
                    if let currentWord {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(currentWord.spanish)
                                .font(.largeTitle.bold())
                            Text(currentWord.english)
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    } else {
                        Text("Tap \"Next Word\" to start")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Actions") {
                    Button("Next Word") {
                        if let word = wordService.fetchRandomWord() {
                            currentWord = word
                            history.insert(word, at: 0)
                        }
                    }

                    Button("Reset") {
                        wordService.reset()
                        currentWord = nil
                        history.removeAll()
                    }
                    .foregroundStyle(.red)
                }

                Section("Stats") {
                    LabeledContent("Total", value: "\(wordService.totalCount)")
                    LabeledContent("Remaining", value: "\(wordService.remainingCount)")
                    LabeledContent("Visited", value: "\(wordService.totalCount - wordService.remainingCount)")
                }

                if !history.isEmpty {
                    Section("History") {
                        ForEach(history) { word in
                            HStack {
                                Text(word.spanish)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(word.english)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Word Service")
        }
    }
}

