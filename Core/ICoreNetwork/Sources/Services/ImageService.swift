import Foundation

// MARK: - API Response Models

/// Represents the top-level response from the Openverse image search API.
struct OpenverseResponse: Decodable {
    let resultCount: Int
    let results: [OpenverseImage]

    enum CodingKeys: String, CodingKey {
        case resultCount = "result_count"
        case results
    }
}

/// Represents a single image result from Openverse.
struct OpenverseImage: Decodable {
    let id: String
    let title: String
    let url: String
    let thumbnail: String
    let creator: String?
    let license: String
    let attribution: String?
    let width: Int?
    let height: Int?
}

// MARK: - Protocol

/// A service that fetches commercially-licensed images from Openverse and caches them locally.
///
/// Images are cached on disk per query. Subsequent requests for the same query
/// load directly from the cache without making a network call.
public protocol IImageService {

    /// Fetches an image for the given query words.
    ///
    /// Words are joined with `+` to form the search query (e.g. `["red", "apple"]` becomes `red+apple`).
    /// The result is cached on disk; subsequent calls return the cached image data.
    ///
    /// - Parameter query: One or more words describing the image to search for.
    /// - Returns: The image data (JPEG/PNG) on success, or `nil` if no result was found.
    func fetchImage(query: [String]) async throws -> Data?

    /// Fetches the URL of a commercially-licensed image for the given query string.
    ///
    /// - Parameter query: A search query string (words joined with `+`).
    /// - Returns: The image URL on success, or `nil` if no result was found.
    func fetchImageURL(query: String) async throws -> URL?
}

// MARK: - Implementation

/// Concrete implementation of ``IImageService`` using the Openverse API.
public final class ImageService: IImageService {

    private let session: URLSession
    private let cacheDirectory: URL

    public init(session: URLSession = .shared) {
        self.session = session
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.cacheDirectory = caches.appendingPathComponent("OpenverseImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    public func fetchImage(query: [String]) async throws -> Data? {
        let key = query.joined(separator: "+").lowercased()

        // Check cache first
        let cachedFile = cacheDirectory.appendingPathComponent(key)
        if FileManager.default.fileExists(atPath: cachedFile.path) {
            return try Data(contentsOf: cachedFile)
        }

        // Fetch image metadata from Openverse
        let imageURL = try await fetchImageURL(query: key)
        guard let imageURL else { return nil }

        // Download the image
        let (data, _) = try await session.data(from: imageURL)

        // Cache to disk
        try data.write(to: cachedFile)

        return data
    }

    public func fetchImageURL(query: String) async throws -> URL? {
        var components = URLComponents(string: "a")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "license_type", value: "commercial"),
            URLQueryItem(name: "page_size", value: "1")
        ]

        guard let url = components.url else { return nil }

        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(OpenverseResponse.self, from: data)

        guard let firstResult = response.results.first,
              let imageURL = URL(string: firstResult.url) else {
            return nil
        }

        return imageURL
    }
}
