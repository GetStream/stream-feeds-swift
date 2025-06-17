//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// An uploaded file.
public struct UploadedFile: Decodable {
    public let fileURL: URL
    public let thumbnailURL: URL?

    public init(fileURL: URL, thumbnailURL: URL? = nil) {
        self.fileURL = fileURL
        self.thumbnailURL = thumbnailURL
    }
}

/// The CDN client is responsible to upload files to a CDN.
public protocol CDNClient {
    static var maxAttachmentSize: Int64 { get }

    /// Uploads attachment as a multipart/form-data and returns only the uploaded remote file.
    /// - Parameters:
    ///   - attachment: An attachment to upload.
    ///   - progress: A closure that broadcasts upload progress.
    ///   - completion: Returns the uploaded file's information.
    func uploadAttachment(
        _ attachment: AnyChatMessageAttachment,
        progress: ((Double) -> Void)?,
        completion: @escaping (Result<URL, Error>) -> Void
    )

    /// Uploads attachment as a multipart/form-data and returns the uploaded remote file and its thumbnail.
    /// - Parameters:
    ///   - attachment: An attachment to upload.
    ///   - progress: A closure that broadcasts upload progress.
    ///   - completion: Returns the uploaded file's information.
    func uploadAttachment(
        _ attachment: AnyChatMessageAttachment,
        progress: ((Double) -> Void)?,
        completion: @escaping (Result<UploadedFile, Error>) -> Void
    )
}

public extension CDNClient {
    func uploadAttachment(
        _ attachment: AnyChatMessageAttachment,
        progress: ((Double) -> Void)?,
        completion: @escaping (Result<UploadedFile, Error>) -> Void
    ) {
        uploadAttachment(attachment, progress: progress, completion: { (result: Result<URL, Error>) in
            switch result {
            case let .success(url):
                completion(.success(UploadedFile(fileURL: url, thumbnailURL: nil)))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}

/// Default implementation of CDNClient that uses Stream CDN
class StreamCDNClient: CDNClient {
    static var maxAttachmentSize: Int64 { 100 * 1024 * 1024 }

    private let decoder: RequestDecoder
    private let encoder: RequestEncoder
    private let session: URLSession
    /// Keeps track of uploading tasks progress
    @Atomic private var taskProgressObservers: [Int: NSKeyValueObservation] = [:]

    init(
        encoder: RequestEncoder,
        decoder: RequestDecoder,
        sessionConfiguration: URLSessionConfiguration
    ) {
        self.encoder = encoder
        session = URLSession(configuration: sessionConfiguration)
        self.decoder = decoder
    }

    func uploadAttachment(
        _ attachment: AnyChatMessageAttachment,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        uploadAttachment(attachment, progress: progress, completion: { (result: Result<UploadedFile, Error>) in
            switch result {
            case let .success(file):
                completion(.success(file.fileURL))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    func uploadAttachment(
        _ attachment: AnyChatMessageAttachment,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<UploadedFile, Error>) -> Void
    ) {
        guard
            let uploadingState = attachment.uploadingState,
            let fileData = try? Data(contentsOf: uploadingState.localFileURL) else {
            return completion(.failure(ClientError.AttachmentUploading(id: attachment.id)))
        }
        // Encode locally stored attachment into multipart form data
        let multipartFormData = MultipartFormData(
            fileData,
            fileName: uploadingState.localFileURL.lastPathComponent,
            mimeType: uploadingState.file.type.mimeType
        )
        let endpoint = Endpoint<FileUploadPayload>.uploadAttachment(type: attachment.type)

        encoder.encodeRequest(for: endpoint) { [weak self] (requestResult) in
            var urlRequest: URLRequest
            do {
                urlRequest = try requestResult.get()
            } catch {
                log.error(error, subsystems: .httpRequests)
                completion(.failure(error))
                return
            }

            let data = multipartFormData.getMultipartFormData()
            urlRequest.addValue("multipart/form-data; boundary=\(MultipartFormData.boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("stream-feeds-swift-v0.0.1", forHTTPHeaderField: "X-Stream-Client") //TODO: fix this.
            urlRequest.httpBody = data

            guard let self = self else {
                log.warning("Callback called while self is nil", subsystems: .httpRequests)
                return
            }
            
            print("======= \(urlRequest.cURLRepresentation(for: self.session))")

            let task = self.session.dataTask(with: urlRequest) { [decoder = self.decoder] (data, response, error) in
                do {
                    let response: FileUploadPayload = try decoder.decodeRequestResponse(
                        data: data,
                        response: response,
                        error: error
                    )
                    let file = UploadedFile(fileURL: response.fileURL, thumbnailURL: response.thumbURL)

                    completion(.success(file))
                } catch {
                    completion(.failure(error))
                }
            }

            if let progressListener = progress {
                let taskID = task.taskIdentifier
                self._taskProgressObservers.mutate { observers in
                    var updatedObservers = observers
                    updatedObservers[taskID] = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
                        progressListener(progress.fractionCompleted)
                        if progress.isFinished || progress.isCancelled {
                            self?._taskProgressObservers.mutate { observers in
                                var updated = observers
                                updated[taskID]?.invalidate()
                                updated[taskID] = nil
                                return updated
                            }
                        }
                    }
                    return updatedObservers
                }
            }

            task.resume()
        }
    }
}

/// A file upload response.
struct FileUploadPayload: Decodable {
    let fileURL: URL
    let thumbURL: URL?

    enum CodingKeys: String, CodingKey {
        case fileURL = "file"
        case thumbURL = "thumb_url"
    }
}

extension URLRequest {
    /// Gives cURL representation of the request for an easy API request reproducibility in Terminal.
    /// - Parameter urlSession: The URLSession handling the request.
    /// - Returns: cURL representation of the URLRequest.
    func cURLRepresentation(for urlSession: URLSession) -> String {
        guard let url, let httpMethod else { return "$ curl failed to create" }
        var cURL = [String]()
        cURL.append("$ curl -v")
        cURL.append("-X \(httpMethod)")
        
        var allHeaders = [String: String]()
        if let additionalHeaders = urlSession.configuration.httpAdditionalHeaders as? [String: String] {
            allHeaders.merge(additionalHeaders, uniquingKeysWith: { _, new in new })
        }
        if let allHTTPHeaderFields {
            allHeaders.merge(allHTTPHeaderFields, uniquingKeysWith: { _, new in new })
        }
        cURL.append(contentsOf: allHeaders
            .mapValues { $0.replacingOccurrences(of: "\"", with: "\\\"") }
            .map { "-H \"\($0.key): \($0.value)\"" }
        )
        if let httpBody {
            let httpBodyString = String(decoding: httpBody, as: UTF8.self)
            let escapedBody = httpBodyString
                .replacingOccurrences(of: "\\\"", with: "\\\\\"")
                .replacingOccurrences(of: "\"", with: "\\\"")
            cURL.append("-d \"\(escapedBody)\"")
        }
        let urlString = url.absoluteString
            .replacingOccurrences(of: "$", with: "%24") // encoded JSON payload
        cURL.append("\"\(urlString)\"")
        return cURL.joined(separator: " \\\n\t")
    }
}
