import Foundation
import SQLiteData

@Table("wordCategories")
struct WordCategoryRecord: Hashable, Codable, Sendable {
    let wordID: String
    let categoryID: String
}
