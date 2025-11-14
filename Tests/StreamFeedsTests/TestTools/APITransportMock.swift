//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
import StreamFeeds

final class APITransportMock: DefaultAPITransport {
    let responseResults = AllocatedUnfairLock<[APIResponse]>([])
    
    func execute(request: Request) async throws -> (Data, URLResponse) {
        let response = try consumeResponseResult(for: request)
        switch response {
        case .success(let payload):
            let data = try CodableHelper.jsonEncoder.encode(payload)
            let response = HTTPURLResponse(
                url: request.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data, response)
        case .failure(let failure):
            throw failure
        }
    }
    
    func consumeResponseResult(for request: Request) throws -> Result<any Encodable, Error> {
        try responseResults.withLock { responseResults in
            let matchingIndex = responseResults.firstIndex { response in
                switch response.matching {
                case .any:
                    return true
                case .pathPrefix(let prefix):
                    return request.url.path.hasPrefix(prefix)
                case .bodyType(let bodyType):
                    guard let body = request.body else { return false }
                    return (try? CodableHelper.jsonDecoder.decode(bodyType, from: body)) != nil
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
        /// Response is used only if ``Request\body`` has data matching with the specified type.
        ///
        /// Example: `QueryFeedsRequest` should be matched when response is `QueryFeedsResponse`
        case bodyType(Decodable.Type)
    }
    
    struct APIResponse {
        let matching: RequestMatching
        let result: Result<any Encodable, Error>
        
        init(matching: RequestMatching, result: Result<any Encodable, Error>) {
            self.matching = matching
            self.result = result
        }
        
        init(matching: RequestMatching, payload: any Encodable) {
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
    
    static func withPayloads(_ payloads: [any Encodable]) -> APITransportMock {
        let transport = APITransportMock()
        transport.responseResults.value = payloads.map { APIResponse(matching: .any, result: .success($0)) }
        return transport
    }
}
