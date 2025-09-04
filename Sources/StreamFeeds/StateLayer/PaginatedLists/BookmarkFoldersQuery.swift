//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving bookmark folders with filtering, sorting, and pagination options.
///
/// Use this struct to configure how bookmark folders should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct BookmarkFoldersQuery: Sendable {
    /// Optional filter to apply to the bookmark folders query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: BookmarkFoldersFilter?
    
    /// Maximum number of bookmark folders to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the bookmark folders.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<BookmarkFoldersSortField>]?

    /// Creates a new bookmark folders query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: Optional filter to apply to the bookmark folders query.
    ///   - sort: Optional array of sorting criteria to apply to the bookmark folders.
    ///   - limit: Optional maximum number of bookmark folders to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        filter: BookmarkFoldersFilter? = nil,
        sort: [Sort<BookmarkFoldersSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

/// Represents a field that can be used in bookmark folders filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for bookmark folders queries.
public struct BookmarkFoldersFilterField: FilterFieldRepresentable, Sendable {
    public typealias Model = BookmarkFolderData
    public let matcher: AnyFilterMatcher<Model>
    public let remote: String
    
    public init<Value>(remote: String, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.remote = remote
        matcher = AnyFilterMatcher(localValue: localValue)
    }
    
    init<Value>(remoteCodingKey: BookmarkFolderResponse.CodingKeys, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.init(remote: remoteCodingKey.rawValue, localValue: localValue)
    }
}

extension BookmarkFoldersFilterField {
    /// Filter by the unique identifier of the bookmark folder.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let folderId = Self(remote: "folder_id", localValue: \.id)
    
    /// Filter by the name of the bookmark folder.
    ///
    /// **Supported operators:** `.equal`, `.in`, `.contains`
    public static let folderName = Self(remote: "folder_name", localValue: \.name)
        
    /// Filter by the creation timestamp of the bookmark folder.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(remote: "created_at", localValue: \.createdAt)
    
    /// Filter by the last update timestamp of the bookmark folder.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self(remote: "updated_at", localValue: \.updatedAt)
}

/// A filter that can be applied to bookmark folders queries.
///
/// Use this struct to create filters that narrow down bookmark folder results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`folderId`, `userId`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Text search fields** (`folderName`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// - `.contains` - Case-insensitive substring search
///
/// **Date fields** (`createdAt`, `updatedAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct BookmarkFoldersFilter: Filter {
    /// Creates a new bookmark folders filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: BookmarkFoldersFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: BookmarkFoldersFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting bookmark folders.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting bookmark folders results.
public struct BookmarkFoldersSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = BookmarkFolderData
    
    /// The comparator used for local sorting.
    public let comparator: AnySortComparator<Model>
    
    /// The string value representing the field name in the API for remote sorting.
    public let remote: String
    
    /// Creates a new sort field with the specified parameters.
    ///
    /// - Parameters:
    ///   - remote: The string value representing the field name in the API.
    ///   - localValue: A closure that extracts the comparable value from the model.
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable {
        comparator = AnySortComparator(localValue: localValue)
        self.remote = remote
    }
    
    /// Sort by the creation timestamp of the bookmark folder.
    /// This field allows sorting bookmark folders by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the last update timestamp of the bookmark folder.
    /// This field allows sorting bookmark folders by when they were last updated (newest/oldest first).
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
}

extension Sort where Field == BookmarkFoldersSortField {
    /// The default sorting for bookmark folders queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension BookmarkFoldersQuery {
    func toRequest() -> QueryBookmarkFoldersRequest {
        QueryBookmarkFoldersRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
