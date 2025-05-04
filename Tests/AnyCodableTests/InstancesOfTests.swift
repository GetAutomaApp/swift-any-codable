// InstancesOfTests.swift
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
internal struct InstancesOfTests {
    public struct TestItem: Codable, Equatable {
        public let id: Int
        public let name: String
    }

    @Test
    private func decodeInvalidData() throws {
        let jsonData = Data(#""INVALID""#.utf8)
        let result = try JSONDecoder().decode(InstancesOf<Int>.self, from: jsonData)

        #expect(Array(result) == [])
    }

    @Test
    private func decodeSimpleArray() throws {
        let jsonData = Data(#"[1, 2, 3, 4]"#.utf8)
        let result = try JSONDecoder().decode(InstancesOf<Int>.self, from: jsonData)

        #expect(Array(result) == [1, 2, 3, 4])
    }

    @Test
    private func decodeDictionary() throws {
        let jsonData = Data(#"{"item": {"id": 1, "name": "Item 1"}}"#.utf8)
        let result = try JSONDecoder().decode(InstancesOf<TestItem>.self, from: jsonData)

        #expect(Array(result) == [
            TestItem(id: 1, name: "Item 1"),
        ])
    }

    @Test
    private func decodeNestedObjects() throws {
        let jsonData = Data(#"[{"id": 1, "name": "Item 1"}, {"id": 2, "name": "Item 2"}]"#.utf8)
        let result = try JSONDecoder().decode(InstancesOf<TestItem>.self, from: jsonData)

        #expect(Array(result) == [
            TestItem(id: 1, name: "Item 1"),
            TestItem(id: 2, name: "Item 2"),
        ])
    }

    @Test
    private func decodeEmptyArray() throws {
        let jsonData = Data(#"[]"#.utf8)
        let result = try JSONDecoder().decode(InstancesOf<Int>.self, from: jsonData)

        #expect(result.isEmpty)
    }

    @Test
    private func decodeComplexStructure() throws {
        let jsonData = Data(#"[{"id": 1, "name": "Nested", "nested": [1, 2]}, {"id": 2, "name": "Simple"}]"#.utf8)

        struct ComplexItem: Codable, Equatable {
            let id: Int
            let name: String
            let nested: [Int]?
        }

        let result = try JSONDecoder().decode(InstancesOf<ComplexItem>.self, from: jsonData)

        #expect(Array(result) == [
            ComplexItem(id: 1, name: "Nested", nested: [1, 2]),
            ComplexItem(id: 2, name: "Simple", nested: nil),
        ])
    }

    @Test
    private func randomAccessCollectionCompliance() throws {
        let jsonData = Data(#"["a", "b", "c"]"#.utf8)
        let result = try JSONDecoder().decode(InstancesOf<String>.self, from: jsonData)

        #expect(result.startIndex == 0)
        #expect(result.endIndex == 3)
        #expect(result[0] == "a")
        #expect(result[1] == "b")
        #expect(result[2] == "c")
        #expect(result.indices == 0 ..< 3)
    }

    @Test
    private func encodeSimpleArray() throws {
        let instances = InstancesOf([1, 2, 3, 4])
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let jsonData = try encoder.encode(instances)
        let jsonString = String(data: jsonData, encoding: .utf8)

        #expect(jsonString == #"[1,2,3,4]"#)
    }

    @Test
    private func encodeNestedObjects() throws {
        let instances = InstancesOf([
            TestItem(id: 1, name: "Item 1"),
            TestItem(id: 2, name: "Item 2"),
        ])
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let jsonData = try encoder.encode(instances)
        let jsonString = String(data: jsonData, encoding: .utf8)

        #expect(jsonString == #"[{"id":1,"name":"Item 1"},{"id":2,"name":"Item 2"}]"#)
    }

    @Test
    private func encodeEmptyArray() throws {
        let instances = InstancesOf<Int>([])
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let jsonData = try encoder.encode(instances)
        let jsonString = String(data: jsonData, encoding: .utf8)

        #expect(jsonString == "[]")
    }
}
