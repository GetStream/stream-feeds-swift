//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public protocol Filter: Sendable {
    associatedtype FilterField: FilterFieldRawRepresentable
    var field: FilterField { get }
    var value: any FilterValue { get }
    var `operator`: FilterOperator { get }
    
    init(operator: FilterOperator, field: FilterField, value: any FilterValue)
}

public protocol FilterValue: Sendable {}
public protocol FilterFieldRawRepresentable {
    var rawValue: String { get }
}

extension Filter {
    public static func equal<T>(_ field: FilterField, value: any FilterValue) -> T where T: Filter, T.FilterField == FilterField {
        T(operator: .equal, field: field, value: value)
    }
}

extension String: FilterValue {}

extension Filter {
    var toRawJSON: [String: RawJSON] {
        // TODO: Nested filters
        switch value {
        case let stringValue as String:
            [field.rawValue: .string(stringValue)]
        default:
            fatalError("Unimplemented type: \(value)")
        }
        
    }
}
