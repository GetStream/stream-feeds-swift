//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
import StreamFeeds

struct Snippets_03_03_FileUploads {
    private var client: FeedsClient!
    private var feed: Feed!
    private var attachmentUploader: AttachmentUploader
    private var uploadedAttachments = [Attachment]()
    
    func howToUploadAFileOrImage_1() async throws {
        func uploadAttachmentPayloads(_ attachments: [AnyAttachmentPayload], in feed: FeedId) async throws -> [Attachment] {
            let dataAttachments: [StreamAttachment<Data>] = try attachments
                .filter { $0.localFileURL != nil }
                .enumerated()
                .compactMap { index, attachment in
                    guard let localFileURL = attachment.localFileURL else { return nil }
                    let attachmentFile = try AttachmentFile(url: localFileURL)
                    let payloadData = try JSONEncoder().encode(attachment.payload)
                    try Task.checkCancellation()
                    return StreamAttachment<Data>(
                        id: AttachmentId(
                            fid: feed.rawValue,
                            activityId: UUID().uuidString,
                            index: index
                        ),
                        type: attachment.type,
                        payload: payloadData,
                        downloadingState: nil,
                        uploadingState: .init(
                            localFileURL: localFileURL,
                            state: .pendingUpload, // will not be used
                            file: attachmentFile
                        )
                    )
                }
            return try await attachmentUploader.upload(dataAttachments, progress: nil)
                .map { uploadedAttachment in
                    Attachment(
                        assetUrl: uploadedAttachment.remoteURL.absoluteString,
                        custom: [:],
                        imageUrl: uploadedAttachment.remoteURL.absoluteString
                    )
                }
        }
    }
    
    func howToUploadAFileOrImage_2() async throws {
        let activity = try await feed.addActivity(
            request: .init(
                attachments: uploadedAttachments,
                text: "Hi",
                type: "activity"
            )
        )
        
        suppressUnusedWarning(activity)
    }
    
    func howToUploadAFileOrImage_3() async throws {
        let payloads: [AnyAttachmentPayload] = [] // set payloads
        let activity = try await feed.addActivity(
            request: .init(
                attachmentUploads: payloads,
                text: "Hi",
                type: "activity"
            )
        )
        
        suppressUnusedWarning(activity)
    }
    
    func usingYourOwnCDN() async throws {
        // Your custom implementation of `CDNClient`.
        class CustomCDN: CDNClient, @unchecked Sendable {
            static var maxAttachmentSize: Int64 { 20 * 1024 * 1024 }
            
            func uploadAttachment(
                _ attachment: AnyStreamAttachment,
                progress: (@Sendable (Double) -> Void)?,
                completion: @Sendable @escaping (Result<URL, Error>) -> Void
            ) {
                if let imageAttachment = attachment.attachment(payloadType: ImageAttachmentPayload.self) {
                    // Your code to handle image uploading.
                    // Don't forget to call `progress(x)` to report back the uploading progress.
                    // When the uploading is finished, call the completion block with the result.
                    uploadImage(imageAttachment, progress: progress)
                } else if let fileAttachment = attachment.attachment(payloadType: FileAttachmentPayload.self) {
                    // Your code to handle file uploading.
                    // Don't forget to call `progress(x)` to report back the uploading progress.
                    // When the uploading is finished, call the completion block with the result.
                    uploadFile(fileAttachment, progress: progress)
                } else {
                    // Unsupported attachment type
                    struct UnsupportedAttachmentType: Error {}
                    completion(.failure(UnsupportedAttachmentType()))
                }
            }
        }
        
        // Assign your custom CDN client to the `FeedsConfig` instance you use
        // when creating `FeedsClient`.
        let config = FeedsConfig(customCDNClient: CustomCDN())
        let client = FeedsClient(
            apiKey: APIKey("api key"),
            user: User(id: "user_id"),
            token: UserToken("my token"),
            feedsConfig: config
        )
        
        suppressUnusedWarning(client)
        func uploadImage(_ attachment: StreamAttachment<ImageAttachmentPayload>, progress: (@Sendable (Double) -> Void)?) {}
        func uploadFile(_ attachment: StreamAttachment<FileAttachmentPayload>, progress: (@Sendable (Double) -> Void)?) {}
    }
}
