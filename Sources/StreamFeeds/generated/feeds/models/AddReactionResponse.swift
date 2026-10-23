//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddReactionResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var activity: ActivityResponse
    /// The change this write made to the number of reactions the user holds on this target: 1 when outcome is 'created', 0 when it is 'replaced' or 'unchanged'. These endpoints never return -1; a successful delete-reaction call is what decrements the count. With enforce_unique this is the delta of the user's reaction on the target; without it, the delta of reactions of this type.
    public var counterDelta: Int
    public var duration: String
    /// Whether notification creation was accepted for asynchronous processing
    public var notificationAccepted: Bool?
    /// Deprecated. Mirrors notification_accepted; use notification_accepted for async enqueue status Deprecated: use notification_accepted
    @available(*, deprecated, message: "use notification_accepted")
    public var notificationCreated: Bool? { get { _notificationCreated } set { _notificationCreated = newValue } }
    private var _notificationCreated: Bool?
    /// ID of the async notification-creation task; poll GET /tasks/{id} for its status
    public var notificationTaskId: String?
    /// What this write did to the user's reaction on this target. One of: created, replaced, unchanged. 'created' means a new reaction was written and nothing was replaced; 'replaced' means enforce_unique removed one or more of the user's other reaction types; 'unchanged' means the user already held this reaction type (its custom data may still have been updated). Without enforce_unique a user can hold several reaction types on one target, so 'created' then means 'this reaction type was newly added', not 'the user's first reaction on this target'.
    public var outcome: String
    /// The reaction type this write replaced, or null when nothing was replaced. Non-null exactly when outcome is 'replaced'. If enforce_unique removed several reactions — possible only for data created before enforce_unique was adopted — this is the most recently created one.
    public var previousReactionType: String?
    public var reaction: FeedsReactionResponse
    public var referenceActivity: ActivityResponse?

    public init(
        activity: ActivityResponse,
        counterDelta: Int,
        duration: String,
        notificationAccepted: Bool? = nil,
        notificationCreated: Bool? = nil,
        notificationTaskId: String? = nil,
        outcome: String,
        previousReactionType: String? = nil,
        reaction: FeedsReactionResponse,
        referenceActivity: ActivityResponse? = nil
    ) {
        self.activity = activity
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case counterDelta = "counter_delta"
        case duration
        case notificationAccepted = "notification_accepted"
        case notificationCreated = "notification_created"
        case notificationTaskId = "notification_task_id"
        case outcome
        case previousReactionType = "previous_reaction_type"
        case reaction
        case referenceActivity = "reference_activity"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.counterDelta = try container.decode(Int.self, forKey: .counterDelta)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.notificationAccepted = try container.decodeIfPresent(
            Bool.self,
            forKey: .notificationAccepted
        )
        self._notificationCreated = try container.decodeIfPresent(
            Bool.self,
            forKey: .notificationCreated
        )
        self.notificationTaskId = try container.decodeIfPresent(
            String.self,
            forKey: .notificationTaskId
        )
        self.outcome = try container.decode(String.self, forKey: .outcome)
        self.previousReactionType = try container.decodeIfPresent(
            String.self,
            forKey: .previousReactionType
        )
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
        self.referenceActivity = try container.decodeIfPresent(
            ActivityResponse.self,
            forKey: .referenceActivity
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activity, forKey: .activity)
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

extension AddReactionResponse: Hashable {
    public static func == (lhs: AddReactionResponse, rhs: AddReactionResponse) -> Bool {
        lhs.activity == rhs.activity &&
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
        hasher.combine(activity)
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
