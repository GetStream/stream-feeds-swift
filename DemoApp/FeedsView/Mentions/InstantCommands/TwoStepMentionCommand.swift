//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import SwiftUI

/// Base class that supports two step commands, where the second one is mentioning users.
open class TwoStepMentionCommand: CommandHandler, @unchecked Sendable {
    private let mentionsCommandHandler: MentionsCommandHandler
    private let mentionSymbol: String

    public var selectedUser: UserData?

    public let id: String
    public var displayInfo: CommandDisplayInfo?
    public let replacesMessageSending: Bool = true

    public init(
        feed: Feed,
        commandSymbol: String,
        id: String,
        displayInfo: CommandDisplayInfo? = nil,
        mentionSymbol: String = "@"
    ) {
        self.id = id
        self.mentionSymbol = mentionSymbol
        mentionsCommandHandler = MentionsCommandHandler(
            feed: feed,
            commandSymbol: mentionSymbol,
            mentionAllAppUsers: false
        )
        self.displayInfo = displayInfo
    }

    open func canHandleCommand(in text: String, caretLocation: Int) -> ComposerCommand? {
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
                displayInfo: displayInfo,
                replacesMessageSent: true
            )
        } else {
            nil
        }
    }

    open func handleCommand(
        for text: Binding<String>,
        selectedRangeLocation: Binding<Int>,
        command: Binding<ComposerCommand?>,
        extraData: [String: Any]
    ) {
        guard let user = extraData["user"] as? UserData,
              let typingSuggestionValue = command.wrappedValue?.typingSuggestion else {
            return
        }

        selectedUser = user

        let mentionText = "\(mentionSymbol)\(user.mentionText)"
        let newText = (text.wrappedValue as NSString).replacingCharacters(
            in: typingSuggestionValue.locationRange,
            with: mentionText
        )
        text.wrappedValue = newText

        let newCaretLocation =
            selectedRangeLocation.wrappedValue + (mentionText.count - typingSuggestionValue.text.count)
        selectedRangeLocation.wrappedValue = newCaretLocation
    }

    open func canBeExecuted(composerCommand: ComposerCommand) -> Bool {
        selectedUser != nil
    }

    open func commandHandler(for command: ComposerCommand) -> CommandHandler? {
        if let selectedUser,
           command.typingSuggestion.text != "\(mentionSymbol)\(selectedUser.mentionText)" {
            self.selectedUser = nil
        }
        return command.id == id ? self : nil
    }

    open func showSuggestions(
        for command: ComposerCommand
    ) async throws -> SuggestionInfo {
        if selectedUser != nil {
            return SuggestionInfo(
                key: "mentions",
                value: [Any]()
            )
        }
        let oldText = command.typingSuggestion.text
        let text = oldText.replacingOccurrences(
            of: mentionSymbol, with: ""
        ).trimmingCharacters(in: .whitespaces)
        let oldRange = command.typingSuggestion.locationRange
        let offset = oldText.count - text.count
        let newRange = NSRange(
            location: 0,
            length: oldRange.location - offset
        )
        let typingSuggestion = TypingSuggestion(text: text, locationRange: newRange)
        let updated = ComposerCommand(
            id: command.id,
            typingSuggestion: typingSuggestion,
            displayInfo: command.displayInfo
        )
        return try await mentionsCommandHandler.showSuggestions(for: updated)
    }

    open var replacesMessageSent: Bool {
        true
    }

    open func executeOnMessageSent(
        composerCommand: ComposerCommand,
        completion: @escaping (Error?) -> Void
    ) {
        // Implement in subclasses.
    }
}

extension UserData {
    var mentionText: String {
        if let name, !name.isEmpty {
            name
        } else {
            id
        }
    }
}
