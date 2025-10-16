//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
import StreamFeeds
import StreamOpenAPI

final class APITransportMock: DefaultAPITransport {
    let responsePayloads = AllocatedUnfairLock<[any Encodable]>([])

    func execute(request: StreamOpenAPI.Request) async throws -> (Data, URLResponse) {
        let payload = try responsePayloads.withLock { payloads in
            try Self.consumeResponsePayload(for: request, from: &payloads)
        }
        let data = try CodableHelper.jsonEncoder.encode(payload)
        let response = HTTPURLResponse(
            url: request.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (data, response)
    }

    private static func consumeResponsePayload(for request: StreamOpenAPI.Request, from payloads: inout [any Encodable]) throws -> any Encodable {
        let payloadIndex = payloads.firstIndex { payload in
            switch payload.self {
            case is GetActivityResponse:
                request.url.path.hasPrefix("/api/v2/feeds/activities/")
            case is GetCommentsResponse:
                request.url.path.hasPrefix("/api/v2/feeds/comments")
            default:
                // Otherwise just pick the first. Custom matching is needed only for tests which run API
                // requests in parallel so the order of responsePayload does not match with the order of
                // execute(request:) calls.
                true
            }
        }
        guard let payloadIndex else {
            throw ClientError("Response payload is not available for request: \(request)")
        }
        return payloads.remove(at: payloadIndex)
    }
}

extension APITransportMock {
    static func withPayloads(_ payloads: [any Encodable]) -> APITransportMock {
        let transport = APITransportMock()
        transport.responsePayloads.value = payloads
        return transport
    }
}
