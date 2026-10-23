//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentReactionResponse: Sendable, Codable, JSONEncodable {
    public let comment: CommentResponse
    /// The change this write made to the number of reactions the user holds on this target: 1 when outcome is 'created', 0 when it is 'replaced' or 'unchanged'. These endpoints never return -1; a successful delete-reaction call is what decrements the count. With enforce_unique this is the delta of the user's reaction on the target; without it, the delta of reactions of this type.
    public let counterDelta: Int
    /// Duration of the request
    public let duration: String
    /// Whether notification creation was accepted for asynchronous processing
    public let notificationAccepted: Bool?
    /// Deprecated. Mirrors notification_accepted; use notification_accepted for async enqueue status Deprecated: use notification_accepted
    @available(*, deprecated, message: "use notification_accepted")
    public var notificationCreated: Bool? { _notificationCreated }
    private let _notificationCreated: Bool?
    /// ID of the async notification-creation task; poll GET /tasks/{id} for its status
    public let notificationTaskId: String?
    /// What this write did to the user's reaction on this target. One of: created, replaced, unchanged. 'created' means a new reaction was written and nothing was replaced; 'replaced' means enforce_unique removed one or more of the user's other reaction types; 'unchanged' means the user already held this reaction type (its custom data may still have been updated). Without enforce_unique a user can hold several reaction types on one target, so 'created' then means 'this reaction type was newly added', not 'the user's first reaction on this target'.
    public let outcome: String
    /// The reaction type this write replaced, or null when nothing was replaced. Non-null exactly when outcome is 'replaced'. If enforce_unique removed several reactions — possible only for data created before enforce_unique was adopted — this is the most recently created one.
    public let previousReactionType: String?
    public let reaction: FeedsReactionResponse
    public let referenceActivity: ActivityResponse?

    public init(comment: CommentResponse, counterDelta: Int, duration: String, notificationAccepted: Bool? = nil, notificationCreated: Bool? = nil, notificationTaskId: String? = nil, outcome: String, previousReactionType: String? = nil, reaction: FeedsReactionResponse, referenceActivity: ActivityResponse? = nil) {
        self.comment = comment
        self.counterDelta = counterDelta
        self.duration = duration
        self.notificationAccepted = notificationAccepted
        self._notificationCreated = notificationCreated
        self.notificationTaskId = notificationTaskId
        self.outcome = outcome
        self.previousReactionType = previousReactionType
        self.reaction = reaction
        self.referenceActivity = referenceActivity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.counterDelta = try container.decode(Int.self, forKey: .counterDelta)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.notificationAccepted = try container.decodeIfPresent(Bool.self, forKey: .notificationAccepted)
        self._notificationCreated = try container.decodeIfPresent(Bool.self, forKey: .notificationCreated)
        self.notificationTaskId = try container.decodeIfPresent(String.self, forKey: .notificationTaskId)
        self.outcome = try container.decode(String.self, forKey: .outcome)
        self.previousReactionType = try container.decodeIfPresent(String.self, forKey: .previousReactionType)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
        self.referenceActivity = try container.decodeIfPresent(ActivityResponse.self, forKey: .referenceActivity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(counterDelta, forKey: .counterDelta)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(notificationAccepted, forKey: .notificationAccepted)
        try container.encodeIfPresent(_notificationCreated, forKey: .notificationCreated)
        try container.encodeIfPresent(notificationTaskId, forKey: .notificationTaskId)
        try container.encode(outcome, forKey: .outcome)
        try container.encodeIfPresent(previousReactionType, forKey: .previousReactionType)
        try container.encode(reaction, forKey: .reaction)
        try container.encodeIfPresent(referenceActivity, forKey: .referenceActivity)
    }
}

extension AddCommentReactionResponse: Hashable {
    public static func == (lhs: AddCommentReactionResponse, rhs: AddCommentReactionResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.counterDelta == rhs.counterDelta &&
            lhs.duration == rhs.duration &&
            lhs.notificationAccepted == rhs.notificationAccepted &&
            lhs._notificationCreated == rhs._notificationCreated &&
            lhs.notificationTaskId == rhs.notificationTaskId &&
            lhs.outcome == rhs.outcome &&
            lhs.previousReactionType == rhs.previousReactionType &&
            lhs.reaction == rhs.reaction &&
            lhs.referenceActivity == rhs.referenceActivity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(counterDelta)
        hasher.combine(duration)
        hasher.combine(notificationAccepted)
        hasher.combine(_notificationCreated)
        hasher.combine(notificationTaskId)
        hasher.combine(outcome)
        hasher.combine(previousReactionType)
        hasher.combine(reaction)
        hasher.combine(referenceActivity)
    }
}
