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

        for user in activity.mentionedUsers {
            let mention = "@\(user.name ?? user.id)"
            let ranges = attributedString.ranges(of: mention, options: [.caseInsensitive])
            for range in ranges {
                if let activityId = activity.id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                   let url = URL(string: "getstreamfeeds://mention/\(activityId)/\(user.id)") {
                    attributedString[range].link = url
                }
            }
        }
        
        // Links
        for link in linkDetector.links(in: String(attributedString.characters)) {
            if let attributedStringRange = Range(link.range, in: attributedString) {
                attributedString[attributedStringRange].link = link.url
            }
        }
        
        var linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        
        var linkAttributeContainer = AttributeContainer()
        if let uiColor = linkAttributes[.foregroundColor] {
            linkAttributeContainer = linkAttributeContainer.foregroundColor(Color(uiColor: uiColor))
            linkAttributes.removeValue(forKey: .foregroundColor)
        }
        linkAttributeContainer.merge(AttributeContainer(linkAttributes))
        for (value, range) in attributedString.runs[\.link] {
            guard value != nil else { continue }
            attributedString[range].mergeAttributes(linkAttributeContainer)
        }
        
        return attributedString
    }
}

@available(iOS 15, *)
extension AttributedStringProtocol {
    func ranges<T>(
        of stringToFind: T,
        options: String.CompareOptions = [],
        locale: Locale? = nil
    ) -> [Range<AttributedString.Index>] where T: StringProtocol {
        guard !characters.isEmpty else { return [] }
        var ranges = [Range<AttributedString.Index>]()
        var source: AttributedSubstring = self[startIndex...]
        while let range = source.range(of: stringToFind, options: options, locale: locale) {
            ranges.append(range)
            if range.upperBound < endIndex {
                source = self[range.upperBound...]
            } else {
                break
            }
        }
        return ranges
    }
}
