import Foundation
import StreamCore

public final class SpeechSegmentConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var maxSpeechCaptionMs: Int?
    public var silenceDurationMs: Int?

    public init(maxSpeechCaptionMs: Int? = nil, silenceDurationMs: Int? = nil) {
        self.maxSpeechCaptionMs = maxSpeechCaptionMs
        self.silenceDurationMs = silenceDurationMs
    }

public enum CodingKeys: String, CodingKey, CaseIterable {
    case maxSpeechCaptionMs = "max_speech_caption_ms"
    case silenceDurationMs = "silence_duration_ms"
}

    public static func == (lhs: SpeechSegmentConfig, rhs: SpeechSegmentConfig) -> Bool {
        lhs.maxSpeechCaptionMs == rhs.maxSpeechCaptionMs &&
        lhs.silenceDurationMs == rhs.silenceDurationMs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(maxSpeechCaptionMs)
        hasher.combine(silenceDurationMs)
    }
}
