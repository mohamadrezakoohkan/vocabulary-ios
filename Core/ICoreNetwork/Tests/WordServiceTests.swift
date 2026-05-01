import Testing
import Foundation
import ICoreModels
@testable import ICoreNetwork

struct WordServiceTests {

    // MARK: - Init with words array

    @Test func fetchRandomWord_returnsWordFromList() {
        let words = [Word(term: "hola", translation: "hello")]
        let service = WordService(words: words, defaults: makeDefaults())

        let word = service.fetchRandomWord()

        #expect(word?.term == "hola")
        #expect(word?.translation == "hello")
    }

    @Test func fetchRandomWord_returnsNilForEmptyList() {
        let service = WordService(words: [], defaults: makeDefaults())

        #expect(service.fetchRandomWord() == nil)
    }

    @Test func totalCount_returnsCorrectCount() {
        let words = [
            Word(term: "hola", translation: "hello"),
            Word(term: "adiós", translation: "goodbye"),
        ]
        let service = WordService(words: words, defaults: makeDefaults())

        #expect(service.totalCount == 2)
    }

    @Test func remainingCount_decreasesAfterFetch() {
        let words = [
            Word(term: "hola", translation: "hello"),
            Word(term: "adiós", translation: "goodbye"),
        ]
        let service = WordService(words: words, defaults: makeDefaults())

        #expect(service.remainingCount == 2)
        _ = service.fetchRandomWord()
        #expect(service.remainingCount == 1)
    }

    @Test func fetchRandomWord_returnsAllWordsBeforeRepeating() {
        let words = [
            Word(term: "hola", translation: "hello"),
            Word(term: "adiós", translation: "goodbye"),
            Word(term: "gracias", translation: "thanks"),
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
        let words = [Word(term: "hola", translation: "hello")]
        let service = WordService(words: words, defaults: makeDefaults())

        _ = service.fetchRandomWord()
        #expect(service.remainingCount == 0)

        let word = service.fetchRandomWord()
        #expect(word != nil)
    }

    @Test func reset_makesAllWordsAvailableAgain() {
        let words = [
            Word(term: "hola", translation: "hello"),
            Word(term: "adiós", translation: "goodbye"),
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
            Word(term: "hola", translation: "hello"),
            Word(term: "adiós", translation: "goodbye"),
        ]
        let defaults = makeDefaults()

        let service1 = WordService(words: words, defaults: defaults)
        _ = service1.fetchRandomWord()

        let service2 = WordService(words: words, defaults: defaults)
        #expect(service2.remainingCount == 1)
    }

    // MARK: - Helpers

    private func makeDefaults() -> UserDefaults {
        let suiteName = "WordServiceTests.\(UUID().uuidString)"
        return UserDefaults(suiteName: suiteName)!
    }
}
