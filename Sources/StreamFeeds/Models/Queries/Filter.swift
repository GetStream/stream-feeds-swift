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
}

extension Filter {
    public static func equal<F>(_ field: FilterField, value: any FilterValue) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .equal, field: field, value: value)
    }
    
    public static func and<F>(_ filters: [F]) -> F where F: Filter, F.FilterField == FilterField {
        F(filterOperator: .and, field: .and, value: filters)
    }
}

// MARK: - Supported Filter Values

extension String: FilterValue {}

extension Array: FilterValue where Element: FilterValue {}

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
