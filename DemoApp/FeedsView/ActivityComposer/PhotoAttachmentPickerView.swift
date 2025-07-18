//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Photos
import StreamCore
import StreamFeeds
import SwiftUI

/// View for the photo attachment picker.
public struct PhotoAttachmentPickerView: View {
    @StateObject var assetLoader: PhotoAssetLoader
    
    var assets: PHFetchResultCollection
    var onImageTap: (AddedAsset) -> Void
    var imageSelected: (String) -> Bool
    
    let columns = [GridItem(.adaptive(minimum: 120), spacing: 2)]
    
    public init(
        assets: PHFetchResultCollection,
        assetLoader: PhotoAssetLoader,
        onImageTap: @escaping (AddedAsset) -> Void,
        imageSelected: @escaping (String) -> Bool
    ) {
        _assetLoader = StateObject(wrappedValue: assetLoader)
        self.assets = assets
        self.onImageTap = onImageTap
        self.imageSelected = imageSelected
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(assets) { asset in
                    PhotoAttachmentCell(
                        assetLoader: assetLoader,
                        asset: asset,
                        onImageTap: onImageTap,
                        imageSelected: imageSelected
                    )
                }
            }
            .padding(.horizontal, 2)
            .animation(nil, value: true)
        }
    }
}

/// Photo cell displayed in the picker view.
public struct PhotoAttachmentCell: View {
    var colors = Colors.shared
    
    @ObservedObject var assetLoader: PhotoAssetLoader
    
    @State private var assetURL: URL?
    @State private var compressing = false
    @State private var loading = false
    @State var requestId: PHContentEditingInputRequestID?
    @State var idOverlay = UUID()
    
    var asset: PHAsset
    var onImageTap: (AddedAsset) -> Void
    var imageSelected: (String) -> Bool
    
    private var assetType: AssetType {
        asset.mediaType == .video ? .video : .image
    }

    public init(
        assetLoader: PhotoAssetLoader,
        requestId: PHContentEditingInputRequestID? = nil,
        asset: PHAsset,
        onImageTap: @escaping (AddedAsset) -> Void,
        imageSelected: @escaping (String) -> Bool
    ) {
        self.assetLoader = assetLoader
        _requestId = State(initialValue: requestId)
        self.asset = asset
        self.onImageTap = onImageTap
        self.imageSelected = imageSelected
    }
 
    public var body: some View {
        ZStack {
            if let image = assetLoader.loadedImages[asset.localIdentifier] {
                GeometryReader { reader in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: reader.size.width, height: reader.size.height)
                            .allowsHitTesting(false)
                            .clipped()
                        
                        // Needed because of SwiftUI bug with tap area of Image.
                        Rectangle()
                            .opacity(0.000001)
                            .frame(width: reader.size.width, height: reader.size.height)
                            .clipped()
                            .allowsHitTesting(true)
                            .onTapGesture {
                                withAnimation {
                                    if let assetURL = asset.mediaType == .image ? assetJpgURL() : assetURL {
                                        onImageTap(
                                            AddedAsset(
                                                image: image,
                                                id: asset.localIdentifier,
                                                url: assetURL,
                                                type: assetType,
                                                extraData: asset
                                                    .mediaType == .video ? ["duration": .string(asset.durationString)] : [:]
                                            )
                                        )
                                    }
                                    idOverlay = UUID()
                                }
                            }
                    }
                    .overlay(
                        (compressing || loading) ? ProgressView() : nil
                    )
                }
            } else {
                Color(colors.background1)
                    .aspectRatio(1, contentMode: .fill)
                
                Image(systemName: "photo")
                    .customizable()
                    .frame(height: 56)
                    .foregroundColor(Color(colors.background2))
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .overlay(
            ZStack {
                if imageSelected(asset.localIdentifier) {
                    TopRightView {
                        Image(systemName: "checkmark.circle.fill")
                            .renderingMode(.template)
                            .scaledToFit()
                            .applyDefaultIconOverlayStyle()
                    }
                }
                
                if asset.mediaType == .video {
                    VideoIndicatorView()
                    
                    VideoDurationIndicatorView(
                        duration: asset.durationString
                    )
                }
            }
            .id(idOverlay)
        )
        .onAppear {
            loading = false
            
            assetLoader.loadImage(from: asset)
            
            if assetURL != nil {
                return
            }
            
            let options = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            loading = true
            
            requestId = asset.requestContentEditingInput(with: options) { input, _ in
                loading = false
                if asset.mediaType == .image {
                    assetURL = input?.fullSizeImageURL
                } else if let url = (input?.audiovisualAsset as? AVURLAsset)?.url {
                    assetURL = url
                }
                
                // Check file size.
                if let assetURL {
                    Task { @MainActor in
                        guard await assetLoader.assetExceedsAllowedSize(at: assetURL, type: assetType) else { return }
                        compressing = true
                        self.assetURL = await assetLoader.compressAsset(at: assetURL, type: assetType)
                        compressing = false
                    }
                }
            }
        }
        .onDisappear {
            if let requestId {
                asset.cancelContentEditingInputRequest(requestId)
                self.requestId = nil
                loading = false
            }
        }
    }

    /// The original photo is usually in HEIC format.
    /// This makes sure that the photo is converted to JPG.
    /// This way it is more compatible with other platforms.
    private func assetJpgURL() -> URL? {
        guard let assetURL else { return nil }
        guard let assetData = try? Data(contentsOf: assetURL) else { return nil }
        return try? UIImage(data: assetData)?.saveAsJpgToTemporaryUrl()
    }
}
