//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct ImageAttachmentView: View {
    let activity: ActivityData
    let sources: [MediaAttachment]
    let width: CGFloat
    var imageTapped: ((Int) -> Void)?

    private let spacing: CGFloat = 2
    private let maxDisplayedImages = 4
    
    init(
        activity: ActivityData,
        sources: [MediaAttachment],
        width: CGFloat,
        imageTapped: ((Int) -> Void)? = nil
    ) {
        self.activity = activity
        self.sources = sources
        self.width = width
        self.imageTapped = imageTapped
    }

    var body: some View {
        Group {
            if sources.count == 1 {
                SingleImageView(
                    source: sources[0],
                    width: width,
                    imageTapped: imageTapped,
                    index: 0
                )
            } else if sources.count == 2 {
                HStack(spacing: spacing) {
                    MultiImageView(
                        source: sources[0],
                        width: width / 2,
                        height: fullHeight,
                        imageTapped: imageTapped,
                        index: 0
                    )

                    MultiImageView(
                        source: sources[1],
                        width: width / 2,
                        height: fullHeight,
                        imageTapped: imageTapped,
                        index: 1
                    )
                }
            } else if sources.count == 3 {
                HStack(spacing: spacing) {
                    MultiImageView(
                        source: sources[0],
                        width: width / 2,
                        height: fullHeight,
                        imageTapped: imageTapped,
                        index: 0
                    )

                    VStack(spacing: spacing) {
                        MultiImageView(
                            source: sources[1],
                            width: width / 2,
                            height: fullHeight / 2,
                            imageTapped: imageTapped,
                            index: 1
                        )

                        MultiImageView(
                            source: sources[2],
                            width: width / 2,
                            height: fullHeight / 2,
                            imageTapped: imageTapped,
                            index: 2
                        )
                    }
                }
            } else if sources.count > 3 {
                HStack(spacing: spacing) {
                    VStack(spacing: spacing) {
                        MultiImageView(
                            source: sources[0],
                            width: width / 2,
                            height: fullHeight / 2,
                            imageTapped: imageTapped,
                            index: 0
                        )

                        MultiImageView(
                            source: sources[2],
                            width: width / 2,
                            height: fullHeight / 2,
                            imageTapped: imageTapped,
                            index: 2
                        )
                    }

                    VStack(spacing: spacing) {
                        MultiImageView(
                            source: sources[1],
                            width: width / 2,
                            height: fullHeight / 2,
                            imageTapped: imageTapped,
                            index: 1
                        )

                        ZStack {
                            MultiImageView(
                                source: sources[3],
                                width: width / 2,
                                height: fullHeight / 2,
                                imageTapped: imageTapped,
                                index: 3
                            )

                            if notDisplayedImages > 0 {
                                Color.black.opacity(0.4)
                                    .allowsHitTesting(false)

                                Text("+\(notDisplayedImages)")
                                    .font(.title)
                                    .allowsHitTesting(false)
                            }
                        }
                        .frame(width: width / 2, height: fullHeight / 2)
                    }
                }
            }
        }
        .frame(width: width, height: fullHeight)
    }

    private var fullHeight: CGFloat {
        3 * width / 4
    }

    private var notDisplayedImages: Int {
        sources.count > maxDisplayedImages ? sources.count - maxDisplayedImages : 0
    }

    private func uploadState(for index: Int) -> AttachmentUploadingState? {
        sources[index].uploadingState
    }
}

struct SingleImageView: View {
    let source: MediaAttachment
    let width: CGFloat
    var imageTapped: ((Int) -> Void)?
    var index: Int?

    private var height: CGFloat {
        3 * width / 4
    }

    var body: some View {
        LazyLoadingImage(
            source: source,
            width: width,
            height: height,
            imageTapped: imageTapped,
            index: index
        )
        .frame(width: width, height: height)
        .accessibilityIdentifier("SingleImageView")
    }
}

struct MultiImageView: View {
    let source: MediaAttachment
    let width: CGFloat
    let height: CGFloat
    var imageTapped: ((Int) -> Void)?
    var index: Int?

    var body: some View {
        LazyLoadingImage(
            source: source,
            width: width,
            height: height,
            imageTapped: imageTapped,
            index: index
        )
        .frame(width: width, height: height)
        .accessibilityIdentifier("MultiImageView")
    }
}

struct LazyLoadingImage: View {
    @State private var image: UIImage?
    @State private var error: Error?

    let source: MediaAttachment
    let width: CGFloat
    let height: CGFloat
    var resize: Bool = true
    var shouldSetFrame: Bool = true
    var imageTapped: ((Int) -> Void)?
    var index: Int?
    var onImageLoaded: (UIImage) -> Void = { _ in /* Default implementation. */ }

    var body: some View {
        ZStack {
            if let image {
                imageView(for: image)
                if let imageTapped {
                    // NOTE: needed because of bug with SwiftUI.
                    // The click area expands outside the image view (although not visible).
                    Rectangle()
                        .fill(.clear)
                        .frame(width: width, height: height)
                        .contentShape(.rect)
                        .clipped()
                        .allowsHitTesting(true)
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    imageTapped(index ?? 0)
                                }
                        )
                }
            } else if error != nil {
                Color(.secondarySystemBackground)
            } else {
                ZStack {
                    Color(.secondarySystemBackground)
                    ProgressView()
                }
            }
            
            if source.type == .video && width > 64 && source.uploadingState == nil {
                VideoPlayIcon()
                    .accessibilityHidden(true)
            }
        }
        .onAppear {
            if image != nil {
                return
            }

            source.generateThumbnail(
                resize: resize,
                preferredSize: CGSize(width: width, height: height)
            ) { result in
                Task { @MainActor in
                    switch result {
                    case let .success(image):
                        self.image = image
                        onImageLoaded(image)
                    case let .failure(error):
                        self.error = error
                    }
                }
            }
        }
    }

    func imageView(for image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
            .frame(width: shouldSetFrame ? width : nil, height: shouldSetFrame ? height : nil)
            .allowsHitTesting(false)
            .scaleEffect(1.0001) // Needed because of SwiftUI sometimes incorrectly displaying landscape images.
            .clipped()
            .accessibilityHidden(true)
    }
}

public struct MediaAttachment {
    let url: URL
    let type: MediaAttachmentType
    var uploadingState: AttachmentUploadingState?
    
    let utils = Utils.shared
    
    func generateThumbnail(
        resize: Bool,
        preferredSize: CGSize,
        completion: @escaping @Sendable (Result<UIImage, Error>) -> Void
    ) {
        if type == .image {
            utils.imageLoader.loadImage(
                url: url,
                imageCDN: utils.imageCDN,
                resize: resize,
                preferredSize: preferredSize,
                completion: completion
            )
        } else if type == .video {
            utils.videoPreviewLoader.loadPreviewForVideo(
                at: url,
                completion: completion
            )
        }
    }
}

extension MediaAttachment {
    init(from attachment: StreamImageAttachment) {
        let url: URL = if let state = attachment.uploadingState {
            state.localFileURL
        } else {
            attachment.imageURL
        }
        self.init(
            url: url,
            type: .image,
            uploadingState: attachment.uploadingState
        )
    }
}

enum MediaAttachmentType {
    case image
    case video
}

/// Options for the gallery view.
public struct MediaViewsOptions {
    /// The index of the selected media item.
    public let selectedIndex: Int
}
