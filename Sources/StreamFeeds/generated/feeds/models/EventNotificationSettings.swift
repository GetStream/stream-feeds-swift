import Foundation
import StreamCore

public final class EventNotificationSettings: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var apns: APNS
    public var enabled: Bool
    public var fcm: FCM

    public init(apns: APNS, enabled: Bool, fcm: FCM) {
        self.apns = apns
        self.enabled = enabled
        self.fcm = fcm
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case apns
        case enabled
        case fcm
    }

    public static func == (lhs: EventNotificationSettings, rhs: EventNotificationSettings) -> Bool {
        lhs.apns == rhs.apns &&
            lhs.enabled == rhs.enabled &&
            lhs.fcm == rhs.fcm
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(apns)
        hasher.combine(enabled)
        hasher.combine(fcm)
    }
}
