import Foundation
import SQLiteData

@Table("categories")
struct CategoryRecord: Hashable, Identifiable, Codable, Sendable {
    let id: String
    var name: String
}
