//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import SwiftUI

/// Handles the giphy command and provides suggestions.
public struct GiphyCommandHandler: CommandHandler, @unchecked Sendable {
    public let id: String
    public var displayInfo: CommandDisplayInfo?

    private let typingSuggester: TypingSuggester

    public init(
        commandSymbol: String,
        id: String = "/giphy"
    ) {
        self.id = id
        typingSuggester = TypingSuggester(
            options:
            TypingSuggestionOptions(
                symbol: commandSymbol,
                shouldTriggerOnlyAtStart: true
            )
        )
        displayInfo = CommandDisplayInfo(
            displayName: "Giphy",
            icon: UIImage(systemName: "bolt")!,
            format: "\(id) [text]",
            isInstant: true
        )
    }

    public func canHandleCommand(in text: String, caretLocation: Int) -> ComposerCommand? {
        if text.hasPrefix(id) {
            ComposerCommand(
                id: id,
                typingSuggestion: TypingSuggestion(
                    text: text,
                    locationRange: NSRange(
                        location: 0,
                        length: caretLocation
                    )
                ),
                displayInfo: displayInfo
            )
        } else {
            nil
        }
    }

    public func handleCommand(
        for text: Binding<String>,
        selectedRangeLocation: Binding<Int>,
        command: Binding<ComposerCommand?>,
        extraData: [String: Any]
    ) { /* Handled with attachment actions. */ }

    public func commandHandler(for command: ComposerCommand) -> CommandHandler? {
        nil
    }

    public func showSuggestions(
        for command: ComposerCommand
    ) async throws -> SuggestionInfo {
        throw ClientError("not implemented")
    }
}
