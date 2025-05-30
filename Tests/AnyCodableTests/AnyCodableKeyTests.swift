// AnyCodableKeyTests.swift
// Copyright (c) 2025 GetAutomaApp
// All source code and related assets are the property of GetAutomaApp.
// All rights reserved.
//
// This package is freely distributable under a modified version of the BSD 2-Clause License.
// This Package is a modified fork of https://github.com/GetAutomaApp/swift-any-codable.

@testable import AnyCodable
import Foundation
import Testing

@Suite
internal struct AnyCodableKeyTests {
    private enum StringCodingKey: String, CodingKey {
        case example
    }

    private enum IntegerCodingKey: Int, CodingKey {
        case example = 12_345
    }

    @Test
    private func initWithStringCodingKey() {
        let codingKey = StringCodingKey.example
        let anyCodableKey = AnyCodableKey(codingKey)

        #expect(anyCodableKey == .string(codingKey.rawValue))
    }

    @Test
    private func initWithIntegerCodingKey() {
        let codingKey = IntegerCodingKey.example
        let anyCodableKey = AnyCodableKey(codingKey)

        #expect(anyCodableKey == .integer(codingKey.rawValue))
    }

    @Test
    private func initWithStringValue() {
        let stringValue = "example"
        let expectation = AnyCodableKey.string(stringValue)

        #expect(AnyCodableKey(stringValue: stringValue) == expectation)
    }

    @Test
    private func initWithIntegerValue() {
        let intValue = 12_345
        let expectation = AnyCodableKey.integer(intValue)

        #expect(AnyCodableKey(intValue: intValue) == expectation)
    }

    @Test
    private func stringValue() {
        #expect(
            AnyCodableKey.string("example").stringValue == "example"
        )
        #expect(
            AnyCodableKey.string("12345").stringValue == "12345"
        )
        #expect(
            AnyCodableKey.integer(12_345).stringValue == "12345"
        )
    }

    @Test
    private func integerValue() {
        #expect(
            AnyCodableKey.string("example").intValue == nil
        )
        #expect(
            AnyCodableKey.string("12345").intValue == 12_345
        )
        #expect(
            AnyCodableKey.integer(12_345).intValue == 12_345
        )
    }

    @Test
    private func losslessStringConvertible() {
        let string = "example"
        let example = AnyCodableKey(string)
        #expect(example == AnyCodableKey(stringValue: string))
        #expect(example.description == string)
    }

    @Test
    private func decodeStringValue() throws {
        let data = Data(#""example""#.utf8)
        let anyCodableKey = try JSONDecoder().decode(AnyCodableKey.self, from: data)

        #expect(anyCodableKey == .string("example"))
    }

    @Test
    private func decodeIntegerValue() throws {
        let data = Data(#"12345"#.utf8)
        let anyCodableKey = try JSONDecoder().decode(AnyCodableKey.self, from: data)

        #expect(anyCodableKey == .integer(12_345))
    }

    @Test
    private func decodeNullValue() throws {
        let data = Data(#"null"#.utf8)
        #expect(throws: Error.self) {
            try JSONDecoder().decode(AnyCodableKey.self, from: data)
        }
    }

    @Test
    private func encodeStringValue() throws {
        let expectation = Data(#""example""#.utf8)
        let anyCodableKey = AnyCodableKey.string("example")
        let encoded = try JSONEncoder().encode(anyCodableKey)

        #expect(encoded == expectation)
    }

    @Test
    private func encodeIntegerValue() throws {
        let expectation = Data(#"12345"#.utf8)
        let anyCodableKey = AnyCodableKey.integer(12_345)
        let encoded = try JSONEncoder().encode(anyCodableKey)

        #expect(encoded == expectation)
    }
}
