//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import SwiftUI

/// Handles the mention command and provides suggestions.
public struct MentionsCommandHandler: CommandHandler {
    public let id: String
    public var displayInfo: CommandDisplayInfo?

    private let mentionAllAppUsers: Bool
    private let typingSuggester: TypingSuggester
    
    private let feed: Feed

    public init(
        feed: Feed,
        commandSymbol: String,
        mentionAllAppUsers: Bool,
        id: String = "mentions"
    ) {
        self.id = id
        self.feed = feed
        self.mentionAllAppUsers = mentionAllAppUsers
        typingSuggester = TypingSuggester(options: .init(symbol: commandSymbol))
    }

    public func canHandleCommand(in text: String, caretLocation: Int) -> ComposerCommand? {
        if let suggestion = typingSuggester.typingSuggestion(
            in: text,
            caretLocation: caretLocation
        ) {
            ComposerCommand(
                id: id,
                typingSuggestion: suggestion,
                displayInfo: nil
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
    ) {
        guard let user = extraData["user"] as? UserData,
              let typingSuggestionValue = command.wrappedValue?.typingSuggestion else {
            return
        }

        let mentionText = user.mentionText
        let newText = (text.wrappedValue as NSString).replacingCharacters(
            in: typingSuggestionValue.locationRange,
            with: mentionText
        )
        text.wrappedValue = newText

        let newCaretLocation =
            selectedRangeLocation.wrappedValue + (mentionText.count - typingSuggestionValue.text.count)
        selectedRangeLocation.wrappedValue = newCaretLocation
        command.wrappedValue = nil
    }

    public func commandHandler(for command: ComposerCommand) -> CommandHandler? {
        command.id == id ? self : nil
    }

    public func showSuggestions(
        for command: ComposerCommand
    ) async throws -> SuggestionInfo {
        try await showMentionSuggestions(
            for: command.typingSuggestion.text,
            mentionRange: command.typingSuggestion.locationRange
        )
    }

    // MARK: - private

    private func showMentionSuggestions(
        for typingMention: String,
        mentionRange: NSRange
    ) async throws -> SuggestionInfo {
        // NOTE: we only allow tagging followers here.
        let followers = await feed.state.followers.map { followData in
            followData.sourceFeed.createdBy
        }
        let suggestionInfo = SuggestionInfo(key: id, value: followers)
        return suggestionInfo
    }

    /// searchUsers does an autocomplete search on a list of UserData and returns users with `id` or `name` containing the search string
    /// results are returned sorted by their edit distance from the searched string
    /// distance is calculated using the levenshtein algorithm
    /// both search and name strings are normalized (lowercased and by replacing diacritics)
    private func searchUsers(_ users: [UserData], by searchInput: String, excludingId: String? = nil) -> [UserData] {
        let normalize: (String) -> String = {
            $0.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        }

        let searchInput = normalize(searchInput)

        let matchingUsers = users.filter { $0.id != excludingId }
            .filter { searchInput == "" || $0.id.contains(searchInput) || (normalize($0.name ?? "").contains(searchInput)) }

        let distance: (UserData) -> Int = {
            min($0.id.levenshtein(searchInput), $0.name?.levenshtein(searchInput) ?? 1000)
        }

        return Array(Set(matchingUsers)).sorted {
            /// a tie breaker is needed here to avoid results from flickering
            let dist = distance($0) - distance($1)
            if dist == 0 {
                return $0.id < $1.id
            }
            return dist < 0
        }
    }
}
