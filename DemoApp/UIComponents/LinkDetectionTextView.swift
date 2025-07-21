//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamFeeds
import SwiftUI

public struct LinkDetectionTextView: View {
    var activity: ActivityData

    @State var text: AttributedString?
    @State var linkDetector = TextLinkDetector()
        
    public init(
        activity: ActivityData
    ) {
        self.activity = activity
    }
    
    public var body: some View {
        Group {
            Text(text ?? displayText)
        }
        .font(.body)
        .onChange(of: activity.text) { _ in
            text = displayText
        }
    }
    
    var displayText: AttributedString {
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
