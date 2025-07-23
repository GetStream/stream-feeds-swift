//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamFeeds
import SwiftUI

public struct LinkDetectionTextView: View {
    static let linkDetector = TextLinkDetector()
    let text: AttributedString
        
    public init(
        activity: ActivityData
    ) {
        text = Self.displayText(for: activity)
    }
    
    public var body: some View {
        Group {
            Text(text)
        }
        .font(.body)
    }
    
    static func displayText(for activity: ActivityData) -> AttributedString {
        // Markdown
        let attributes = AttributeContainer()
            .foregroundColor(.primary)
            .font(.body)
        var attributedString = AttributedString(activity.text ?? "", attributes: attributes)

        // Links
        for link in linkDetector.links(in: String(attributedString.characters)) {
            if let attributedStringRange = Range(link.range, in: attributedString) {
                attributedString[attributedStringRange].link = link.url
            }
        }
        
        return attributedString
    }
}
