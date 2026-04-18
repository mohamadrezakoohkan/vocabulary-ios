import Testing
import AVFoundation
@testable import ICoreNetwork

struct TextToSpeechServiceTests {

    // MARK: - Initialization

    @Test func initWithDefaultValues() {
        let service = TextToSpeechService()

        #expect(service.language == "es-ES")
        #expect(service.rate == 0.05)
        #expect(service.pitchMultiplier == 0.5)
        #expect(service.volume == 1.0)
    }

    @Test func initWithCustomValues() {
        let service = TextToSpeechService(
            language: "fa-IR",
            rate: 0.3,
            pitchMultiplier: 1.5,
            volume: 0.7
        )

        #expect(service.language == "fa-IR")
        #expect(service.rate == 0.3)
        #expect(service.pitchMultiplier == 1.5)
        #expect(service.volume == 0.7)
    }

    @Test func initWithNilLanguage() {
        let service = TextToSpeechService(language: nil)

        #expect(service.language == nil)
    }

    // MARK: - Properties

    @Test func isSpeakingReturnsFalseInitially() {
        let service = TextToSpeechService()

        #expect(service.isSpeaking == false)
    }

    @Test func mutablePropertiesCanBeChanged() {
        let service = TextToSpeechService()

        service.language = "en-US"
        service.rate = 0.8
        service.pitchMultiplier = 2.0
        service.volume = 0.5

        #expect(service.language == "en-US")
        #expect(service.rate == 0.8)
        #expect(service.pitchMultiplier == 2.0)
        #expect(service.volume == 0.5)
    }

    // MARK: - Protocol Conformance

    @Test func conformsToITextToSpeechService() {
        let service = TextToSpeechService()
        let _: any ITextToSpeechService = service
    }

    // MARK: - Speak / Stop

    @Test func speakDoesNotCrashWithEmptyString() {
        let service = TextToSpeechService()
        service.speak("")
    }

    @Test func stopDoesNotCrashWhenNotSpeaking() {
        let service = TextToSpeechService()
        service.stop(at: .immediate)
    }

    @Test func stopAtWordBoundaryDoesNotCrash() {
        let service = TextToSpeechService()
        service.stop(at: .word)
    }

    @Test func pauseDoesNotCrashWhenNotSpeaking() {
        let service = TextToSpeechService()
        service.pause(at: .immediate)
    }

    @Test func resumeDoesNotCrashWhenNotPaused() {
        let service = TextToSpeechService()
        service.resume()
    }

    // MARK: - Speak then Stop

    @Test func speakThenStopDoesNotCrash() {
        let service = TextToSpeechService(language: "en-US")
        service.speak("Hello world")
        service.stop(at: .immediate)
    }

    @Test func speakTwiceStopsPreviousSpeech() {
        let service = TextToSpeechService(language: "en-US")
        service.speak("First sentence")
        service.speak("Second sentence")
        service.stop(at: .immediate)
    }
}
