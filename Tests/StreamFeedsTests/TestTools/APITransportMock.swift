//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
import StreamFeeds

final class APITransportMock: DefaultAPITransport {
    let decoder = PassthroughJSONDecoder()
    let responseResults = AllocatedUnfairLock<[APIResponse]>([])
    let requests = AllocatedUnfairLock<[Request]>([])

    func execute(request: Request) async throws -> (Data, URLResponse) {
        requests.withLock { $0.append(request) }
        let response = try consumeResponseResult(for: request)
        switch response {
        case .success(let payload):
            let id = UUID()
            decoder.payloads.withLock { $0[id] = payload }
            let response = HTTPURLResponse(
                url: request.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (Data(id.uuidString.utf8), response)
        case .failure(let failure):
            throw failure
        }
    }

    func consumeResponseResult(for request: Request) throws -> Result<any Sendable, Error> {
        try responseResults.withLock { responseResults in
            let matchingIndex = responseResults.firstIndex { response in
                switch response.matching {
                case .any:
                    return true
                case .pathPrefix(let prefix):
                    return request.url.path.hasPrefix(prefix)
                }
            }
            guard let matchingIndex else {
                throw ClientError.Unexpected("Mocked API request is not set for \(request)")
            }
            return responseResults.remove(at: matchingIndex).result
        }
    }
}

extension APITransportMock {
    enum RequestMatching {
        /// Response is used for any incoming request.
        case any
        /// Response is used only if path has the specified prefix.
        case pathPrefix(String)
    }

    struct APIResponse {
        let matching: RequestMatching
        let result: Result<any Sendable, Error>

        init(matching: RequestMatching, result: Result<any Sendable, Error>) {
            self.matching = matching
            self.result = result
        }

        init(matching: RequestMatching, payload: any Sendable) {
            self.matching = matching
            self.result = .success(payload)
        }
    }
}

extension APITransportMock {
    static func withMatchedResponses(_ responses: [APIResponse]) -> APITransportMock {
        let transport = APITransportMock()
        transport.responseResults.value = responses
        return transport
    }

    static func withPayloads(_ payloads: [any Sendable]) -> APITransportMock {
        let transport = APITransportMock()
        transport.responseResults.value = payloads.map { APIResponse(matching: .any, result: .success($0)) }
        return transport
    }
}

// Generated responses are Decodable only, so mocked responses are passed by an ID instead of JSON.
final class PassthroughJSONDecoder: JSONDecoder, @unchecked Sendable {
    let payloads = AllocatedUnfairLock<[UUID: any Sendable]>([:])

    override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let payload = UUID(uuidString: String(decoding: data, as: UTF8.self))
            .flatMap { id in payloads.withLock { $0.removeValue(forKey: id) } }
        guard let payload = payload as? T else {
            throw ClientError.Unexpected("Mocked payload \(String(describing: payload)) is not \(T.self)")
        }
        return payload
    }
}
