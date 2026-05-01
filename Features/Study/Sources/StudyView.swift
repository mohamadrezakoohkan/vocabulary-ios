import SwiftUI
import ICoreUI
import ICoreModels
import SharedCommon

public struct StudyView: View {

    @Environment(\.serviceProvider) var serviceProvider

    @State private var currentWord: Word?
    @State private var reviewedCount: Int = 0
    @State private var cardID: UUID = UUID()
    @State private var totalAllowed: Int = batchSize

    private static let batchSize = 20
    private static let interval: TimeInterval = 60

    private var totalCount: Int {
        serviceProvider.wordService.totalCount
    }

    private var remainingCount: Int {
        serviceProvider.wordService.remainingCount
    }

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            ProgressBarView(
                current: reviewedCount,
                batchSize: Self.batchSize,
                interval: Self.interval,
                onBatchAdded: {
                    totalAllowed += Self.batchSize
                }
            )
            .padding(.horizontal)
            .padding(.top)

            Text("\(totalCount - remainingCount) words visited from \(totalCount) total")
                .font(.body)
                .fontWeight(.light)
                .foregroundStyle(Color.foregroundMuted.opacity(0.5))
            .padding(.horizontal)
            .padding(.top, big)

            Spacer()

            if let word = currentWord {
                FlashcardView(
                    word: word.term,
                    phonetic: word.phonetic ?? "",
                    translation: word.translation,
                    example: word.example ?? "",
                    exampleTranslation: word.exampleTranslation ?? "",
                    onPlaySound: {
                        speakWord()
                    },
                    onNext: {
                        loadNextWord()
                    }
                )
                .id(cardID)
                .padding(.horizontal)
            }

            Spacer()
        }
        .background(Color.background)
        .onAppear {
            loadNextWord()
        }
    }

    private func loadNextWord() {
        guard reviewedCount < totalAllowed else { return }
        currentWord = serviceProvider.wordService.fetchRandomWord()
        reviewedCount += 1
        cardID = UUID()
    }

    private func speakWord() {
        guard let currentWord else { return }
        serviceProvider.textToSpeechService.speak(currentWord.term)
    }
}

#Preview {
    StudyView()
}
