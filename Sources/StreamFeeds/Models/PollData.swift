//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollData: Identifiable, Equatable, Sendable {
    public let allowAnswers: Bool
    public let allowUserSuggestedOptions: Bool
    public let answersCount: Int
    public let createdAt: Date
    public let createdBy: UserData?
    public let createdById: String
    public let custom: [String: RawJSON]
    public let description: String
    let descriptionOriginalLanguage: String?
    /// Automatic translations of ``description``, keyed by language code.
    ///
    /// - Note: Feeds doesn't translate polls automatically.
    public let descriptionTranslations: [String: String]?
    public let enforceUniqueVote: Bool
    public let id: String
    public private(set) var isClosed: Bool
    public let latestAnswers: [PollVoteData]
    public private(set) var latestVotesByOption: [String: [PollVoteData]]
    public let maxVotesAllowed: Int?
    public let name: String
    /// Automatic translations of ``name``, keyed by language code.
    ///
    /// - Note: Feeds doesn't translate polls automatically.
    public let nameTranslations: [String: String]?
    public private(set) var options: [PollOptionData]
    /// The language code of the original ``name``.
    public let originalLanguage: String?
    public private(set) var ownVotes: [PollVoteData]
    public let updatedAt: Date
    public private(set) var voteCount: Int
    public private(set) var voteCountsByOption: [String: Int]
    public let votingVisibility: PollVotingVisibility
}

public typealias PollVotingVisibility = VotingVisibility

// MARK: - Translations

extension PollData {
    /// The translation of ``description`` to the given language code, or `nil` when there is none, or it is the same as the original description.
    public func translatedDescription(for language: String) -> String? {
        I18n.validTranslation(of: description, in: descriptionTranslations, for: language, originalLanguage: descriptionOriginalLanguage)
    }

    /// The translation of ``name`` to the given language code, or `nil` when there is none, or it is the same as the original name.
    public func translatedName(for language: String) -> String? {
        I18n.validTranslation(of: name, in: nameTranslations, for: language, originalLanguage: originalLanguage)
    }
}

// MARK: - Mutating the Data

extension PollData {
    mutating func merge(with incomingData: PollData) {
        let ownVotes = ownVotes
        self = incomingData
        self.ownVotes = ownVotes
    }
    
    mutating func merge(with incomingData: PollData, add vote: PollVoteData, currentUserId: String) {
        merge(with: incomingData)
        guard vote.userId == currentUserId else { return }
        if enforceUniqueVote {
            ownVotes = [vote]
        } else {
            ownVotes.insert(byId: vote)
        }
    }
    
    mutating func merge(with incomingData: PollData, remove vote: PollVoteData, currentUserId: String) {
        merge(with: incomingData)
        guard vote.userId == currentUserId else { return }
        ownVotes.remove(byId: vote.id)
    }
    
    mutating func merge(with incomingData: PollData, change vote: PollVoteData, currentUserId: String) {
        merge(with: incomingData)
        guard vote.userId == currentUserId else { return }
        ownVotes.replace(byId: vote)
    }
    
    // MARK: - Options
    
    mutating func addOption(_ option: PollOptionData) {
        options.insert(byId: option)
    }
    
    mutating func removeOption(withId optionId: String) {
        guard let index = options.firstIndex(where: { $0.id == optionId }) else { return }
        options.remove(at: index)
    }
    
    mutating func updateOption(_ option: PollOptionData) {
        options.replace(byId: option)
    }
}

// MARK: - Model Conversions

extension PollResponseData {
    func toModel() -> PollData {
        PollData(
            allowAnswers: allowAnswers,
            allowUserSuggestedOptions: allowUserSuggestedOptions,
            answersCount: answersCount,
            createdAt: createdAt,
            createdBy: createdBy?.toModel(),
            createdById: createdById,
            custom: custom,
            description: description,
            descriptionOriginalLanguage: I18n.originalLanguage(from: descriptionI18n),
            descriptionTranslations: I18n.translations(from: descriptionI18n),
            enforceUniqueVote: enforceUniqueVote,
            id: id,
            isClosed: isClosed ?? false,
            latestAnswers: latestAnswers.map { $0.toModel() },
            latestVotesByOption: latestVotesByOption.mapValues { votes in votes.map { $0.toModel() } },
            maxVotesAllowed: maxVotesAllowed,
            name: name,
            nameTranslations: I18n.translations(from: nameI18n),
            options: options.map { $0.toModel() },
            originalLanguage: I18n.originalLanguage(from: nameI18n),
            ownVotes: ownVotes.map { $0.toModel() },
            updatedAt: updatedAt,
            voteCount: voteCount,
            voteCountsByOption: voteCountsByOption,
            votingVisibility: votingVisibility
        )
    }
}
