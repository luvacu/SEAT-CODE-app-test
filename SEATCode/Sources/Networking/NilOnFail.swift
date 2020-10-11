//
//  NilOnFail.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation

/// Converts errors to nil when serializing/deserializing a Codable
@propertyWrapper
public struct NilOnFail<T>: Codable where T: Codable {
    public let wrappedValue: T?

    public init(from decoder: Decoder) throws {
        self.wrappedValue = try? T(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try? container.encode(wrappedValue)
    }
}
