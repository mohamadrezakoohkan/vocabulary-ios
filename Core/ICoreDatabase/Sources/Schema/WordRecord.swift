import Foundation
import SQLiteData

@Table("words")
struct WordRecord: Hashable, Identifiable, Codable, Sendable {
    let id: String
    var term: String
    var phonetic: String?
    var translation: String
    var example: String?
    var exampleTranslation: String?
}
