//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCoreUI
import UIKit

// MARK: - Errors

public enum ImageLoaderError: Error {
    case invalidURL
    case decodingFailed
    case network(Error)
}

// MARK: - Thread-safe in-memory cache

actor ImageCache {
    private var storage: [String: UIImage] = [:]

    func image(forKey key: String) -> UIImage? {
        storage[key]
    }

    func insert(_ image: UIImage, forKey key: String) {
        storage[key] = image
    }
}

// MARK: - Concrete implementation

final class DefaultImageLoader: ImageLoading, @unchecked Sendable {
    // MARK: Properties

    private let session: URLSession
    private let cache: ImageCache

    // MARK: Init

    init(
        session: URLSession = .shared,
        cache: ImageCache = .init()
    ) {
        self.session = session
        self.cache = cache
    }

    // MARK: ImageLoading

    /// Loads **multiple** images, preserving order and rotating placeholders for failures.
    public func loadImages(
        from urls: [URL],
        placeholders: [UIImage],
        loadThumbnails: Bool,
        thumbnailSize: CGSize,
        imageCDN: ImageCDN,
        completion: @escaping @Sendable ([UIImage]) -> Void
    ) {
        Task.detached { [weak self] in
            guard let self else { return }

            // Pre-allocate array keeping call-site order.
            var results = [UIImage?](repeating: nil, count: urls.count)

            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, originalURL) in urls.enumerated() {
                    group.addTask { [weak self] in
                        guard let self else { return (index, nil) }

                        // Derive thumbnail if requested.
                        let effectiveURL: URL = if loadThumbnails {
                            await imageCDN
                                .thumbnailURL(
                                    originalURL: originalURL,
                                    preferredSize: thumbnailSize
                                )
                        } else {
                            originalURL
                        }

                        let image = try? await fetchImage(
                            at: effectiveURL,
                            imageCDN: imageCDN,
                            resize: false,
                            preferredSize: nil
                        ).get()

                        return (index, image)
                    }
                }

                // Gather results as tasks finish.
                for await (index, image) in group {
                    results[index] = image
                }
            }

            // Fill failures with the rotating placeholders.
            let finalImages: [UIImage] = results.enumerated().map { idx, maybeImage in
                maybeImage ?? placeholders[idx % placeholders.count]
            }

            await MainActor.run {
                completion(finalImages)
            }
        }
    }

    /// Loads **one** image.
    func loadImage(
        url: URL?,
        imageCDN: ImageCDN,
        resize: Bool,
        preferredSize: CGSize?,
        completion: @escaping (@Sendable (Result<UIImage, Error>) -> Void)
    ) {
        Task.detached { [weak self] in
            guard let self else { return }

            let result = await fetchImage(
                at: url,
                imageCDN: imageCDN,
                resize: resize,
                preferredSize: preferredSize
            )

            await MainActor.run {
                completion(result)
            }
        }
    }

    // MARK: Private helpers

    /// Core fetching routine shared by both public APIs.
    private func fetchImage(
        at url: URL?,
        imageCDN: ImageCDN,
        resize: Bool,
        preferredSize: CGSize?
    ) async -> Result<UIImage, Error> {
        guard let url else { return .failure(ImageLoaderError.invalidURL) }

        let key = imageCDN.cachingKey(forImageUrl: url)

        // 1. Cache
        if let cached = await cache.image(forKey: key) {
            let maybeResized = resize ? cached.resized(to: preferredSize) : cached
            return .success(maybeResized)
        }

        // 2. Network
        let request = imageCDN.urlRequest(forImageUrl: url, resize: nil)

        do {
            let (data, _) = try await session.data(for: request, delegate: nil)
            guard let image = UIImage(data: data) else {
                return .failure(ImageLoaderError.decodingFailed)
            }

            let transformed = resize ? image.resized(to: preferredSize) : image

            // 3. Store and forward
            await cache.insert(transformed, forKey: key)
            return .success(transformed)
        } catch {
            return .failure(ImageLoaderError.network(error))
        }
    }
}

// MARK: - Resize helper (Main-actor isolated via UIKit)

private extension UIImage {
    /// Returns a resized copy keeping aspect ratio; if `size` is `nil` the image is returned unchanged.
    func resized(to size: CGSize?) -> UIImage {
        guard
            let size,
            size != .zero,
            self.size != .zero
        else { return self }

        // Preserve aspect ratio.
        let aspectRatio = min(
            size.width / self.size.width,
            size.height / self.size.height
        )
        let newSize = CGSize(
            width: self.size.width * aspectRatio,
            height: self.size.height * aspectRatio
        )

        // Render on the main thread because of UIKit.
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
