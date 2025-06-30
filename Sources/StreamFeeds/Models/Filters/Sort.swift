//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// A protocol that defines a sortable field for a specific model type.
/// 
/// This protocol provides the foundation for creating sortable fields that can be used
/// both for local sorting and remote API requests. It includes a comparator for local
/// sorting operations and a remote string identifier for API communication.
/// 
/// - Note: The associated `Model` type must conform to `Sendable` to ensure thread safety.
public protocol SortField: Sendable {
    /// The model type that this sort field operates on.
    associatedtype Model: Sendable
    
    /// A comparator that can be used for local sorting operations.
    var comparator: AnySortComparator<Model> { get }
    
    /// The string identifier used when sending sort parameters to the remote API.
    var remote: String { get }
    
    /// Creates a new sort field with the specified remote identifier and local value extractor.
    /// 
    /// - Parameters:
    ///   - remote: The string identifier used for remote API requests
    ///   - localValue: A closure that extracts the comparable value from a model instance
    init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable
}

/// A sort configuration that combines a sort field with a direction.
/// 
/// This struct represents a complete sort specification that can be applied to collections
/// of the associated model type. It provides both local sorting capabilities and the ability
/// to generate remote API request parameters.
/// 
/// - Note: The `Field` type must conform to `SortField` and be `Sendable`.
public struct Sort<Field>: Sendable where Field: SortField {
    /// The field to sort by.
    public let field: Field
    
    /// The direction of the sort (forward or reverse).
    public let direction: SortDirection

    /// Creates a new sort configuration.
    /// 
    /// - Parameters:
    ///   - field: The field to sort by
    ///   - direction: The direction of the sort
    public init(field: Field, direction: SortDirection) {
        self.direction = direction
        self.field = field
    }
    
    /// Compares two model instances using this sort configuration.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand side model instance
    ///   - rhs: The right-hand side model instance
    /// - Returns: A comparison result indicating the relative ordering of the two instances
    func compare(_ lhs: Field.Model, _ rhs: Field.Model) -> ComparisonResult {
        field.comparator.compare(lhs, rhs, direction: direction)
    }
}

/// The direction of a sort operation.
/// 
/// This enum defines whether a sort should be performed in ascending (forward) or
/// descending (reverse) order. The raw values correspond to the values expected by
/// the remote API.
public enum SortDirection: Int, CustomStringConvertible, Sendable {
    /// Sort in ascending order (A to Z, 1 to 9, etc.).
    case forward = 1
    
    /// Sort in descending order (Z to A, 9 to 1, etc.).
    case reverse = -1
    
    public var description: String {
        switch self {
        case .forward: "forward"
        case .reverse: "reverse"
        }
    }
}

extension Sort: CustomStringConvertible {
    /// A string representation of the sort configuration in the format "field:direction".
    public var description: String { "\(field.remote):\(direction)" }
}

// MARK: - OpenAPI Request

extension Sort {
    /// Converts this sort configuration to a format suitable for API requests.
    /// 
    /// - Returns: A `SortParamRequest` object containing the field and direction for the API
    func toRequest() -> SortParamRequest {
        SortParamRequest(
            direction: direction.rawValue,
            field: field.remote
        )
    }
}

// MARK: - Local Sorting Support

/// A comparator that can sort model instances by extracting comparable values.
/// 
/// This struct provides the foundation for local sorting operations by wrapping a closure
/// that extracts comparable values from model instances. It handles the comparison logic
/// and direction handling internally.
/// 
/// - Note: Both `Model` and `Value` must conform to `Sendable` for thread safety.
struct SortComparator<Model, Value>: Sendable where Model: Sendable, Value: Comparable {
    /// A closure that extracts a comparable value from a model instance.
    let value: @Sendable (Model) -> Value
    
    /// Creates a new comparator with the specified value extraction closure.
    /// 
    /// - Parameter value: A closure that extracts a comparable value from a model instance
    init(_ value: @escaping @Sendable (Model) -> Value) {
        self.value = value
    }
    
    /// Compares two model instances using the extracted values and sort direction.
    /// 
    /// - Parameters:
    ///   - a: The first model instance to compare
    ///   - b: The second model instance to compare
    ///   - direction: The direction of the sort
    /// - Returns: A comparison result indicating the relative ordering
    func compare(_ a: Model, _ b: Model, direction: SortDirection) -> ComparisonResult {
        let valueA = value(a)
        let valueB = value(b)
        if valueA < valueB { return direction == .forward ? .orderedAscending : .orderedDescending }
        if valueA > valueB { return direction == .forward ? .orderedDescending : .orderedAscending }
        return .orderedSame
    }
    
    /// Converts this comparator to a type-erased version.
    /// 
    /// - Returns: An `AnySortComparator` that wraps this comparator
    func toAny() -> AnySortComparator<Model> {
        AnySortComparator(self)
    }
}

/// A type-erased wrapper for sort comparators that can work with any model type.
/// 
/// This struct provides a way to store and use sort comparators without knowing their
/// specific generic type parameters. It's useful for creating collections of different
/// sort configurations that can all work with the same model type.
///
/// - Important: Type erased type avoids making SortField generic while keeping the underlying
/// value type intact (no runtime type checks while sorting).
///
/// - Note: The `Model` type must conform to `Sendable` for thread safety.
public struct AnySortComparator<Model>: Sendable where Model: Sendable {
    /// A closure that performs the comparison operation.
    private let compare: @Sendable(Model, Model, SortDirection) -> ComparisonResult
    
    /// Creates a type-erased comparator from a specific comparator instance.
    /// 
    /// - Parameter sort: The specific comparator to wrap
    init<Value: Comparable>(_ sort: SortComparator<Model, Value>) {
        compare = sort.compare
    }
    
    /// Compares two model instances using the wrapped comparator.
    /// 
    /// - Parameters:
    ///   - lhs: The left-hand side model instance
    ///   - rhs: The right-hand side model instance
    ///   - direction: The direction of the sort
    /// - Returns: A comparison result indicating the relative ordering
    func compare(_ lhs: Model, _ rhs: Model, direction: SortDirection) -> ComparisonResult {
        compare(lhs, rhs, direction)
    }
}

extension Array {
    /// Creates a comparison function that can be used to sort arrays based on multiple sort criteria.
    /// 
    /// This method returns a closure that compares two model instances using all the sort
    /// configurations in the array. The sorts are applied in order, with later sorts only
    /// being considered if earlier sorts result in equality.
    /// 
    /// - Returns: A closure that returns `true` if the first model should come before the second
    /// - Note: This method is only available when the array contains `Sort<Field>` elements
    ///   where `Field` conforms to `SortField`.
    func areInIncreasingOrder<Field>() -> (Field.Model, Field.Model) -> Bool where Element == Sort<Field>, Field: SortField {
        return { lhs, rhs in
            for sort in self {
                let result = sort.compare(lhs, rhs)
                switch result {
                case .orderedSame:
                    continue
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                }
            }
            return false
        }
    }
}
