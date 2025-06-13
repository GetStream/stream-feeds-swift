//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public protocol SortField: Sendable {
    var rawValue: String { get }
}

public struct Sort<Field: SortField>: Sendable {
    public let field: Field
    public let direction: SortDirection

    init(field: Field, direction: SortDirection) {
        self.direction = direction
        self.field = field
    }
}

public enum SortDirection: Int, CustomStringConvertible, Sendable {
    case forward = 1
    case reverse = -1
    
    public var description: String {
        switch self {
        case .forward: "forward"
        case .reverse: "reverse"
        }
    }
}

extension Sort: CustomStringConvertible {
    public var description: String { "\(field.rawValue):\(direction)" }
}
