import Foundation
import ICoreModels
import ICoreDatabase

/// A service that provides random vocabulary words, tracking which ones have been visited.
///
/// Each call to ``fetchRandomWord()`` returns a word that hasn't been visited yet.
/// Once a word is returned, it is marked as visited and excluded from future draws.
/// When all words have been visited, the visited set resets automatically.
public protocol IWordService {

    /// Returns a random unvisited word.
    ///
    /// Once all words have been visited, the visited set resets and words can be returned again.
    /// Returns `nil` only if the word list is empty.
    func fetchRandomWord() -> Word?

    /// The number of words that have not yet been visited.
    var remainingCount: Int { get }

    /// The total number of words available.
    var totalCount: Int { get }

    /// Resets the visited words, making all words available again.
    func reset()
}

/// Concrete implementation of ``IWordService`` backed by ``IVocabularyDatabase``.
///
/// Visited word IDs are persisted to `UserDefaults` so progress survives app restarts.
public final class WordService: IWordService {

    private let words: [Word]
    private var visitedIDs: Set<String>
    private let defaults: UserDefaults
    private let visitedKey = "WordService.visitedIDs"

    public init(words: [Word], defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.words = words
        let saved = defaults.stringArray(forKey: visitedKey) ?? []
        self.visitedIDs = Set(saved)
    }

    /// Creates a `WordService` by loading every word from the bundled vocabulary database.
    ///
    /// Falls back to an empty list if the database cannot be opened.
    public convenience init(database: any IVocabularyDatabase, defaults: UserDefaults = .standard) {
        let words = (try? database.allWords()) ?? []
        self.init(words: words, defaults: defaults)
    }

    public convenience init(defaults: UserDefaults = .standard) {
        let database = try? VocabularyDatabase()
        let words = (try? database?.allWords()) ?? []
        self.init(words: words, defaults: defaults)
    }

    public var totalCount: Int { words.count }

    public var remainingCount: Int {
        words.count - visitedIDs.count
    }

    public func fetchRandomWord() -> Word? {
        guard !words.isEmpty else { return nil }

        let available = words.filter { !visitedIDs.contains($0.id) }

        if available.isEmpty {
            visitedIDs.removeAll()
            persistVisited()
            return words.randomElement()
        }

        guard let word = available.randomElement() else { return nil }
        visitedIDs.insert(word.id)
        persistVisited()
        return word
    }

    public func reset() {
        visitedIDs.removeAll()
        persistVisited()
    }

    private func persistVisited() {
        defaults.set(Array(visitedIDs), forKey: visitedKey)
    }
}
