//
//  ActivityComposerViewModel.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 30.5.25.
//

import StreamCore
import StreamFeeds
import SwiftUI
import Combine
import Photos

@MainActor class ActivityComposerViewModel: ObservableObject {
    @Published public private(set) var imageAssets: PHFetchResult<PHAsset>?
    @Published public private(set) var addedAssets = [AddedAsset]()
    @Published public var text = ""
    @Published var createPollShown = false
    
    let attachmentsUploader: StreamAttachmentUploader
    let feed: Feed
    var requestEncoder: RequestEncoder
    let cdnClient: CDNClient
    var connectionProvider: ConnectionProvider?
    
    init(feed: Feed, feedsClient: FeedsClient) {
        self.feed = feed
        self.requestEncoder = DefaultRequestEncoder(baseURL: URL(string: "http://\(host):3030")!, apiKey: .init("892s22ypvt6m"))
        self.cdnClient = StreamCDNClient(
            encoder: requestEncoder,
            decoder: DefaultRequestDecoder(),
            sessionConfiguration: .default
        )
        self.attachmentsUploader = StreamAttachmentUploader(cdnClient: cdnClient)
        if let userAuth = feedsClient.userAuth {
            Task {
                let connectionId = try await userAuth.connectionId()
                connectionProvider = ConnectionProvider(
                    connectionId: connectionId,
                    token: feedsClient.token
                )
                self.requestEncoder.connectionDetailsProviderDelegate = connectionProvider
            }
        }
    }
    
    func askForPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            guard let self else { return }
            switch status {
            case .authorized, .limited:
                log.debug("Access to photos granted.")
                self.fetchAssets()
            case .denied, .restricted, .notDetermined:
                DispatchQueue.main.async { [weak self] in
                    self?.imageAssets = PHFetchResult<PHAsset>()
                }
                log.debug("Access to photos is denied or not determined, showing the no permissions screen.")
            @unknown default:
                log.debug("Unknown authorization status.")
            }
        }
    }
    
    func isImageSelected(with id: String) -> Bool {
        for image in addedAssets {
            if image.id == id {
                return true
            }
        }
        
        return false
    }
    
    func imageTapped(_ addedAsset: AddedAsset) {
        var images = [AddedAsset]()
        var imageRemoved = false
        for image in addedAssets {
            if image.id != addedAsset.id {
                images.append(image)
            } else {
                imageRemoved = true
            }
        }
        
        if !imageRemoved {
            images.append(addedAsset)
        }
        
        addedAssets = images
    }
    
    func publishPost() async throws {
        if text.isEmpty && addedAssets.isEmpty {
            return
        }
        
        let attachments = try addedAssets.map { try $0.toAttachmentPayload() }
        var uploadedAttachments = [Attachment]()
        for attachment in attachments {
            if let localFileURL = attachment.localFileURL {
                let attachmentFile = try AttachmentFile(url: localFileURL)
                let activityAttachment = StreamAttachment<Data>(
                    id: AttachmentId(fid: feed.fid.rawValue, activityId: UUID().uuidString, index: 0),
                    type: attachment.type,
                    payload: .init(),
                    downloadingState: nil,
                    uploadingState: .init(
                        localFileURL: localFileURL,
                        state: .pendingUpload, // will not be used
                        file: attachmentFile
                    )
                )
                let uploaded = try await upload(attachment: activityAttachment)
                uploadedAttachments.append(
                    Attachment(assetUrl: uploaded.remoteURL.absoluteString, custom: [:], imageUrl: uploaded.remoteURL.absoluteString)
                )
            }
        }
        _ = try await feed.addActivity(
            request: .init(attachments: uploadedAttachments, text: text, type: "activity")
        )
        text = ""
        addedAssets = []
    }
    
    func upload(attachment: AnyStreamAttachment) async throws -> UploadedAttachment {
        try await withCheckedThrowingContinuation { continuation in
            attachmentsUploader.upload(attachment, progress: nil) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    private func fetchAssets() {
        let fetchOptions = PHFetchOptions()
        let supportedTypes = GallerySupportedTypes.imagesAndVideo
        var predicate: NSPredicate?
        if supportedTypes == .images {
            predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.image.rawValue)")
        } else if supportedTypes == .videos {
            predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.video.rawValue)")
        }
        if let predicate {
            fetchOptions.predicate = predicate
        }
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.imageAssets = assets
        }
    }
}

public enum GallerySupportedTypes {
    case imagesAndVideo
    case images
    case videos
}
