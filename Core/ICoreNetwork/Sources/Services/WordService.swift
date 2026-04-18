import Foundation
import ICoreModels

/// A service that provides random vocabulary words, tracking which ones have been visited.
///
/// Each call to ``fetchRandomWord()`` returns a word that hasn't been visited yet.
/// Once a word is returned, it is marked as visited and excluded from future draws.
/// When all words have been visited, the visited set resets automatically.
///
public protocol IWordService {

    /// Returns a random unvisited word.
    ///
    /// Once all words have been visited, the visited set resets and words can be returned again.
    /// Returns `nil` only if the word list is empty.
    ///
    func fetchRandomWord() -> Word?

    /// The number of words that have not yet been visited.
    ///
    var remainingCount: Int { get }

    /// The total number of words available.
    ///
    var totalCount: Int { get }

    /// Resets the visited words, making all words available again.
    ///
    func reset()
}

/// Concrete implementation of ``IWordService`` backed by an in-memory Spanish A1 word list.
///
/// Visited word IDs are persisted to `UserDefaults` so progress survives app restarts.
///
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

    /// Creates a `WordService` by loading words from the bundled `a1.csv` resource.
    ///
    /// The CSV is expected to have a header row and two columns: `Spanish,English`.
    ///
    public convenience init(bundle: Bundle? = nil, defaults: UserDefaults = .standard) {
        let resolvedBundle = bundle ?? .module
        let words = Self.loadWords(from: resolvedBundle)
        self.init(words: words, defaults: defaults)
    }

    private static func loadWords(from bundle: Bundle) -> [Word] {
        guard let url = bundle.url(forResource: "a1", withExtension: "csv"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }

        var words: [Word] = []
        let lines = content.components(separatedBy: .newlines)

        // Skip header row and empty lines
        for line in lines.dropFirst() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }

            // Split only on the first comma to allow commas in values
            guard let commaIndex = trimmed.firstIndex(of: ",") else { continue }
            let spanish = String(trimmed[trimmed.startIndex..<commaIndex])
                .trimmingCharacters(in: .whitespaces)
            let english = String(trimmed[trimmed.index(after: commaIndex)...])
                .trimmingCharacters(in: .whitespaces)

            guard !spanish.isEmpty, !english.isEmpty else { continue }
            words.append(Word(spanish: spanish, english: english))
        }

        return words
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
