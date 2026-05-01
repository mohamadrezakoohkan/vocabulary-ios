import Foundation

/// A tag or topical grouping for vocabulary words (e.g. `"saludar"`, `"easy"`, `"a1"`).
public struct Category: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let name: String

    public init(id: String? = nil, name: String) {
        self.id = id ?? name.lowercased()
        self.name = name
    }
}
