import Testing
import Foundation
import ICoreModels
@testable import ICoreNetwork

struct WordServiceTests {

    // MARK: - Init with words array

    @Test func fetchRandomWord_returnsWordFromList() {
        let words = [Word(spanish: "hola", english: "hello")]
        let service = WordService(words: words, defaults: makeDefaults())

        let word = service.fetchRandomWord()

        #expect(word?.spanish == "hola")
        #expect(word?.english == "hello")
    }

    @Test func fetchRandomWord_returnsNilForEmptyList() {
        let service = WordService(words: [], defaults: makeDefaults())

        #expect(service.fetchRandomWord() == nil)
    }

    @Test func totalCount_returnsCorrectCount() {
        let words = [
            Word(spanish: "hola", english: "hello"),
            Word(spanish: "adiós", english: "goodbye"),
        ]
        let service = WordService(words: words, defaults: makeDefaults())

        #expect(service.totalCount == 2)
    }

    @Test func remainingCount_decreasesAfterFetch() {
        let words = [
            Word(spanish: "hola", english: "hello"),
            Word(spanish: "adiós", english: "goodbye"),
        ]
        let service = WordService(words: words, defaults: makeDefaults())

        #expect(service.remainingCount == 2)
        _ = service.fetchRandomWord()
        #expect(service.remainingCount == 1)
    }

    @Test func fetchRandomWord_returnsAllWordsBeforeRepeating() {
        let words = [
            Word(spanish: "hola", english: "hello"),
            Word(spanish: "adiós", english: "goodbye"),
            Word(spanish: "gracias", english: "thanks"),
        ]
        let service = WordService(words: words, defaults: makeDefaults())

        var fetched: Set<String> = []
        for _ in 0..<3 {
            let word = service.fetchRandomWord()!
            fetched.insert(word.id)
        }

        #expect(fetched.count == 3)
    }

    @Test func fetchRandomWord_resetsWhenAllVisited() {
        let words = [Word(spanish: "hola", english: "hello")]
        let service = WordService(words: words, defaults: makeDefaults())

        _ = service.fetchRandomWord()
        #expect(service.remainingCount == 0)

        // Should reset and return the word again
        let word = service.fetchRandomWord()
        #expect(word != nil)
    }

    @Test func reset_makesAllWordsAvailableAgain() {
        let words = [
            Word(spanish: "hola", english: "hello"),
            Word(spanish: "adiós", english: "goodbye"),
        ]
        let service = WordService(words: words, defaults: makeDefaults())

        _ = service.fetchRandomWord()
        _ = service.fetchRandomWord()
        #expect(service.remainingCount == 0)

        service.reset()
        #expect(service.remainingCount == 2)
    }

    @Test func visitedState_persistsAcrossInstances() {
        let words = [
            Word(spanish: "hola", english: "hello"),
            Word(spanish: "adiós", english: "goodbye"),
        ]
        let defaults = makeDefaults()

        let service1 = WordService(words: words, defaults: defaults)
        _ = service1.fetchRandomWord()

        let service2 = WordService(words: words, defaults: defaults)
        #expect(service2.remainingCount == 1)
    }

    // MARK: - Init from CSV bundle

    @Test func initFromBundle_loadsWordsFromCSV() {
        let service = WordService(defaults: makeDefaults())

        #expect(service.totalCount > 0)
        #expect(service.fetchRandomWord() != nil)
    }

    // MARK: - Helpers

    private func makeDefaults() -> UserDefaults {
        let suiteName = "WordServiceTests.\(UUID().uuidString)"
        return UserDefaults(suiteName: suiteName)!
    }
}
