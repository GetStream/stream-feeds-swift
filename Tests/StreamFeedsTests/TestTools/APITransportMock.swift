//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class APITransportMock: DefaultAPITransport {
    let responsePayloads = AllocatedUnfairLock<[any Encodable]>([])
    
    func execute(request: StreamCore.Request) async throws -> (Data, URLResponse) {
        let payload = try responsePayloads.withLock { payloads in
            guard !payloads.isEmpty else { throw ClientError.Unexpected("Please setup responses") }
            return payloads.removeFirst()
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
}

extension APITransportMock {
    static func withPayloads(_ payloads: [any Encodable]) -> APITransportMock {
        let transport = APITransportMock()
        transport.responsePayloads.value = payloads
        return transport
    }
}
