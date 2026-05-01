import Foundation

/// A vocabulary word along with phonetic transcription, translation, an example sentence,
/// and the categories it belongs to.
public struct Word: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let term: String
    public let phonetic: String?
    public let translation: String
    public let example: String?
    public let exampleTranslation: String?
    public let categories: [Category]

    public init(
        id: String? = nil,
        term: String,
        phonetic: String? = nil,
        translation: String,
        example: String? = nil,
        exampleTranslation: String? = nil,
        categories: [Category] = []
    ) {
        self.id = id ?? "\(term.lowercased())_\(translation.lowercased())"
        self.term = term
        self.phonetic = phonetic
        self.translation = translation
        self.example = example
        self.exampleTranslation = exampleTranslation
        self.categories = categories
    }
}
