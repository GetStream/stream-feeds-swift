//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Photos
import StreamCore
import StreamFeeds
import SwiftUI

/// Helper class that loads assets from the photo library.
@MainActor public class PhotoAssetLoader: NSObject, ObservableObject {
    @Published var loadedImages = [String: UIImage]()

    let client: FeedsClient
    
    init(client: FeedsClient) {
        self.client = client
    }
    
    /// Loads an image from the provided asset.
    func loadImage(from asset: PHAsset) {
        if loadedImages[asset.localIdentifier] != nil {
            return
        }

        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 250, height: 250),
            contentMode: .aspectFit,
            options: options
        ) { [weak self] image, _ in
            guard let self, let image else { return }
            loadedImages[asset.localIdentifier] = image
        }
    }

    private func compressAsset(at url: URL, type: AssetType, completion: @escaping @Sendable (URL?) -> Void) {
        if type == .video {
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
            compressVideo(inputURL: url, outputURL: compressedURL) { exportSession in
                guard let session = exportSession else {
                    return
                }

                switch session.status {
                case .completed:
                    completion(compressedURL)
                default:
                    completion(nil)
                }
            }
        } else {
            completion(url)
        }
    }
    
    func compressAsset(at url: URL, type: AssetType) async -> URL? {
        await withCheckedContinuation { continuation in
            compressAsset(at: url, type: type) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func assetExceedsAllowedSize(at url: URL, type: AssetType) async -> Bool {
        let stop = url.startAccessingSecurityScopedResource()
        defer {
            if stop {
                url.stopAccessingSecurityScopedResource()
            }
        }
        guard let fileSize = try? AttachmentFile(url: url).size else { return false }
        let config = try? await client.getApp()
        switch type {
        case .image:
            guard let imageUploadConfig = config?.imageUploadConfig else { return false }
            return fileSize > imageUploadConfig.sizeLimit
        case .video:
            guard let fileUploadConfig = config?.fileUploadConfig else { return false }
            return fileSize > fileUploadConfig.sizeLimit
        }
    }

    private func compressVideo(
        inputURL: URL,
        outputURL: URL,
        handler: @escaping @Sendable (_ exportSession: AVAssetExportSession?) -> Void
    ) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)

        guard let exportSession = AVAssetExportSession(
            asset: urlAsset,
            presetName: AVAssetExportPresetMediumQuality
        ) else {
            handler(nil)
            return
        }
        nonisolated(unsafe) let unsafeExportSession = exportSession
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            handler(unsafeExportSession)
        }
    }

    /// Clears the cache when there's memory warning.
    func didReceiveMemoryWarning() {
        loadedImages = [String: UIImage]()
    }
}

public extension PHAsset {
    /// Return a formatted duration string of an asset.
    var durationString: String {
        let minutes = Int(duration / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        var minutesString = "\(minutes)"
        var secondsString = "\(seconds)"
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        if seconds < 10 {
            secondsString = "0" + secondsString
        }

        return "\(minutesString):\(secondsString)"
    }
}

extension PHAsset: @retroactive Identifiable {
    public var id: String {
        localIdentifier
    }
}

/// Helper collection that allows iteration over the fetched assets from the photo library.
public struct PHFetchResultCollection: RandomAccessCollection, Equatable {
    public typealias Element = PHAsset
    public typealias Index = Int

    public let fetchResult: PHFetchResult<PHAsset>

    public var endIndex: Int { fetchResult.count }
    public var startIndex: Int { 0 }

    public init(fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }

    public subscript(position: Int) -> PHAsset {
        fetchResult.object(at: position)
    }
}

public enum AssetType {
    case image
    case video
}
