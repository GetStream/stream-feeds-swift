import Foundation
import StreamCore

public final class ExternalStorage: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var absAccountName: String?
    public var absClientId: String?
    public var absClientSecret: String?
    public var absTenantId: String?
    public var bucket: String?
    public var gcsCredentials: String?
    public var path: String?
    public var s3ApiKey: String?
    public var s3CustomEndpoint: String?
    public var s3Region: String?
    public var s3SecretKey: String?
    public var storageName: String?
    public var storageType: Int?

    public init(absAccountName: String? = nil, absClientId: String? = nil, absClientSecret: String? = nil, absTenantId: String? = nil, bucket: String? = nil, gcsCredentials: String? = nil, path: String? = nil, s3ApiKey: String? = nil, s3CustomEndpoint: String? = nil, s3Region: String? = nil, s3SecretKey: String? = nil, storageName: String? = nil, storageType: Int? = nil) {
        self.absAccountName = absAccountName
        self.absClientId = absClientId
        self.absClientSecret = absClientSecret
        self.absTenantId = absTenantId
        self.bucket = bucket
        self.gcsCredentials = gcsCredentials
        self.path = path
        self.s3ApiKey = s3ApiKey
        self.s3CustomEndpoint = s3CustomEndpoint
        self.s3Region = s3Region
        self.s3SecretKey = s3SecretKey
        self.storageName = storageName
        self.storageType = storageType
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case absAccountName = "abs_account_name"
        case absClientId = "abs_client_id"
        case absClientSecret = "abs_client_secret"
        case absTenantId = "abs_tenant_id"
        case bucket
        case gcsCredentials = "gcs_credentials"
        case path
        case s3ApiKey = "s3_api_key"
        case s3CustomEndpoint = "s3_custom_endpoint"
        case s3Region = "s3_region"
        case s3SecretKey = "s3_secret_key"
        case storageName = "storage_name"
        case storageType = "storage_type"
    }

    public static func == (lhs: ExternalStorage, rhs: ExternalStorage) -> Bool {
        lhs.absAccountName == rhs.absAccountName &&
            lhs.absClientId == rhs.absClientId &&
            lhs.absClientSecret == rhs.absClientSecret &&
            lhs.absTenantId == rhs.absTenantId &&
            lhs.bucket == rhs.bucket &&
            lhs.gcsCredentials == rhs.gcsCredentials &&
            lhs.path == rhs.path &&
            lhs.s3ApiKey == rhs.s3ApiKey &&
            lhs.s3CustomEndpoint == rhs.s3CustomEndpoint &&
            lhs.s3Region == rhs.s3Region &&
            lhs.s3SecretKey == rhs.s3SecretKey &&
            lhs.storageName == rhs.storageName &&
            lhs.storageType == rhs.storageType
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(absAccountName)
        hasher.combine(absClientId)
        hasher.combine(absClientSecret)
        hasher.combine(absTenantId)
        hasher.combine(bucket)
        hasher.combine(gcsCredentials)
        hasher.combine(path)
        hasher.combine(s3ApiKey)
        hasher.combine(s3CustomEndpoint)
        hasher.combine(s3Region)
        hasher.combine(s3SecretKey)
        hasher.combine(storageName)
        hasher.combine(storageType)
    }
}
