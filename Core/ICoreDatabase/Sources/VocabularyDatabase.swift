import Foundation
import OSLog
import SQLiteData
import ICoreModels

/// Read access to the bundled vocabulary database.
///
/// The database ships pre-populated inside `Bundle.module` and is copied to
/// Application Support on first launch so that future writes (user notes,
/// SRS state, etc.) can be persisted alongside the seed data.
public protocol IVocabularyDatabase: Sendable {
    func allWords() throws -> [Word]
    func words(inCategoryNamed name: String) throws -> [Word]
    func wordCount() throws -> Int
    func allCategories() throws -> [ICoreModels.Category]
}

public final class VocabularyDatabase: IVocabularyDatabase, @unchecked Sendable {

    private let writer: any DatabaseWriter

    /// Opens the bundled database, copying the seed file out of the bundle on first launch.
    public convenience init(bundle: Bundle? = nil) throws {
        let writer = try Self.openBundledDatabase(bundle: bundle ?? .module)
        self.init(writer: writer)
    }

    /// Designated initializer used in tests for injecting an in-memory or custom database.
    public init(writer: any DatabaseWriter) {
        self.writer = writer
    }

    // MARK: - Reads

    public func allWords() throws -> [Word] {
        try writer.read { db in
            try Self.fetchWords(in: db, where: nil)
        }
    }

    public func words(inCategoryNamed name: String) throws -> [Word] {
        try writer.read { db in
            try Self.fetchWords(in: db, where: name.lowercased())
        }
    }

    public func wordCount() throws -> Int {
        try writer.read { db in
            try WordRecord.all.fetchCount(db)
        }
    }

    public func allCategories() throws -> [ICoreModels.Category] {
        try writer.read { db in
            try CategoryRecord.all
                .order(by: \.name)
                .fetchAll(db)
                .map { ICoreModels.Category(id: $0.id, name: $0.name) }
        }
    }

    // MARK: - Helpers

    /// Fetches words plus their joined categories. If `categoryID` is provided, the result
    /// is filtered to words tagged with that category.
    private static func fetchWords(in db: Database, where categoryID: String?) throws -> [Word] {
        let wordRecords: [WordRecord]
        if let categoryID {
            wordRecords = try WordRecord
                .where { word in
                    WordCategoryRecord
                        .where { $0.wordID.eq(word.id) && $0.categoryID.eq(categoryID) }
                        .exists()
                }
                .fetchAll(db)
        } else {
            wordRecords = try WordRecord.all.fetchAll(db)
        }

        let wordIDs = wordRecords.map(\.id)
        let pivots = try WordCategoryRecord
            .where { $0.wordID.in(wordIDs) }
            .fetchAll(db)
        let categories = try CategoryRecord.all.fetchAll(db)
        let categoriesByID = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })

        var categoriesByWord: [String: [ICoreModels.Category]] = [:]
        for pivot in pivots {
            guard let record = categoriesByID[pivot.categoryID] else { continue }
            categoriesByWord[pivot.wordID, default: []]
                .append(ICoreModels.Category(id: record.id, name: record.name))
        }

        return wordRecords.map { record in
            Word(
                id: record.id,
                term: record.term,
                phonetic: record.phonetic,
                translation: record.translation,
                example: record.example,
                exampleTranslation: record.exampleTranslation,
                categories: categoriesByWord[record.id] ?? []
            )
        }
    }
}

// MARK: - Bundle loading

private let logger = Logger(subsystem: "vocabulary.com.ICoreDatabase", category: "VocabularyDatabase")
private let seedFileName = "vocabulary"
private let seedFileExtension = "sqlite"

private extension VocabularyDatabase {

    static func openBundledDatabase(bundle: Bundle) throws -> any DatabaseWriter {
        let destination = try copySeedIfNeeded(bundle: bundle)
        var configuration = Configuration()
        configuration.label = "vocabulary"
        let queue = try DatabaseQueue(path: destination.path, configuration: configuration)
        return queue
    }

    static func copySeedIfNeeded(bundle: Bundle) throws -> URL {
        guard let seed = bundle.url(forResource: seedFileName, withExtension: seedFileExtension) else {
            throw VocabularyDatabaseError.seedFileMissing
        }

        let fileManager = FileManager.default
        let supportDir = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let destination = supportDir.appendingPathComponent("\(seedFileName).\(seedFileExtension)")

        if fileManager.fileExists(atPath: destination.path) {
            return destination
        }

        try fileManager.copyItem(at: seed, to: destination)
        logger.info("seeded vocabulary database at \(destination.path, privacy: .public)")
        return destination
    }
}

public enum VocabularyDatabaseError: Error {
    case seedFileMissing
}
