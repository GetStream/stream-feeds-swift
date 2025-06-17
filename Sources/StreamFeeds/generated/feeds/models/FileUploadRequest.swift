import Foundation
import StreamCore

public final class FileUploadRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var file: String?
    public var user: OnlyUserID?

    public init(file: String? = nil, user: OnlyUserID? = nil) {
        self.file = file
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case file
        case user
    }

    public static func == (lhs: FileUploadRequest, rhs: FileUploadRequest) -> Bool {
        lhs.file == rhs.file &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(file)
        hasher.combine(user)
    }
}
