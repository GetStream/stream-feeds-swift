//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension Attachment {
    public convenience init(actions: [Action]? = nil, assetUrl: String? = nil, authorIcon: String? = nil, authorLink: String? = nil, authorName: String? = nil, color: String? = nil, custom: [String: RawJSON] = [:], fallback: String? = nil, fields: [Field]? = nil, footer: String? = nil, footerIcon: String? = nil, giphy: Images? = nil, imageUrl: String? = nil, latitude: Float? = nil, longitude: Float? = nil, ogScrapeUrl: String? = nil, originalHeight: Int? = nil, originalWidth: Int? = nil, pretext: String? = nil, stoppedSharing: Bool? = nil, text: String? = nil, thumbUrl: String? = nil, title: String? = nil, titleLink: String? = nil, type: String?) {
        self.init(
            actions: actions,
            assetUrl: assetUrl,
            authorIcon: authorIcon,
            authorLink: authorLink,
            authorName: authorName,
            color: color,
            custom: custom,
            fallback: fallback,
            fields: fields,
            footer: footer,
            footerIcon: footerIcon,
            giphy: giphy,
            imageUrl: imageUrl,
            latitude: latitude,
            longitude: longitude,
            ogScrapeUrl: ogScrapeUrl,
            originalHeight: originalHeight,
            originalWidth: originalWidth,
            pretext: pretext,
            stoppedSharing: stoppedSharing,
            text: text,
            thumbUrl: thumbUrl,
            title: title,
            titleLink: titleLink
        )
        // TODO: Fix API generation
        self.type = type
    }
}
