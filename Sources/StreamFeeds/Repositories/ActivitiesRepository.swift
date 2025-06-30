//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class ActivitiesRepository: Sendable {
    private let apiClient: DefaultAPI
    private let attachmentUploader: StreamAttachmentUploader
    
    init(apiClient: DefaultAPI, attachmentUploader: StreamAttachmentUploader) {
        self.apiClient = apiClient
        self.attachmentUploader = attachmentUploader
    }
    
    // MARK: - Activities
    
    func addActivity(request: AddActivityRequest) async throws -> ActivityData {
        let response = try await apiClient.addActivity(addActivityRequest: request)
        return response.activity.toModel()
    }
    
    func addActivity(request: FeedAddActivityRequest, in fid: FeedId) async throws -> ActivityData {
        let uploadedAttachments: [Attachment] = try await {
            guard let payloads = request.attachmentUploads, !payloads.isEmpty else { return [] }
            return try await uploadAttachmentPayloads(payloads, in: fid)
        }()
        return try await addActivity(request: request.withFid(fid, uploadedAttachments: uploadedAttachments))
    }
        
    func deleteActivity(activityId: String, hardDelete: Bool) async throws {
        _ = try await apiClient.deleteActivity(activityId: activityId, hardDelete: hardDelete)
    }
    
    func getActivity(activityId: String) async throws -> ActivityData {
        let response = try await apiClient.getActivity(activityId: activityId)
        return response.activity.toModel()
    }

    func updateActivity(activityId: String, request: UpdateActivityRequest) async throws -> ActivityData {
        let response = try await apiClient.updateActivity(activityId: activityId, updateActivityRequest: request)
        return response.activity.toModel()
    }
    
    // MARK: - Activity Attachment Uploading
    
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
                        activityId: UUID().uuidString, //TODO: how do we know this?
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
    
    // MARK: - Activity Batch Operations
    
    func upsertActivities(_ activities: [ActivityRequest]) async throws -> [ActivityData] {
        let response = try await apiClient.upsertActivities(upsertActivitiesRequest: UpsertActivitiesRequest(activities: activities))
        return response.activities.map { $0.toModel() }
    }
    
    // MARK: - Activity Interactions
    
    func markActivity(feedGroupId: String, feedId: String, request: MarkActivityRequest) async throws {
        _ = try await apiClient.markActivity(feedGroupId: feedGroupId, feedId: feedId, markActivityRequest: request)
    }
    
    // MARK: - Activity Pagination
    
    func queryActivities(with query: ActivitiesQuery) async throws -> PaginationResult<ActivityData> {
        let response = try await apiClient.queryActivities(queryActivitiesRequest: query.toRequest())
        return PaginationResult(
            models: response.activities.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    // MARK: - Bookmarks
    
    func addBookmark(activityId: String) async throws -> BookmarkData {
        let response = try await apiClient.addBookmark(activityId: activityId, addBookmarkRequest: .init())
        return response.bookmark.toModel()
    }
    
    func removeBookmark(activityId: String, folderId: String?) async throws -> BookmarkData {
        let response = try await apiClient.deleteBookmark(activityId: activityId, folderId: folderId)
        return response.bookmark.toModel()
    }
    
    // MARK: - Reactions
    
    func addReaction(activityId: String, request: AddReactionRequest) async throws -> FeedsReactionData {
        let response = try await apiClient.addReaction(activityId: activityId, addReactionRequest: request)
        return response.reaction.toModel()
    }
    
    func removeReaction(activityId: String, type: String) async throws -> FeedsReactionData {
        let response = try await apiClient.deleteActivityReaction(activityId: activityId, type: type)
        return response.reaction.toModel()
    }
}
