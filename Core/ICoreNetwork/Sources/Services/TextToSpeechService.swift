import AVFoundation

/// A protocol that defines a text-to-speech service capable of reading text aloud.
///
/// Use conforming types to convert strings into spoken audio output.
/// The service supports playback controls such as pausing, resuming, and stopping speech.
///
public protocol ITextToSpeechService {

    /// Whether the service is currently speaking.
    ///
    var isSpeaking: Bool { get }

    /// Speaks the given text aloud.
    /// - Parameter text: The string to read aloud.
    func speak(_ text: String)

    /// Stops any ongoing speech.
    /// - Parameter boundary: Whether to stop immediately or at the next word boundary.
    func stop(at boundary: AVSpeechBoundary)

    /// Pauses ongoing speech.
    /// - Parameter boundary: Whether to pause immediately or at the next word boundary.
    func pause(at boundary: AVSpeechBoundary)

    /// Resumes previously paused speech.
    func resume()
}

/// A service that reads text aloud using the system speech synthesizer.
///
public final class TextToSpeechService: ITextToSpeechService {

    private let synthesizer = AVSpeechSynthesizer()

    /// The language/locale for speech (e.g. "en-US", "es-ES"). Defaults to the device locale.
    ///
    public var language: String?

    /// Speech rate between 0.0 (slowest) and 1.0 (fastest).
    ///
    public var rate: Float

    /// Pitch multiplier between 0.5 and 2.0.
    ///
    public var pitchMultiplier: Float

    /// Volume between 0.0 and 1.0.
    ///
    public var volume: Float

    public init(
        language: String? = "es-ES",
        rate: Float = 0.05,
        pitchMultiplier: Float = 0.5,
        volume: Float = 1.0
    ) {
        self.language = language
        self.rate = rate
        self.pitchMultiplier = pitchMultiplier
        self.volume = volume
    }

    /// Whether the synthesizer is currently speaking.
    ///
    public var isSpeaking: Bool {
        synthesizer.isSpeaking
    }

    /// Speaks the given text aloud.
    /// - Parameter text: The string to speak.
    ///
    public func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = pitchMultiplier
        utterance.volume = volume

        if let language {
            utterance.voice = AVSpeechSynthesisVoice(language: language)
        }

        synthesizer.speak(utterance)
    }

    /// Stops any ongoing speech.
    /// - Parameter boundary: Whether to stop immediately or at the next word boundary.
    ///
    public func stop(at boundary: AVSpeechBoundary = .immediate) {
        synthesizer.stopSpeaking(at: boundary)
    }

    /// Pauses ongoing speech.
    /// - Parameter boundary: Whether to pause immediately or at the next word boundary.
    ///
    public func pause(at boundary: AVSpeechBoundary = .immediate) {
        synthesizer.pauseSpeaking(at: boundary)
    }

    /// Resumes paused speech.
    ///
    public func resume() {
        synthesizer.continueSpeaking()
    }
}
