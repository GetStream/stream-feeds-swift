//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

struct Snippets_03_03_FileUploads {
    private var client: FeedsClient!
    private var feed: Feed!
    private var attachmentUploader: AttachmentUploader
    private var uploadedAttachments = [Attachment]()
    
    func howToUploadAFileOrImage_1() async throws {
        func uploadAttachmentPayloads(_ attachments: [AnyAttachmentPayload], in fid: FeedId) async throws -> [Attachment] {
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
                            fid: fid.rawValue,
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
    }
}
