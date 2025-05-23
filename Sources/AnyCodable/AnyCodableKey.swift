// AnyCodableKey.swift
// Copyright (c) 2025 GetAutomaApp
// All source code and related assets are the property of GetAutomaApp.
// All rights reserved.
//
// This package is freely distributable under a modified version of the BSD 2-Clause License.
// This Package is a modified fork of https://github.com/GetAutomaApp/swift-any-codable.

import Foundation

/// A flexible coding key type that supports both string and integer keys.
///
/// `AnyCodableKey` is designed to handle dynamic and unknown keys in `Codable`
/// containers, providing support for a wide range of use cases.
public enum AnyCodableKey:
    CodingKey, Codable, Hashable, Equatable, ExpressibleByStringLiteral,
    ExpressibleByIntegerLiteral, LosslessStringConvertible, CustomDebugStringConvertible, Sendable
{
    /// Represents an integer-based coding key.
    case integer(Int)

    /// Represents a string-based coding key.
    case string(String)

    /// Initializes a new `AnyCodableKey` from an existing `CodingKey`.
    ///
    /// - Parameter codingKey: The coding key to initialize from.
    public init(_ codingKey: CodingKey) {
        if let intValue = codingKey.intValue {
            self = .integer(intValue)
        } else {
            self = .string(codingKey.stringValue)
        }
    }

    // MARK: Coding key

    /// A string representation of the coding key.
    ///
    /// - Returns: The string value if the key is `.string`, otherwise the integer value converted to a string.
    public var stringValue: String {
        switch self {
        case let .integer(intValue):
            String(intValue)

        case let .string(stringValue):
            stringValue
        }
    }

    /// An integer representation of the coding key.
    ///
    /// - Returns: The integer value if the key is `.integer`.
    ///    Or if the string value can be converted to an `Int`, otherwise `nil`.
    public var intValue: Int? {
        switch self {
        case let .integer(intValue):
            intValue

        case let .string(stringValue):
            Int(stringValue)
        }
    }

    /// Initializes a new `AnyCodableKey` from an integer value.
    ///
    /// - Parameter intValue: The integer value to use as the key.
    public init(intValue: Int) {
        self = .integer(intValue)
    }

    /// Initializes a new `AnyCodableKey` from a string value.
    ///
    /// - Parameter stringValue: The string value to use as the key.
    public init(stringValue: String) {
        self = .string(stringValue)
    }

    // MARK: Codable

    /// Decodes an instance of `AnyCodableKey` from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if decoding fails.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            self = try .integer(container.decode(Int.self))
        } catch {
            do {
                self = try .string(container.decode(String.self))
            } catch {
                throw error
            }
        }
    }

    /// Encodes the `AnyCodableKey` instance into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .integer(value):
            try container.encode(value)

        case let .string(value):
            try container.encode(value)
        }
    }

    // MARK: Hashable

    /// Hashes the essential components of the coding key into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use.
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .integer(intValue):
            hasher.combine(0)
            hasher.combine(intValue)

        case let .string(stringValue):
            hasher.combine(1)
            hasher.combine(stringValue)
        }
    }

    // MARK: Expressible by string literal

    /// Initializes a new `AnyCodableKey` using a string literal.
    ///
    /// - Parameter value: The string literal value to use as the key.
    public init(stringLiteral value: String) {
        self = .string(value)
    }

    // MARK: Expressible by integer literal

    /// Initializes a new `AnyCodableKey` using an integer literal.
    ///
    /// - Parameter value: The integer literal value to use as the key.
    public init(integerLiteral value: Int) {
        self = .integer(value)
    }

    // MARK: Lossless string convertible

    /// Initializes a new `AnyCodableKey` from a string description.
    ///
    /// - Parameter description: The string description to use as the key.
    public init(_ description: String) {
        self.init(stringValue: description)
    }

    /// A string representation of the coding key.
    ///
    /// - Returns: A string value representing the key.
    public var description: String {
        stringValue
    }

    // MARK: Custom debug string convertible

    /// A debug string representation of the coding key.
    ///
    /// - Returns: A debug-friendly string describing the key.
    public var debugDescription: String {
        switch self {
        case let .string(value): "\"\(value)\""
        case let .integer(value): "\(value)"
        }
    }
}
