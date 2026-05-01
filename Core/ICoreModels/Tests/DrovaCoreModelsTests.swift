import Testing
@testable import ICoreModels

struct WordTests {

    @Test func word_derivesIDFromTermAndTranslation() {
        let word = Word(term: "Hola", translation: "Hello")
        #expect(word.id == "hola_hello")
    }

    @Test func word_acceptsExplicitID() {
        let word = Word(id: "custom-id", term: "hola", translation: "hello")
        #expect(word.id == "custom-id")
    }
}
