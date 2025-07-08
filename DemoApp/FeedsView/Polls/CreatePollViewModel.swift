//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamFeeds
import SwiftUI

@MainActor class CreatePollViewModel: ObservableObject {
        
    @Published var question = ""
    
    @Published var options: [String] = [""]
    @Published var optionsErrorIndices = Set<Int>()
        
    @Published var suggestAnOption: Bool
    
    @Published var anonymousPoll: Bool
    
    @Published var multipleAnswers: Bool
    
    @Published var maxVotesEnabled: Bool
    
    @Published var maxVotes: String = ""
    @Published var showsMaxVotesError = false
    
    @Published var allowComments: Bool
    
    @Published var discardConfirmationShown = false
    
    @Published var errorShown = false
    
    private let feed: Feed
        
    private var cancellables = [AnyCancellable]()
    
    let pollsConfig = PollsConfig()
    
    var multipleAnswersShown: Bool {
        pollsConfig.multipleAnswers.configurable
    }
    
    var anonymousPollShown: Bool {
        pollsConfig.anonymousPoll.configurable
    }
    
    var suggestAnOptionShown: Bool {
        pollsConfig.suggestAnOption.configurable
    }
    
    var addCommentsShown: Bool {
        pollsConfig.addComments.configurable
    }
    
    var maxVotesShown: Bool {
        pollsConfig.maxVotesPerPerson.configurable
    }
    
    init(feed: Feed) {
        self.feed = feed
        suggestAnOption = pollsConfig.suggestAnOption.defaultValue
        anonymousPoll = pollsConfig.anonymousPoll.defaultValue
        multipleAnswers = pollsConfig.multipleAnswers.defaultValue
        allowComments = pollsConfig.addComments.defaultValue
        maxVotesEnabled = pollsConfig.maxVotesPerPerson.defaultValue
        
        $maxVotes
            .map { text in
                guard !text.isEmpty else { return false }
                let intValue = Int(text) ?? 0
                return intValue < 1 || intValue > 10
            }
            .combineLatest($maxVotesEnabled)
            .map { $0 && $1 }
            .removeDuplicates()
            .assign(to: \.showsMaxVotesError, onWeak: self)
            .store(in: &cancellables)
        $options
            .map { options in
                var errorIndices = Set<Int>()
                var existing = Set<String>(minimumCapacity: options.count)
                for (index, option) in options.enumerated() {
                    let validated = option.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    if existing.contains(validated), !validated.isEmpty {
                        errorIndices.insert(index)
                    }
                    existing.insert(validated)
                }
                return errorIndices
            }
            .removeDuplicates()
            .assign(to: \.optionsErrorIndices, onWeak: self)
            .store(in: &cancellables)
    }
        
    func createPoll(completion: @escaping () -> Void) {
        let pollOptions = options
            .map(\.trimmed)
            .filter { !$0.isEmpty }
            .map { PollOptionInput(text: $0) }
        let maxVotesAllowed = multipleAnswers ? Int(maxVotes) : nil
        Task {
            do {
                try await feed.createPoll(
                    request:
                        .init(
                            allowAnswers: allowComments,
                            allowUserSuggestedOptions: suggestAnOption,
                            custom: [:],
                            description: nil,
                            enforceUniqueVote: !multipleAnswers,
                            maxVotesAllowed: maxVotesAllowed,
                            name: question.trimmed,
                            options: pollOptions,
                            votingVisibility: anonymousPoll ? .anonymous : .public
                        ),
                    activityType: "activity"
                )
                completion()
            } catch {
                errorShown = true
            }
        }
    }
    
    var canCreatePoll: Bool {
        guard !question.trimmed.isEmpty else { return false }
        guard optionsErrorIndices.isEmpty else { return false }
        guard !showsMaxVotesError else { return false }
        guard options.contains(where: { !$0.trimmed.isEmpty }) else { return false }
        return true
    }
    
    var canShowDiscardConfirmation: Bool {
        guard question.trimmed.isEmpty else { return true }
        return options.contains(where: { !$0.trimmed.isEmpty })
    }
    
    func showsOptionError(for index: Int) -> Bool {
        optionsErrorIndices.contains(index)
    }
}

/// Config for individual poll entry.
public struct PollsEntryConfig: Sendable {
    /// Indicates whether the poll entry is configurable.
    public var configurable: Bool
    /// Indicates the default value of the poll entry.
    public var defaultValue: Bool
    
    public init(configurable: Bool, defaultValue: Bool) {
        self.configurable = configurable
        self.defaultValue = defaultValue
    }
}

extension PollsEntryConfig {
    /// The default configuration for a poll entry.
    public static let `default` = PollsEntryConfig(configurable: true, defaultValue: false)
}

/// Config for various poll settings.
public struct PollsConfig {
    /// Configuration for allowing multiple answers in a poll.
    public var multipleAnswers: PollsEntryConfig
    /// Configuration for enabling anonymous polls.
    public var anonymousPoll: PollsEntryConfig
    /// Configuration for allowing users to suggest options in a poll.
    public var suggestAnOption: PollsEntryConfig
    /// Configuration for adding comments to a poll.
    public var addComments: PollsEntryConfig
    /// Configuration for setting the maximum number of votes per person.
    public var maxVotesPerPerson: PollsEntryConfig
    
    /// Initializes a new `PollsConfig` with the given configurations.
    ///
    /// - Parameters:
    ///   - multipleAnswers: Configuration for allowing multiple answers. Defaults to `.default`.
    ///   - anonymousPoll: Configuration for enabling anonymous polls. Defaults to `.default`.
    ///   - suggestAnOption: Configuration for allowing users to suggest options. Defaults to `.default`.
    ///   - addComments: Configuration for adding comments. Defaults to `.default`.
    ///   - maxVotesPerPerson: Configuration for setting the maximum number of votes per person. Defaults to `.default`.
    public init(
        multipleAnswers: PollsEntryConfig = .default,
        anonymousPoll: PollsEntryConfig = .default,
        suggestAnOption: PollsEntryConfig = .default,
        addComments: PollsEntryConfig = .default,
        maxVotesPerPerson: PollsEntryConfig = .default
    ) {
        self.multipleAnswers = multipleAnswers
        self.anonymousPoll = anonymousPoll
        self.suggestAnOption = suggestAnOption
        self.addComments = addComments
        self.maxVotesPerPerson = maxVotesPerPerson
    }
}

extension String {
    var trimmed: Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
