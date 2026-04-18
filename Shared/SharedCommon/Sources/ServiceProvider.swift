//
//  ServiceProvider.swift
//  Vocabulary
//
//  Created by Mohammad reza on 18/4/26.
//

import Foundation
import SwiftUI
import ICoreFoundation
import ICoreModels
import ICoreNetwork

/// A protocol defining the application's service layer.
///
/// Provides access to shared services such as text-to-speech and image fetching.
/// Conform to this protocol to create custom service configurations for testing or previews.
///
public protocol IServiceProvider {
    var textToSpeechService: ITextToSpeechService { get }
    var imageService: IImageService { get }
    var wordService: IWordService { get }
}

/// The default concrete implementation of ``IServiceProvider``.
///
/// Bundles production service instances together. Inject at the app root using
/// the SwiftUI environment and resolve in any descendant view:
///
/// ```swift
/// // Inject at root:
/// ContentView()
///     .environment(\.serviceProvider, serviceProvider)
///
/// // Resolve in a view:
/// @Environment(\.serviceProvider) private var serviceProvider
/// ```
///
public final class ServiceProvider: IServiceProvider {
    public var textToSpeechService: any ITextToSpeechService
    public var imageService: any IImageService
    public var wordService: any IWordService

    public init(
        textToSpeechService: any ITextToSpeechService = TextToSpeechService(),
        imageService: any IImageService = ImageService(),
        wordService: any IWordService = WordService()
    ) {
        self.textToSpeechService = textToSpeechService
        self.imageService = imageService
        self.wordService = wordService
    }
}

// MARK: - Environment

/// The environment key used to store and retrieve the ``IServiceProvider``.
///
/// Defaults to a ``ServiceProvider`` instance with production services.
///
private struct ServiceProviderKey: EnvironmentKey {
    static let defaultValue: any IServiceProvider = ServiceProvider()
}

extension EnvironmentValues {
    /// The application's service provider, accessible via `@Environment(\.serviceProvider)`.
    ///
    public var serviceProvider: any IServiceProvider {
        get { self[ServiceProviderKey.self] }
        set { self[ServiceProviderKey.self] = newValue }
    }
}
