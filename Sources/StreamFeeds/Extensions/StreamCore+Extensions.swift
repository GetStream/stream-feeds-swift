//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamAttachments
import StreamCore
import StreamOpenAPI

// Note: typealiases are used for avoiding the need to import StreamAttachments and StreamOpenAPI by the public API consumers

// Attachments
public typealias AnyAttachmentPayload = StreamAttachments.AnyAttachmentPayload
public typealias AnyStreamAttachment = StreamAttachments.AnyStreamAttachment
public typealias AttachmentFile = StreamAttachments.AttachmentFile
public typealias AttachmentId = StreamAttachments.AttachmentId
public typealias AttachmentUploader = StreamAttachments.AttachmentUploader
public typealias CDNClient = StreamAttachments.CDNClient
public typealias FileAttachmentPayload = StreamAttachments.FileAttachmentPayload
public typealias ImageAttachmentPayload = StreamAttachments.ImageAttachmentPayload
public typealias StreamAttachment = StreamAttachments.StreamAttachment
public typealias StreamAttachmentUploader = StreamAttachments.StreamAttachmentUploader

// OpenAPI
public typealias APIHelper = StreamOpenAPI.APIHelper
public typealias ConnectUserDetailsRequest = StreamOpenAPI.ConnectUserDetailsRequest
public typealias CreateDeviceRequest = StreamOpenAPI.CreateDeviceRequest
public typealias DefaultAPIClientMiddleware = StreamOpenAPI.DefaultAPIClientMiddleware
public typealias DefaultAPITransport = StreamOpenAPI.DefaultAPITransport
public typealias Device = StreamOpenAPI.Device
public typealias DevicesAPI = StreamOpenAPI.DevicesAPI
public typealias EmptyResponse = StreamOpenAPI.EmptyResponse
public typealias JSONEncodable = StreamOpenAPI.JSONEncodable
public typealias ListDevicesResponse = StreamOpenAPI.ListDevicesResponse
public typealias Request = StreamOpenAPI.Request

// OpenAPI Filtering and Sorting
public typealias AnyFilterMatcher<Model> = StreamOpenAPI.AnyFilterMatcher<Model> where Model: Sendable
public typealias AnySortComparator<Model> = StreamOpenAPI.AnySortComparator<Model> where Model: Sendable
public typealias Filter = StreamOpenAPI.Filter
public typealias FilterFieldRepresentable = StreamOpenAPI.FilterFieldRepresentable
public typealias FilterOperator = StreamOpenAPI.FilterOperator
public typealias FilterValue = StreamOpenAPI.FilterValue
public typealias Sort<Field> = StreamOpenAPI.Sort<Field> where Field: SortField
public typealias SortField = StreamOpenAPI.SortField
