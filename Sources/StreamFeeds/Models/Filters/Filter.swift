//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public protocol Filter: FilterValue, Sendable {
    associatedtype FilterField: FilterFieldRepresentable
    var field: FilterField { get }
    var value: any FilterValue { get }
    var filterOperator: FilterOperator { get }
    
    init(filterOperator: FilterOperator, field: FilterField, value: any FilterValue)
}

public protocol FilterValue: Sendable {}
public protocol FilterFieldRepresentable: Sendable {
    var value: String { get }
    init(value: String)
}

extension FilterFieldRepresentable {
    static var and: Self { Self(value: "$and") }
    static var or: Self { Self(value: "$or") }
}

// MARK: - Filter Building

extension Filter {
    public static func equal(_ field: FilterField, _ value: any FilterValue) -> Self {
        Self(filterOperator: .equal, field: field, value: value)
    }
    
    public static func greater(_ field: FilterField, _ value: any FilterValue) -> Self {
        Self(filterOperator: .greater, field: field, value: value)
    }
    
    public static func greaterOrEqual(_ field: FilterField, _ value: any FilterValue) -> Self {
        Self(filterOperator: .greaterOrEqual, field: field, value: value)
    }
    
    public static func less(_ field: FilterField, _ value: any FilterValue) -> Self {
        Self(filterOperator: .less, field: field, value: value)
    }
    
    public static func lessOrEqual(_ field: FilterField, _ value: any FilterValue) -> Self {
        Self(filterOperator: .lessOrEqual, field: field, value: value)
    }
    
    public static func `in`<Value>(_ field: FilterField, _ values: [Value]) -> Self where Value: FilterValue {
        Self(filterOperator: .in, field: field, value: values)
    }
    
    public static func exists(_ field: FilterField, _ value: Bool) -> Self {
        Self(filterOperator: .exists, field: field, value: value)
    }
    
    public static func contains(_ field: FilterField, _ value: String) -> Self {
        Self(filterOperator: .contains, field: field, value: value)
    }
    
    public static func contains(_ field: FilterField, _ value: [String: RawJSON]) -> Self {
        Self(filterOperator: .contains, field: field, value: value)
    }
    
    public static func pathExists(_ field: FilterField, _ value: String) -> Self {
        Self(filterOperator: .pathExists, field: field, value: value)
    }
    
    public static func autocomplete(_ field: FilterField, _ value: String) -> Self {
        Self(filterOperator: .autocomplete, field: field, value: value)
    }

    public static func query(_ field: FilterField, _ value: String) -> Self {
        Self(filterOperator: .query, field: field, value: value)
    }
        
    public static func and<F>(_ filters: [F]) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .and, field: .and, value: filters)
    }
    
    public static func or<F>(_ filters: [F]) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .or, field: .and, value: filters)
    }
}

// MARK: - Supported Filter Values

extension Bool: FilterValue {}
extension Date: FilterValue {}
extension Double: FilterValue {}
extension Float: FilterValue {}
extension Int: FilterValue {}
extension String: FilterValue {}
extension URL: FilterValue {}

extension Array: FilterValue where Element: FilterValue {}
extension Dictionary: FilterValue where Key == String, Value == RawJSON {}

// MARK: - Filter to RawJSON Conversion

extension Filter {
    func toRawJSON() -> [String: RawJSON] {
        if filterOperator.isGroup {
            // Filters with group operators are encoded in the following form:
            //  { $<operator>: [ <filter 1>, <filter 2> ] }
            guard let filters = value as? [any Filter] else {
                log.error("Unknown filter value used with \(filterOperator)")
                return [:]
            }
            let rawJSONFilters = filters.map { $0.toRawJSON() }.map { RawJSON.dictionary($0) }
            return [filterOperator.rawValue: .array(rawJSONFilters)]
        } else {
            // Normal filters are encoded in the following form:
            //  { field: { $<operator>: <value> } }
            return [field.value: .dictionary([filterOperator.rawValue: value.rawJSON])]
        }
    }
}

extension FilterValue {
    var rawJSON: RawJSON {
        switch self {
        case let boolValue as Bool:
            return .bool(boolValue)
        case let dateValue as Date:
            return .string(RFC3339DateFormatter.string(from: dateValue))
        case let doubleValue as Double:
            return .number(doubleValue)
        case let intValue as Int:
            return .number(Double(intValue))
        case let stringValue as String:
            return .string(stringValue)
        case let urlValue as URL:
            return .string(urlValue.absoluteString)
        case let arrayValue as [any FilterValue]:
            return .array(arrayValue.map { $0.rawJSON })
        case let dictionaryValue as [String: RawJSON]:
            return .dictionary(dictionaryValue)
        default:
            fatalError("Unimplemented type: \(self)")
        }
    }
}
