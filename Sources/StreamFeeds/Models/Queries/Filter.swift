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
    public static func equal<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .equal, field: field, value: value)
    }
    
    public static func greater<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .greater, field: field, value: value)
    }
    
    public static func greaterOrEqual<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .greaterOrEqual, field: field, value: value)
    }
    
    public static func less<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .less, field: field, value: value)
    }
    
    public static func lessOrEqual<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .lessOrEqual, field: field, value: value)
    }
    
    public static func `in`<F>(_ field: FilterField, values: [F]) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .in, field: field, value: values)
    }
    
    public static func exists<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .exists, field: field, value: value)
    }
    
    public static func contains<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .contains, field: field, value: value)
    }
    
    public static func pathExists<F>(_ field: FilterField, value: String) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .pathExists, field: field, value: value)
    }
    
    public static func autocomplete<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .autocomplete, field: field, value: value)
    }

    public static func query<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .query, field: field, value: value)
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

// MARK: - Filter and RawJSON Conversions

extension Dictionary<String, RawJSON> {
    func toQueryFilter<F>() -> F where F: Filter {
        // TODO: Review and tests
        let filters: [F] = compactMap { key, value -> F? in
            if key.hasPrefix("$") {
                // and, or
                return nil
            } else {
                switch value {
                case .dictionary(let operatorValue):
                    guard let pair = operatorValue.first else { return nil }
                    guard let filterOperator = FilterOperator(rawValue: pair.key) else { return nil }
                    guard let filterValue = pair.value as? FilterValue else { return nil }
                    return F(
                        filterOperator: filterOperator,
                        field: F.FilterField(value: key),
                        value: filterValue
                    )
                default:
                    return nil
                }
            }
        }
        return filters.first!
    }
}

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
        case let stringValue as String:
            return .string(stringValue)
        default:
            fatalError("Unimplemented type: \(self)")
        }
    }
}
