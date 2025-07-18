//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Photos
import StreamCore
import StreamFeeds
import SwiftUI

@MainActor class ActivityComposerViewModel: ObservableObject {
    @Published public private(set) var imageAssets: PHFetchResult<PHAsset>?
    @Published public private(set) var addedAssets = [AddedAsset]()
    @Published public var text = ""
    @Published var createPollShown = false
    @Published var publishingPost = false
    
    let feed: Feed
    let client: FeedsClient
    
    init(feed: Feed, feedsClient: FeedsClient) {
        client = feedsClient
        self.feed = feed
    }
    
    func askForPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { @Sendable [weak self] (status) in
            guard let self else { return }
            switch status {
            case .authorized, .limited:
                log.debug("Access to photos granted.")
                Task { @MainActor in
                    self.fetchAssets()
                }
            case .denied, .restricted, .notDetermined:
                Task { @MainActor in
                    self.imageAssets = PHFetchResult<PHAsset>()
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
        if text.isEmpty && addedAssets.isEmpty || publishingPost {
            return
        }
        
        publishingPost = true
        let attachments = try addedAssets.map { try $0.toAttachmentPayload() }
        _ = try await feed.addActivity(
            request: .init(attachmentUploads: attachments, text: text, type: "activity")
        )
        text = ""
        addedAssets = []
        publishingPost = false
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

extension AddedAsset {
    func toAttachmentPayload() throws -> AnyAttachmentPayload {
        try AnyAttachmentPayload(
            localFileURL: url,
            attachmentType: type == .video ? .video : .image,
            extraData: extraData
        )
    }
}
