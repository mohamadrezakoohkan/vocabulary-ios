import Testing
import Foundation
@testable import ICoreNetwork

// MARK: - Mock URLProtocol

private final class MockURLProtocol: URLProtocol, @unchecked Sendable {

    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.requestHandler else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// MARK: - Helpers

private func makeMockSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

private func makeAPIResponse(imageURL: String = "https://example.com/image.jpg") -> Data {
    """
    {
        "result_count": 1,
        "results": [{
            "id": "abc-123",
            "title": "Test Image",
            "url": "\(imageURL)",
            "thumbnail": "https://example.com/thumb.jpg",
            "creator": "tester",
            "license": "by",
            "attribution": "Test attribution",
            "width": 800,
            "height": 600
        }]
    }
    """.data(using: .utf8)!
}

private func makeEmptyAPIResponse() -> Data {
    """
    {
        "result_count": 0,
        "results": []
    }
    """.data(using: .utf8)!
}

private let fakeImageData = Data("fake-image-bytes".utf8)

// MARK: - Tests

struct ImageServiceTests {

    @Test func fetchImageReturnsDataForValidQuery() async throws {
        let session = makeMockSession()
        var requestCount = 0

        MockURLProtocol.requestHandler = { request in
            requestCount += 1
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            if requestCount == 1 {
                // First call: API metadata
                return (response, makeAPIResponse())
            } else {
                // Second call: image download
                return (response, fakeImageData)
            }
        }

        let service = ImageService(session: session)
        let data = try await service.fetchImage(query: ["apple"])

        #expect(data != nil)
        #expect(data == fakeImageData)
    }

    @Test func fetchImageReturnsNilForEmptyResults() async throws {
        let session = makeMockSession()

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, makeEmptyAPIResponse())
        }

        let service = ImageService(session: session)
        let data = try await service.fetchImage(query: ["xyznonexistent"])

        #expect(data == nil)
    }

    @Test func fetchImageJoinsMultipleWordsWithPlus() async throws {
        let session = makeMockSession()
        var capturedURL: URL?
        var requestCount = 0

        MockURLProtocol.requestHandler = { request in
            requestCount += 1
            capturedURL = capturedURL ?? request.url
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            if requestCount == 1 {
                return (response, makeAPIResponse())
            } else {
                return (response, fakeImageData)
            }
        }

        let service = ImageService(session: session)
        _ = try await service.fetchImage(query: ["red", "apple", "fruit"])

        let query = capturedURL?.query ?? ""
        #expect(query.contains("q=red+apple+fruit") || query.contains("q=red%2Bapple%2Bfruit"))
    }

    @Test func fetchImageLowercasesQuery() async throws {
        let session = makeMockSession()
        var capturedURL: URL?
        var requestCount = 0

        MockURLProtocol.requestHandler = { request in
            requestCount += 1
            capturedURL = capturedURL ?? request.url
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            if requestCount == 1 {
                return (response, makeAPIResponse())
            } else {
                return (response, fakeImageData)
            }
        }

        let service = ImageService(session: session)
        _ = try await service.fetchImage(query: ["Apple", "PIE"])

        let query = capturedURL?.query ?? ""
        #expect(query.contains("q=apple") || query.contains("q=apple%2Bpie"))
    }

    @Test func fetchImageUsesCommercialLicenseAndPageSize1() async throws {
        let session = makeMockSession()
        var capturedURL: URL?
        var requestCount = 0

        MockURLProtocol.requestHandler = { request in
            requestCount += 1
            capturedURL = capturedURL ?? request.url
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            if requestCount == 1 {
                return (response, makeAPIResponse())
            } else {
                return (response, fakeImageData)
            }
        }

        let service = ImageService(session: session)
        _ = try await service.fetchImage(query: ["cat"])

        let query = capturedURL?.query ?? ""
        #expect(query.contains("license_type=commercial"))
        #expect(query.contains("page_size=1"))
    }

    @Test func fetchImageReturnsCachedDataOnSecondCall() async throws {
        let session = makeMockSession()
        var networkCallCount = 0

        MockURLProtocol.requestHandler = { request in
            networkCallCount += 1
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            if networkCallCount <= 2 {
                // First fetch: API call + image download
                return networkCallCount == 1
                    ? (response, makeAPIResponse())
                    : (response, fakeImageData)
            } else {
                // Should not reach here on cached call
                return (response, Data())
            }
        }

        let service = ImageService(session: session)

        let firstResult = try await service.fetchImage(query: ["cachedtest"])
        let callsAfterFirst = networkCallCount

        let secondResult = try await service.fetchImage(query: ["cachedtest"])
        let callsAfterSecond = networkCallCount

        #expect(firstResult == fakeImageData)
        #expect(secondResult == fakeImageData)
        #expect(callsAfterFirst == 2) // API + image download
        #expect(callsAfterSecond == 2) // no additional network calls
    }

    @Test func openverseResponseDecodesCorrectly() throws {
        let json = makeAPIResponse(imageURL: "https://example.com/photo.jpg")
        let response = try JSONDecoder().decode(OpenverseResponse.self, from: json)

        #expect(response.resultCount == 1)
        #expect(response.results.count == 1)
        #expect(response.results[0].id == "abc-123")
        #expect(response.results[0].title == "Test Image")
        #expect(response.results[0].url == "https://example.com/photo.jpg")
        #expect(response.results[0].creator == "tester")
        #expect(response.results[0].license == "by")
        #expect(response.results[0].width == 800)
        #expect(response.results[0].height == 600)
    }

    @Test func openverseResponseDecodesWithNullOptionals() throws {
        let json = """
        {
            "result_count": 1,
            "results": [{
                "id": "def-456",
                "title": "Minimal",
                "url": "https://example.com/img.jpg",
                "thumbnail": "https://example.com/thumb.jpg",
                "creator": null,
                "license": "by-sa",
                "attribution": null,
                "width": null,
                "height": null
            }]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(OpenverseResponse.self, from: json)

        #expect(response.results[0].creator == nil)
        #expect(response.results[0].attribution == nil)
        #expect(response.results[0].width == nil)
        #expect(response.results[0].height == nil)
    }
}
