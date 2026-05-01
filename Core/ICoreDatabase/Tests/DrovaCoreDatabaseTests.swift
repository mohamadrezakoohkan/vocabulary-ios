import Testing
import Foundation
@testable import ICoreDatabase

struct VocabularyDatabaseTests {

    @Test func bundledDatabase_loadsWords() throws {
        let database = try VocabularyDatabase()

        let count = try database.wordCount()
        #expect(count > 0)

        let words = try database.allWords()
        #expect(words.count == count)
    }

    @Test func bundledDatabase_seedsA1Category() throws {
        let database = try VocabularyDatabase()

        let categories = try database.allCategories()
        #expect(categories.contains { $0.name == "a1" })

        let a1Words = try database.words(inCategoryNamed: "a1")
        #expect(!a1Words.isEmpty)
    }
}
