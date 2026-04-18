import Foundation

/// A vocabulary word with its Spanish term and English translation.
///
public struct Word: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let spanish: String
    public let english: String

    public init(spanish: String, english: String) {
        self.id = "\(spanish.lowercased())_\(english.lowercased())"
        self.spanish = spanish
        self.english = english
    }
}
