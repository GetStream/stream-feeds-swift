//
//  AnyEncodable.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 2.6.25.
//

import Foundation

struct AnyEncodable: Encodable {
    let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try encodable.encode(to: &container)
    }
}

extension Encodable {
    var asAnyEncodable: AnyEncodable {
        AnyEncodable(self)
    }

    // We need this helper in order to encode AnyEncodable with a singleValueContainer,
    // this is needed for the encoder to apply the encoding strategies of the inner type (encodable).
    // More details about this in the following thread:
    // https://forums.swift.org/t/how-to-encode-objects-of-unknown-type/12253/10
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
