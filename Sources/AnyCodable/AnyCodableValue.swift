// AnyCodableValue.swift
// Copyright (c) 2025 GetAutomaApp
// All source code and related assets are the property of GetAutomaApp.
// All rights reserved.
//
// This package is freely distributable under a modified version of the BSD 2-Clause License.
// This Package is a modified fork of https://github.com/GetAutomaApp/swift-any-codable.

// Copyright (c) 2025 Daniel Farrelly
// Licensed under BSD 2-Clause "Simplified" License
//
// See the LICENSE file for license information
import Foundation

/// A type that encapsulates a value of any codable type.
public enum AnyCodableValue: Codable, Hashable, Equatable, CustomDebugStringConvertible, Sendable {
    /// Represents an array of `AnyCodableValue` elements.
    case array([Self])

    /// Represents a `Bool` value.
    case bool(Bool)

    /// Represents a `Data` value.
    case data(Data)

    /// Represents a `Date` value.
    case date(Date)

    /// Represents a dictionary of `AnyCodableKey` to `AnyCodableValue` pairs.
    case dictionary([AnyCodableKey: Self])

    /// Represents a `Double` value.
    case double(Double)

    /// Represents a `Float` value.
    case float(Float)

    /// Represents a signed `Int` value.
    case integer(Int)

    /// Represents a signed `Int16` value.
    case integer16(Int16)

    /// Represents a signed `Int32` value.
    case integer32(Int32)

    /// Represents a signed `Int64` value.
    case integer64(Int64)

    /// Represents a signed `Int8` value.
    case integer8(Int8)

    /// Represents a `String` value.
    case string(String)

    /// Represents an unsigned `UInt` value.
    case unsignedInteger(UInt)

    /// Represents an unsigned `UInt16` value.
    case unsignedInteger16(UInt16)

    /// Represents an unsigned `UInt32` value.
    case unsignedInteger32(UInt32)

    /// Represents an unsigned `UInt64` value.
    case unsignedInteger64(UInt64)

    /// Represents an unsigned `UInt8` value.
    case unsignedInteger8(UInt8)

    /// Initializes a new `AnyCodableValue` instance from a given value.
    ///
    /// - Parameter value: The value to represent.
    /// - Returns: An `AnyCodableValue` if the value is supported, otherwise `nil`.
    public init?(_ value: Any) {
        switch value {
        case let value as Date:
            self = .date(value)
        case let value as Bool:
            self = .bool(value)
        case let value as String:
            self = .string(value)
        case let value as Double:
            self = .double(value)
        case let value as Float:
            self = .float(value)
        case let value as Int:
            self = .integer(value)
        case let value as Int8:
            self = .integer8(value)
        case let value as Int16:
            self = .integer16(value)
        case let value as Int32:
            self = .integer32(value)
        case let value as Int64:
            self = .integer64(value)
        case let value as UInt:
            self = .unsignedInteger(value)
        case let value as UInt8:
            self = .unsignedInteger8(value)
        case let value as UInt16:
            self = .unsignedInteger16(value)
        case let value as UInt32:
            self = .unsignedInteger32(value)
        case let value as UInt64:
            self = .unsignedInteger64(value)
        case let value as Data:
            self = .data(value)
        case let value as [AnyCodableKey: Self]:
            self = .dictionary(value)
        case let value as [Self]:
            self = .array(value)
        default:
            return nil
        }
    }

    // MARK: Accessing values

    /// Retrieves the underlying value as an `AnyHashable`.
    ///
    /// - Returns: The value, wrapped in an `AnyHashable`.
    public var value: AnyHashable {
        switch self {
        case let .date(value): value
        case let .bool(value): value
        case let .string(value): value
        case let .double(value): value
        case let .float(value): value
        case let .integer(value): value
        case let .integer8(value): value
        case let .integer16(value): value
        case let .integer32(value): value
        case let .integer64(value): value
        case let .unsignedInteger(value): value
        case let .unsignedInteger8(value): value
        case let .unsignedInteger16(value): value
        case let .unsignedInteger32(value): value
        case let .unsignedInteger64(value): value
        case let .data(value): value
        case let .dictionary(value): value
        case let .array(value): value
        }
    }

    /// Attempts to retrieve the value as a `Date`.
    ///
    /// - Returns: The `Date` value if the underlying type is `.date`, otherwise `nil`.
    public var dateValue: Date? {
        switch self {
        case let .date(value): value
        default: nil
        }
    }

    /// Attempts to retrieve the value as a `Bool`.
    ///
    /// - Returns: The `Bool` value if the underlying type is `.bool`, otherwise `nil`.
    public var boolValue: Bool? {
        switch self {
        case let .bool(value): value
        default: nil
        }
    }

    /// Attempts to retrieve the value as a `String`.
    ///
    /// - Returns: The `String` value if the underlying type is `.string`, otherwise `nil`.
    public var stringValue: String? {
        switch self {
        case let .string(value): value
        default: nil
        }
    }

    /// Attempts to retrieve the value as a `Double`.
    ///
    /// - Returns: The `Double` value if the underlying type is `.double`.
    /// 	  Or if the value is numeric and convertible to `Double`, otherwise `nil`.
    public var doubleValue: Double? {
        switch self {
        case let .double(value): value
        case let .float(value): Double(value)
        case let .integer(value): Double(value)
        case let .integer8(value): Double(value)
        case let .integer16(value): Double(value)
        case let .integer32(value): Double(value)
        case let .integer64(value): Double(value)
        case let .unsignedInteger(value): Double(value)
        case let .unsignedInteger8(value): Double(value)
        case let .unsignedInteger16(value): Double(value)
        case let .unsignedInteger32(value): Double(value)
        case let .unsignedInteger64(value): Double(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as a `Float`.
    ///
    /// - Returns: The `Float` value if the underlying type is `.float`.
    ///    Or if the value is numeric and convertible to `Float`, otherwise `nil`.
    public var floatValue: Float? {
        switch self {
        case let .double(value): Float(value)
        case let .float(value): value
        case let .integer(value): Float(value)
        case let .integer8(value): Float(value)
        case let .integer16(value): Float(value)
        case let .integer32(value): Float(value)
        case let .integer64(value): Float(value)
        case let .unsignedInteger(value): Float(value)
        case let .unsignedInteger8(value): Float(value)
        case let .unsignedInteger16(value): Float(value)
        case let .unsignedInteger32(value): Float(value)
        case let .unsignedInteger64(value): Float(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `Int`.
    ///
    /// - Returns: The `Int` value if the underlying type is `.integer`
    ///    Or if the value is numeric and convertible to `Int`, otherwise `nil`.
    public var integerValue: Int? {
        switch self {
        case let .double(value): Int(value)
        case let .float(value): Int(value)
        case let .integer(value): Int(value)
        case let .integer8(value): Int(value)
        case let .integer16(value): Int(value)
        case let .integer32(value): Int(value)
        case let .integer64(value): Int(value)
        case let .unsignedInteger(value): Int(value)
        case let .unsignedInteger8(value): Int(value)
        case let .unsignedInteger16(value): Int(value)
        case let .unsignedInteger32(value): Int(value)
        case let .unsignedInteger64(value): Int(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `Int8`.
    ///
    /// - Returns: The `Int8` value if the underlying type is `.integer8`.
    ///    Or if the value is numeric and convertible to `Int8`, otherwise `nil`.
    public var integer8Value: Int8? {
        switch self {
        case let .double(value): Int8(value)
        case let .float(value): Int8(value)
        case let .integer(value): Int8(value)
        case let .integer8(value): Int8(value)
        case let .integer16(value): Int8(value)
        case let .integer32(value): Int8(value)
        case let .integer64(value): Int8(value)
        case let .unsignedInteger(value): Int8(value)
        case let .unsignedInteger8(value): Int8(value)
        case let .unsignedInteger16(value): Int8(value)
        case let .unsignedInteger32(value): Int8(value)
        case let .unsignedInteger64(value): Int8(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `Int16`.
    ///
    /// - Returns: The `Int16` value if the underlying type is `.integer16`.
    ///    Or if the value is numeric and convertible to `Int16`, otherwise `nil`.
    public var integer16Value: Int16? {
        switch self {
        case let .double(value): Int16(value)
        case let .float(value): Int16(value)
        case let .integer(value): Int16(value)
        case let .integer8(value): Int16(value)
        case let .integer16(value): Int16(value)
        case let .integer32(value): Int16(value)
        case let .integer64(value): Int16(value)
        case let .unsignedInteger(value): Int16(value)
        case let .unsignedInteger8(value): Int16(value)
        case let .unsignedInteger16(value): Int16(value)
        case let .unsignedInteger32(value): Int16(value)
        case let .unsignedInteger64(value): Int16(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `Int32`.
    ///
    /// - Returns: The `Int32` value if the underlying type is `.integer32`.
    ///    Or if the value is numeric and convertible to `Int32`, otherwise `nil`.
    public var integer32Value: Int32? {
        switch self {
        case let .double(value): Int32(value)
        case let .float(value): Int32(value)
        case let .integer(value): Int32(value)
        case let .integer8(value): Int32(value)
        case let .integer16(value): Int32(value)
        case let .integer32(value): Int32(value)
        case let .integer64(value): Int32(value)
        case let .unsignedInteger(value): Int32(value)
        case let .unsignedInteger8(value): Int32(value)
        case let .unsignedInteger16(value): Int32(value)
        case let .unsignedInteger32(value): Int32(value)
        case let .unsignedInteger64(value): Int32(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `Int64`.
    ///
    /// - Returns: The `Int64` value if the underlying type is `.integer64`.
    ///    Or if the value is numeric and convertible to `Int64`, otherwise `nil`.
    public var integer64Value: Int64? {
        switch self {
        case let .double(value): Int64(value)
        case let .float(value): Int64(value)
        case let .integer(value): Int64(value)
        case let .integer8(value): Int64(value)
        case let .integer16(value): Int64(value)
        case let .integer32(value): Int64(value)
        case let .integer64(value): Int64(value)
        case let .unsignedInteger(value): Int64(value)
        case let .unsignedInteger8(value): Int64(value)
        case let .unsignedInteger16(value): Int64(value)
        case let .unsignedInteger32(value): Int64(value)
        case let .unsignedInteger64(value): Int64(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `UInt`.
    ///
    /// - Returns: The `UInt` value if the underlying type is `.unsignedInteger`.
    ///    Or if the value is numeric and convertible to `UInt`, otherwise `nil`.
    public var unsignedIntegerValue: UInt? {
        switch self {
        case let .double(value): UInt(value)
        case let .float(value): UInt(value)
        case let .integer(value): UInt(value)
        case let .integer8(value): UInt(value)
        case let .integer16(value): UInt(value)
        case let .integer32(value): UInt(value)
        case let .integer64(value): UInt(value)
        case let .unsignedInteger(value): UInt(value)
        case let .unsignedInteger8(value): UInt(value)
        case let .unsignedInteger16(value): UInt(value)
        case let .unsignedInteger32(value): UInt(value)
        case let .unsignedInteger64(value): UInt(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `UInt8`.
    ///
    /// - Returns: The `UInt8` value if the underlying type is `.unsignedInteger8`.
    ///    Or if the value is numeric and convertible to `UInt8`, otherwise `nil`.
    public var unsignedInteger8Value: UInt8? {
        switch self {
        case let .double(value): UInt8(value)
        case let .float(value): UInt8(value)
        case let .integer(value): UInt8(value)
        case let .integer8(value): UInt8(value)
        case let .integer16(value): UInt8(value)
        case let .integer32(value): UInt8(value)
        case let .integer64(value): UInt8(value)
        case let .unsignedInteger(value): UInt8(value)
        case let .unsignedInteger8(value): UInt8(value)
        case let .unsignedInteger16(value): UInt8(value)
        case let .unsignedInteger32(value): UInt8(value)
        case let .unsignedInteger64(value): UInt8(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `UInt16`.
    ///
    /// - Returns: The `UInt16` value if the underlying type is `.unsignedInteger16`.
    ///    Or if the value is numeric and convertible to `UInt16`, otherwise `nil`.
    public var unsignedInteger16Value: UInt16? {
        switch self {
        case let .double(value): UInt16(value)
        case let .float(value): UInt16(value)
        case let .integer(value): UInt16(value)
        case let .integer8(value): UInt16(value)
        case let .integer16(value): UInt16(value)
        case let .integer32(value): UInt16(value)
        case let .integer64(value): UInt16(value)
        case let .unsignedInteger(value): UInt16(value)
        case let .unsignedInteger8(value): UInt16(value)
        case let .unsignedInteger16(value): UInt16(value)
        case let .unsignedInteger32(value): UInt16(value)
        case let .unsignedInteger64(value): UInt16(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `UInt32`.
    ///
    /// - Returns: The `UInt32` value if the underlying type is `.unsignedInteger32`.
    ///    Or if the value is numeric and convertible to `UInt32`, otherwise `nil`.
    public var unsignedInteger32Value: UInt32? {
        switch self {
        case let .double(value): UInt32(value)
        case let .float(value): UInt32(value)
        case let .integer(value): UInt32(value)
        case let .integer8(value): UInt32(value)
        case let .integer16(value): UInt32(value)
        case let .integer32(value): UInt32(value)
        case let .integer64(value): UInt32(value)
        case let .unsignedInteger(value): UInt32(value)
        case let .unsignedInteger8(value): UInt32(value)
        case let .unsignedInteger16(value): UInt32(value)
        case let .unsignedInteger32(value): UInt32(value)
        case let .unsignedInteger64(value): UInt32(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as an `UInt64`.
    ///
    /// - Returns: The `UInt64` value if the underlying type is `.unsignedInteger64`.
    ///    Or if the value is numeric and convertible to `UInt64`, otherwise `nil`.
    public var unsignedInteger64Value: UInt64? {
        switch self {
        case let .double(value): UInt64(value)
        case let .float(value): UInt64(value)
        case let .integer(value): UInt64(value)
        case let .integer8(value): UInt64(value)
        case let .integer16(value): UInt64(value)
        case let .integer32(value): UInt64(value)
        case let .integer64(value): UInt64(value)
        case let .unsignedInteger(value): UInt64(value)
        case let .unsignedInteger8(value): UInt64(value)
        case let .unsignedInteger16(value): UInt64(value)
        case let .unsignedInteger32(value): UInt64(value)
        case let .unsignedInteger64(value): UInt64(value)
        default: nil
        }
    }

    /// Attempts to retrieve the value as a `Data`.
    ///
    /// - Returns: The `Data` value if the underlying type is `.data`, otherwise `nil`.
    public var dataValue: Data? {
        switch self {
        case let .data(value): value
        default: nil
        }
    }

    /// Attempts to retrieve the value as a dictionary.
    ///
    /// - Returns: A dictionary of type `[AnyCodableKey: AnyCodableValue]` if the underlying type is `.dictionary`.
    ///    Otherwise `nil`.
    public var dictionaryValue: [AnyCodableKey: Self]? {
        switch self {
        case let .dictionary(value): value
        default: nil
        }
    }

    /// Attempts to retrieve the value as an array.
    ///
    /// - Returns: An array of `AnyCodableValue` if the underlying type is `.array`, otherwise `nil`.
    public var arrayValue: [Self]? {
        switch self {
        case let .array(value): value
        default: nil
        }
    }

    // MARK: Codable

    /// Decodes a value from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if decoding fails or if the value cannot be represented as an `AnyCodableValue`.
    public init(from decoder: Decoder) throws {
        do {
            var container = try decoder.unkeyedContainer()
            var array: [Self] = []

            while !container.isAtEnd {
                try array.append(container.decode(Self.self))
            }

            self = .array(array)
        } catch {
            do {
                let container = try decoder.container(keyedBy: AnyCodableKey.self)
                var dictionary: [AnyCodableKey: Self] = [:]

                for key in container.allKeys {
                    dictionary[key] = try container.decode(Self.self, forKey: key)
                }

                self = .dictionary(dictionary)
            } catch {
                let container = try decoder.singleValueContainer()

                let attempts: [() throws -> Self] = [
                    { try .bool(container.decode(Bool.self)) },
                    { try .string(container.decode(String.self)) },
                    { try .unsignedInteger8(container.decode(UInt8.self)) },
                    { try .unsignedInteger16(container.decode(UInt16.self)) },
                    { try .unsignedInteger32(container.decode(UInt32.self)) },
                    { try .unsignedInteger64(container.decode(UInt64.self)) },
                    { try .integer8(container.decode(Int8.self)) },
                    { try .integer16(container.decode(Int16.self)) },
                    { try .integer32(container.decode(Int32.self)) },
                    { try .integer64(container.decode(Int64.self)) },
                    { try .float(container.decode(Float.self)) },
                    { try .double(container.decode(Double.self)) },
                    { try .date(container.decode(Date.self)) },
                    { try .data(container.decode(Data.self)) },
                ]

                for attempt in attempts {
                    if let value = try? attempt() {
                        self = value
                        return
                    }
                }

                throw DecodingError.typeMismatch(
                    Self.self,
                    .init(
                        codingPath: container.codingPath,
                        debugDescription: "Value cannot be represented as AnyCodableValue"
                    )
                )
            }
        }
    }

    /// Encodes the value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .date(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .bool(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .string(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .double(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .float(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .integer(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .integer8(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .integer16(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .integer32(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .integer64(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .unsignedInteger(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .unsignedInteger8(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .unsignedInteger16(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .unsignedInteger32(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .unsignedInteger64(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .data(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .array(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)

        case let .dictionary(dictionary):
            var container = encoder.container(keyedBy: AnyCodableKey.self)
            for (key, value) in dictionary {
                try container.encode(value, forKey: key)
            }
        }
    }

    // MARK: Custom debug string convertible

    /// Provides a textual representation for debugging purposes.
    ///
    /// - Returns: A string describing the value and its type.
    public var debugDescription: String {
        switch self {
        case let .date(value): ".date(\(value))"
        case let .bool(value): ".bool(\(value))"
        case let .string(value): ".string(\(value))"
        case let .double(value): ".double(\(value))"
        case let .float(value): ".float(\(value))"
        case let .integer(value): ".integer(\(value))"
        case let .integer8(value): ".integer8(\(value))"
        case let .integer16(value): ".integer16(\(value))"
        case let .integer32(value): ".integer32(\(value))"
        case let .integer64(value): ".integer64(\(value))"
        case let .unsignedInteger(value): ".unsignedInteger(\(value))"
        case let .unsignedInteger8(value): ".unsignedInteger8(\(value))"
        case let .unsignedInteger16(value): ".unsignedInteger16(\(value))"
        case let .unsignedInteger32(value): ".unsignedInteger32(\(value))"
        case let .unsignedInteger64(value): ".unsignedInteger64(\(value))"
        case let .data(value): ".data(\(value))"
        case let .dictionary(value): ".dictionary(\(value))"
        case let .array(value): ".array(\(value))"
        }
    }
}
