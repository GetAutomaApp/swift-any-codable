// ExampleTests.swift
// Copyright (c) 2025 GetAutomaApp
// All source code and related assets are the property of GetAutomaApp.
// All rights reserved.
//
// This package is freely distributable under a modified version of the BSD 2-Clause License.
// This Package is a modified fork of https://github.com/GetAutomaApp/swift-any-codable.

import AnyCodable
import Foundation
import Testing

@Suite
internal struct ExampleTests {
    @Test("Working with AnyCodableValue")
    private func exampleWorkingWithAnyCodableValue() throws {
        let jsonData = Data(#"{ "key": 123, "nested": [1, "two", 0.3] }"#.utf8)
        let decoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)

        if let intValue = decoded["key"]?.integerValue {
            print(intValue) // 123
        }

        if let array = decoded["nested"]?.arrayValue {
            print(array) // [.unsignedInteger8(1), .string(two), .float(0.3)]
        }

        #expect(decoded["key"]?.integerValue == 123)
        #expect(decoded["nested"]?.arrayValue == [.unsignedInteger8(1), .string("two"), .float(0.3)])
    }

    @Test("Flexible Coding Keys with AnyCodableKey")
    private func exampleFlexibleCodingKeysWithAnyCodableKey() throws {
        struct Post: Codable {
            var title: String
            var author: String
            var unsupportedValues: [String: AnyCodableValue]

            enum CodingKeys: String, CodingKey, CaseIterable {
                case title
                case author
            }

            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                title = try container.decode(String.self, forKey: .title)
                author = try container.decode(String.self, forKey: .author)

                let unsupportedContainer = try decoder.container(keyedBy: AnyCodableKey.self)
                var unsupportedValues: [String: AnyCodableValue] = [:]
                for key in unsupportedContainer.allKeys
                    where CodingKeys.allCases.map(AnyCodableKey.init).contains(key) == false
                {
                    unsupportedValues[key.stringValue] = try unsupportedContainer.decode(
                        AnyCodableValue.self,
                        forKey: key
                    )
                }
                self.unsupportedValues = unsupportedValues
            }

            func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: AnyCodableKey.self)
                try container.encode(title, forKey: AnyCodableKey(CodingKeys.title.rawValue))
                try container.encode(author, forKey: AnyCodableKey(CodingKeys.author.rawValue))

                for (key, value) in unsupportedValues {
                    try container.encode(value, forKey: AnyCodableKey(key))
                }
            }
        }

        let jsonData =
            Data(#"{"title": "Example", "author": "Jelly", "date": "2025-01-01T12:34:56Z", "draft": true}"#
                .utf8)
        let post = try JSONDecoder().decode(Post.self, from: jsonData)
        // Post(
        // title: "Example",
        // author: "Jelly",
        // unsupportedValues: ["draft": .bool(true),
        // "date": .string("2025-01-01T12:34:56Z")]
        // )
        print(post)

        let encoded = try JSONEncoder().encode(post)
        // {"author":"Jelly","draft":true,"title":"Example","date":"2025-01-01T12:34:56Z"}
        print(String(data: encoded, encoding: .utf8) ?? "")

        #expect(post.title == "Example")
        #expect(post.author == "Jelly")
        #expect(post.unsupportedValues["date"]?.stringValue == "2025-01-01T12:34:56Z")
        #expect(post.unsupportedValues["draft"]?.boolValue == true)
    }

    @Test("Decoding Collections with InstancesOf")
    private func exampleDecodingCollectionsWithInstancesOf() throws {
        let jsonData = Data("""
        {
        	"data": {
        		"repository": {
        			"milestone": {
        				"title": "v2025.1",
        				"issues": {
        					"nodes": [
        						 {
        							 "number": 100,
        							 "title": "A very real problem!"
        						 },
        						 {
        							 "number": 101,
        							 "title": "Less of a problem, more of a request."
        						 },
        					]
        				}
        			}
        		}
        	}
        }
        """.utf8)

        struct Milestone: Decodable, Equatable {
            var title: String
            var issues: [Issue]

            enum CodingKeys: String, CodingKey {
                case title
                case issues
            }

            init(title: String, issues: [Issue]) {
                self.title = title
                self.issues = issues
            }

            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                title = try container.decode(String.self, forKey: .title)
                issues = try container.decode(instancesOf: Issue.self, forKey: .issues)
            }
        }

        struct Issue: Decodable, Equatable {
            var number: Int
            var title: String
        }

        let milestones = try JSONDecoder().decode(InstancesOf<Milestone>.self, from: jsonData)
        // [
        // Milestone(
        // title: "v2025.1",
        // issues: [
        //   Issue(
        //     number: 100,
        //     title: "A very real problem!"
        //   ),
        //   Issue(
        //     number: 101,
        //     title: "Less of a problem, more of a request."
        //   )
        //   ]
        //  )
        // ]
        print(Array(milestones))

        #expect(
            Array(milestones) == [
                Milestone(
                    title: "v2025.1",
                    issues: [
                        Issue(number: 100, title: "A very real problem!"),
                        Issue(number: 101, title: "Less of a problem, more of a request."),
                    ]
                ),
            ]
        )
    }
}
