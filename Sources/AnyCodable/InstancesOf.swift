// InstancesOf.swift
// Copyright (c) 2025 GetAutomaApp
// All source code and related assets are the property of GetAutomaApp.
// All rights reserved.
//
// This package is freely distributable under a modified version of the BSD 2-Clause License.
// This Package is a modified fork of https://github.com/GetAutomaApp/swift-any-codable.

import Foundation

/// A structure that can decode collections of specific `Element` values from complex or nested data sources.
///
/// `InstancesOf` is useful for parsing JSON where the target type is interspersed with other data.
public struct InstancesOf<Element: Decodable>: Decodable {
    /// The decoded collection of elements.
    public let elements: [Element]

    /// Initializes a new `InstancesOf` with the elements of the provided collection.
    internal init(_ elements: some Collection<Element>) {
        self.elements = Array(elements)
    }

    /// Initializes a new `InstancesOf` by decoding elements of the specified type from the provided decoder.
    ///
    /// This initializer attempts to decode elements of type `Element` from either keyed or unkeyed containers.
    /// If no decodable elements are found, `elements` will be an empty array.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) {
        if let container = try? decoder.container(keyedBy: AnyCodableKey.self) {
            self.init(container.decode(instancesOf: Element.self))
        } else if var container = try? decoder.unkeyedContainer() {
            self.init(container.decode(instancesOf: Element.self))
        } else {
            self.init([])
        }
    }
}

extension InstancesOf: RandomAccessCollection {
    /// The starting index of the collection.
    public var startIndex: Int {
        elements.startIndex
    }

    /// The ending index of the collection
    public var endIndex: Int {
        elements.endIndex
    }

    /// Accesses the element at the specified position.
    public subscript(position: Int) -> Element {
        elements[position]
    }
}

extension InstancesOf: Sendable where Element: Sendable {}

extension InstancesOf: Hashable where Element: Hashable {}

extension InstancesOf: Equatable where Element: Equatable {}

extension InstancesOf: Encodable where Element: Encodable {
    /// Encodes the collection of elements into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for element in elements {
            try container.encode(element)
        }
    }
}
