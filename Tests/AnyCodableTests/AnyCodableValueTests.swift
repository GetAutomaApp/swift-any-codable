// Copyright (c) 2025 Daniel Farrelly
// Licensed under BSD 2-Clause "Simplified" License
//
// See the LICENSE file for license information

@testable import AnyCodable
import Foundation
import Testing

@Suite
internal struct AnyCodableValueTests {
	public struct CodableStructure: Codable {
		public let date: Date
		public let bool: Bool
		public let string: String
		public let double: Double
		public let float: Float
		public let integer: Int
		public let integer8: Int8
		public let integer16: Int16
		public let integer32: Int32
		public let integer64: Int64
		public let unsignedInteger: UInt
		public let unsignedInteger8: UInt8
		public let unsignedInteger16: UInt16
		public let unsignedInteger32: UInt32
		public let unsignedInteger64: UInt64
		public let data: Data
		public let dictionary: [Int: String]
		public let array: [String]
	}

	@Test
	private func initialisation() {
		let date: Date = .distantFuture
		#expect(AnyCodableValue(date) == .date(.distantFuture))

		let bool: Bool = true
		#expect(AnyCodableValue(bool) == .bool(true))

		let string: String = "example"
		#expect(AnyCodableValue(string) == .string("example"))

		let double: Double = 12_345.6789
		#expect(AnyCodableValue(double) == .double(12_345.6789))

		let float: Float = 12_345.6789
		#expect(AnyCodableValue(float) == .float(12_345.6789))

		let integer: Int = -12_345
		#expect(AnyCodableValue(integer) == .integer(-12_345))

		let integer8: Int8 = -123
		#expect(AnyCodableValue(integer8) == .integer8(-123))

		let integer16: Int16 = -12_345
		#expect(AnyCodableValue(integer16) == .integer16(-12_345))

		let integer32: Int32 = -12_345
		#expect(AnyCodableValue(integer32) == .integer32(-12_345))

		let integer64: Int64 = -12_345
		#expect(AnyCodableValue(integer64) == .integer64(-12_345))

		let unsignedInteger: UInt = 12_345
		#expect(AnyCodableValue(unsignedInteger) == .unsignedInteger(12_345))

		let unsignedInteger8: UInt8 = 123
		#expect(AnyCodableValue(unsignedInteger8) == .unsignedInteger8(123))

		let unsignedInteger16: UInt16 = 12_345
		#expect(AnyCodableValue(unsignedInteger16) == .unsignedInteger16(12_345))

		let unsignedInteger32: UInt32 = 12_345
		#expect(AnyCodableValue(unsignedInteger32) == .unsignedInteger32(12_345))

		let unsignedInteger64: UInt64 = 12_345
		#expect(AnyCodableValue(unsignedInteger64) == .unsignedInteger64(12_345))

		let data: Data = Data([00, 11, 22, 33, 44, 55])
		#expect(AnyCodableValue(data) == .data(Data([00, 11, 22, 33, 44, 55])))

		let dictionary: [AnyCodableKey: AnyCodableValue] = [12_345: .string("example")]
		#expect(AnyCodableValue(dictionary) == .dictionary([12_345: .string("example")]))

		let array: [AnyCodableValue] = [.string("example")]
		#expect(AnyCodableValue(array) == .array([.string("example")]))

		let void: Void = ()
		#expect(AnyCodableValue(void) == nil)
	}

	@Test
	private func decode() throws {
		let structure = CodableStructure(
			date: .distantFuture,
			bool: true,
			string: "example",
			double: 12_345.6789,
			float: 12_345.6789,
			integer: .min,
			integer8: .min,
			integer16: .min,
			integer32: .min,
			integer64: .min,
			unsignedInteger: .max,
			unsignedInteger8: .max,
			unsignedInteger16: .max,
			unsignedInteger32: .max,
			unsignedInteger64: .max,
			data: Data([00, 11, 22, 33, 44, 55]),
			dictionary: [12_345: "example"],
			array: ["example"]
		)

		let data = try PropertyListEncoder().encode(structure)
		let decoded = try PropertyListDecoder().decode(AnyCodableValue.self, from: data)
		let dictionary = try #require(decoded.dictionaryValue)

		#expect(dictionary["date"] == .date(.distantFuture))
		#expect(dictionary["bool"] == .bool(true))
		#expect(dictionary["string"] == .string("example"))
		#expect(dictionary["double"] == .double(12_345.6789))
		#expect(dictionary["float"] == .float(12_345.6789))
		#expect(dictionary["integer"] == .integer64(.min))
		#expect(dictionary["integer8"] == .integer8(.min))
		#expect(dictionary["integer16"] == .integer16(.min))
		#expect(dictionary["integer32"] == .integer32(.min))
		#expect(dictionary["integer64"] == .integer64(.min))
		#expect(dictionary["unsignedInteger"] == .unsignedInteger64(.max))
		#expect(dictionary["unsignedInteger8"] == .unsignedInteger8(.max))
		#expect(dictionary["unsignedInteger16"] == .unsignedInteger16(.max))
		#expect(dictionary["unsignedInteger32"] == .unsignedInteger32(.max))
		#expect(dictionary["unsignedInteger64"] == .unsignedInteger64(.max))
		#expect(dictionary["data"] == .data(Data([00, 11, 22, 33, 44, 55])))

		let childDictionary = try #require(dictionary["dictionary"]?.dictionaryValue)
		#expect(childDictionary.count == 1)
		#expect(childDictionary["12345"] == .string("example"))

		let childArray = try #require(dictionary["array"]?.arrayValue)
		#expect(childArray.count == 1)
		#expect(childArray[0] == .string("example"))
	}

	@Test
	private func encode() throws {
		let structure = AnyCodableValue.dictionary([
			"date": .date(.distantFuture),
			"bool": .bool(true),
			"string": .string("example"),
			"double": .double(12_345.6789),
			"float": .float(12_345.6789),
			"integer": .integer(.min),
			"integer8": .integer8(.min),
			"integer16": .integer16(.min),
			"integer32": .integer32(.min),
			"integer64": .integer64(.min),
			"unsignedInteger": .unsignedInteger(.max),
			"unsignedInteger8": .unsignedInteger8(.max),
			"unsignedInteger16": .unsignedInteger16(.max),
			"unsignedInteger32": .unsignedInteger32(.max),
			"unsignedInteger64": .unsignedInteger64(.max),
			"data": .data(Data([00, 11, 22, 33, 44, 55])),
			"dictionary": .dictionary(["12345": .string("example")]),
			"array": .array([.string("example")]),
		])

		let data = try PropertyListEncoder().encode(structure)
		let decoded = try PropertyListDecoder().decode(CodableStructure.self, from: data)

		#expect(decoded.date == .distantFuture)
		#expect(decoded.bool == true)
		#expect(decoded.string == "example")
		#expect(decoded.double == 12_345.6789)
		#expect(decoded.float == 12_345.6789)
		#expect(decoded.integer == .min)
		#expect(decoded.integer8 == .min)
		#expect(decoded.integer16 == .min)
		#expect(decoded.integer32 == .min)
		#expect(decoded.integer64 == .min)
		#expect(decoded.unsignedInteger == .max)
		#expect(decoded.unsignedInteger8 == .max)
		#expect(decoded.unsignedInteger16 == .max)
		#expect(decoded.unsignedInteger32 == .max)
		#expect(decoded.unsignedInteger64 == .max)
		#expect(decoded.data == Data([00, 11, 22, 33, 44, 55]))
		#expect(decoded.dictionary.count == 1)
		#expect(decoded.dictionary[12_345] == "example")
		#expect(decoded.array.count == 1)
		#expect(decoded.array[0] == "example")
	}

	@Test
	private func encodeDecodeDate() throws {
		let timeIntervalSinceReferenceDate: UInt32 = 758_188_838 // 2025-01-10 08:00:38 +0000
		let date = Date(timeIntervalSinceReferenceDate: TimeInterval(timeIntervalSinceReferenceDate))

		// JSON

		let jsonData = try JSONEncoder().encode(["date": AnyCodableValue.date(date)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["date"] == .unsignedInteger32(timeIntervalSinceReferenceDate))

		// Property List

		let plistData = try PropertyListEncoder().encode(["date": AnyCodableValue.date(date)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["date"] == .date(date))
	}

	@Test
	private func encodeDecodeBool() throws {
		let bool = true

		// JSON

		let jsonData = try JSONEncoder().encode(["bool": AnyCodableValue.bool(bool)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["bool"] == .bool(bool))

		// Property List

		let plistData = try PropertyListEncoder().encode(["bool": AnyCodableValue.bool(bool)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["bool"] == .bool(bool))
	}

	@Test
	private func encodeDecodeString() throws {
		let string = "G'day! I'm Jelly, a.k.a. Daniel Farrelly, and you're listening to Independence."

		// JSON

		let jsonData = try JSONEncoder().encode(["string": AnyCodableValue.string(string)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["string"] == .string(string))

		// Property List

		let plistData = try PropertyListEncoder().encode(["string": AnyCodableValue.string(string)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["string"] == .string(string))
	}

	@Test
	private func encodeDecodeDouble() throws {
		let double: Double = 123.456

		// JSON

		let jsonData = try JSONEncoder().encode(["double": AnyCodableValue.double(double)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
 		// This is normal, as AnyCodableValue tries decoding float first
		#expect(jsonDecoded["double"] == .float(Float(double)))

		// Property List

		let plistData = try PropertyListEncoder().encode(["double": AnyCodableValue.double(double)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["double"] == .double(double)) // This is normal, as AnyCodableValue tries decoding float first
	}

	@Test
	private func encodeDecodeFloat() throws {
		let float: Float = 123.456

		// JSON

		let jsonData = try JSONEncoder().encode(["float": AnyCodableValue.float(float)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["float"] == .float(Float(float)))

		// Property List

		let plistData = try PropertyListEncoder().encode(["float": AnyCodableValue.float(float)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["float"] == .float(Float(float)))
	}

	@Test
	private func encodeDecodeInteger() throws {
		let negative = Int.min
		let positive = Int.max

		// JSON

		var jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer(negative)])
		var jsonDecoded = try JSONDecoder()
			.decode([String: AnyCodableValue].self, from: jsonData)
 		// This is normal, as AnyCodableValue prefers decoding specific-size integers
		#expect(jsonDecoded["integer"] == .integer64(Int64(negative)))

		jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer(positive)])
		jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
 		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(jsonDecoded["integer"] == .unsignedInteger64(UInt64(positive)))

		// Property List

		var plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer(negative)])
		var plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
 		// This is normal, as AnyCodableValue prefers decoding specific-size integers
		#expect(plistDecoded["integer"] == .integer64(Int64(negative)))

		plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer(positive)])
		plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
 		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(plistDecoded["integer"] == .unsignedInteger64(UInt64(positive)))
	}

	@Test
	private func encodeDecodeInteger8() throws {
		let negative = Int8.min
		let positive = Int8.max

		// JSON

		var jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer8(negative)])
		var jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["integer"] == .integer8(negative))

		jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer8(positive)])
		jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(jsonDecoded["integer"] == .unsignedInteger8(UInt8(positive)))

		// Property List

		var plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer8(negative)])
		var plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["integer"] == .integer8(negative))

		plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer8(positive)])
		plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(plistDecoded["integer"] == .unsignedInteger8(UInt8(positive)))
	}

	@Test
	private func encodeDecodeInteger16() throws {
		let negative = Int16.min
		let positive = Int16.max

		// JSON

		var jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer16(negative)])
		var jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["integer"] == .integer16(negative))

		jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer16(positive)])
		jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(jsonDecoded["integer"] == .unsignedInteger16(UInt16(positive)))

		// Property List

		var plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer16(negative)])
		var plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["integer"] == .integer16(negative))

		plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer16(positive)])
		plistDecoded = try PropertyListDecoder()
			.decode([String: AnyCodableValue].self, from: plistData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(plistDecoded["integer"] == .unsignedInteger16(UInt16(positive)))
	}

	@Test
	private func encodeDecodeInteger32() throws {
		let negative = Int32.min
		let positive = Int32.max

		// JSON

		var jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer32(negative)])
		var jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["integer"] == .integer32(negative))

		jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer32(positive)])
		jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(jsonDecoded["integer"] == .unsignedInteger32(UInt32(positive)))

		// Property List

		var plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer32(negative)])
		var plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["integer"] == .integer32(negative))

		plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer32(positive)])
		plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(plistDecoded["integer"] == .unsignedInteger32(UInt32(positive)))
	}

	@Test
	private func encodeDecodeInteger64() throws {
		let negative = Int64.min
		let positive = Int64.max

		// JSON

		var jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer64(negative)])
		var jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["integer"] == .integer64(negative))

		jsonData = try JSONEncoder().encode(["integer": AnyCodableValue.integer64(positive)])
		jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(jsonDecoded["integer"] == .unsignedInteger64(UInt64(positive)))

		// Property List

		var plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer64(negative)])
		var plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["integer"] == .integer64(negative))

		plistData = try PropertyListEncoder().encode(["integer": AnyCodableValue.integer64(positive)])
		plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		// This is normal, as AnyCodableValue prefers decoding unsigned integers
		#expect(plistDecoded["integer"] == .unsignedInteger64(UInt64(positive)))
	}

	@Test
	private func encodeDecodeUnsignedInteger() throws {
		let unsignedInteger: UInt = .max

		// JSON

		let jsonData = try JSONEncoder().encode(["unsignedInteger": AnyCodableValue.unsignedInteger(unsignedInteger)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		// This is normal, as AnyCodableValue prefers decoding specific-size integers
		#expect(jsonDecoded["unsignedInteger"] == .unsignedInteger64(UInt64(unsignedInteger)))

		// Property List

		let plistData = try PropertyListEncoder()
			.encode(["unsignedInteger": AnyCodableValue.unsignedInteger(unsignedInteger)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		// This is normal, as AnyCodableValue prefers decoding specific-size integers
		#expect(plistDecoded["unsignedInteger"] == .unsignedInteger64(UInt64(unsignedInteger)))
	}

	@Test
	private func encodeDecodeUnsignedInteger8() throws {
		let unsignedInteger8: UInt8 = .max

		// JSON

		let jsonData = try JSONEncoder().encode(["unsignedInteger8": AnyCodableValue.unsignedInteger8(unsignedInteger8)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["unsignedInteger8"] == .unsignedInteger8(unsignedInteger8))

		// Property List

		let plistData = try PropertyListEncoder()
			.encode(["unsignedInteger8": AnyCodableValue.unsignedInteger8(unsignedInteger8)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["unsignedInteger8"] == .unsignedInteger8(unsignedInteger8))
	}

	@Test
	private func encodeDecodeUnsignedInteger16() throws {
		let unsignedInteger16: UInt16 = .max

		// JSON

		let jsonData = try JSONEncoder().encode(["unsignedInteger16": AnyCodableValue.unsignedInteger16(unsignedInteger16)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["unsignedInteger16"] == .unsignedInteger16(unsignedInteger16))

		// Property List

		let plistData = try PropertyListEncoder()
			.encode(["unsignedInteger16": AnyCodableValue.unsignedInteger16(unsignedInteger16)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["unsignedInteger16"] == .unsignedInteger16(unsignedInteger16))
	}

	@Test
	private func encodeDecodeUnsignedInteger32() throws {
		let unsignedInteger32: UInt32 = .max

		// JSON

		let jsonData = try JSONEncoder().encode(["unsignedInteger32": AnyCodableValue.unsignedInteger32(unsignedInteger32)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["unsignedInteger32"] == .unsignedInteger32(unsignedInteger32))

		// Property List

		let plistData = try PropertyListEncoder()
			.encode(["unsignedInteger32": AnyCodableValue.unsignedInteger32(unsignedInteger32)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["unsignedInteger32"] == .unsignedInteger32(unsignedInteger32))
	}

	@Test
	private func encodeDecodeUnsignedInteger64() throws {
		let unsignedInteger64: UInt64 = .max

		// JSON

		let jsonData = try JSONEncoder().encode(["unsignedInteger64": AnyCodableValue.unsignedInteger64(unsignedInteger64)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["unsignedInteger64"] == .unsignedInteger64(unsignedInteger64))

		// Property List

		let plistData = try PropertyListEncoder()
			.encode(["unsignedInteger64": AnyCodableValue.unsignedInteger64(unsignedInteger64)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["unsignedInteger64"] == .unsignedInteger64(unsignedInteger64))
	}

	@Test
	private func encodeDecodeData() throws {
		let data = Data([0x6A, 0x65, 0x6C, 0x6C, 0x79, 0x62, 0x65, 0x61, 0x6E, 0x73, 0x6F, 0x75, 0x70])

		// JSON

		let jsonData = try JSONEncoder().encode(["data": AnyCodableValue.data(data)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["data"] == .string(data.base64EncodedString()))

		// Property List

		let plistData = try PropertyListEncoder().encode(["data": AnyCodableValue.data(data)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["data"] == .data(data))
	}

	@Test
	private func encodeDecodeDictionary() throws {
		let dictionary: [AnyCodableKey: AnyCodableValue] = ["key": .string("value")]

		// JSON

		let jsonData = try JSONEncoder().encode(["dictionary": AnyCodableValue.dictionary(dictionary)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["dictionary"] == .dictionary(dictionary))

		// Property List

		let plistData = try PropertyListEncoder().encode(["dictionary": AnyCodableValue.dictionary(dictionary)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["dictionary"] == .dictionary(dictionary))
	}

	@Test
	private func encodeDecodeArray() throws {
		let array: [AnyCodableValue] = [.unsignedInteger8(1), .string("two"), .float(0.3)]

		// JSON

		let jsonData = try JSONEncoder().encode(["array": AnyCodableValue.array(array)])
		let jsonDecoded = try JSONDecoder().decode([String: AnyCodableValue].self, from: jsonData)
		#expect(jsonDecoded["array"] == .array(array))

		// Property List

		let plistData = try PropertyListEncoder().encode(["array": AnyCodableValue.array(array)])
		let plistDecoded = try PropertyListDecoder().decode([String: AnyCodableValue].self, from: plistData)
		#expect(plistDecoded["array"] == .array(array))
	}

	@Test
	private func value() {
		#expect(AnyCodableValue.date(.distantFuture).value as? Date == .distantFuture)
		#expect(AnyCodableValue.bool(true).value as? Bool == true)
		#expect(AnyCodableValue.string("example").value as? String == "example")
		#expect(AnyCodableValue.double(12_345.6789).value as? Double == 12_345.6789)
		#expect(AnyCodableValue.float(12_345.6789).value as? Float == 12_345.6789)
		#expect(AnyCodableValue.integer(-12_345).value as? Int == -12_345)
		#expect(AnyCodableValue.integer8(-123).value as? Int8 == -123)
		#expect(AnyCodableValue.integer16(-12_345).value as? Int16 == -12_345)
		#expect(AnyCodableValue.integer32(-12_345).value as? Int32 == -12_345)
		#expect(AnyCodableValue.integer64(-12_345).value as? Int64 == -12_345)
		#expect(AnyCodableValue.unsignedInteger(12_345).value as? UInt == 12_345)
		#expect(AnyCodableValue.unsignedInteger8(123).value as? UInt8 == 123)
		#expect(AnyCodableValue.unsignedInteger16(12_345).value as? UInt16 == 12_345)
		#expect(AnyCodableValue.unsignedInteger32(12_345).value as? UInt32 == 12_345)
		#expect(AnyCodableValue.unsignedInteger64(12_345).value as? UInt64 == 12_345)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).value as? Data == Data([00, 11, 22, 33, 44, 55]))
		#expect(
			AnyCodableValue.dictionary(
				[12_345: .string("example")]
			).value as? [AnyCodableKey: AnyCodableValue] == [12_345: .string("example")]
		)
		#expect(AnyCodableValue.array([.string("example")]).value as? [AnyCodableValue] == [.string("example")])
	}

	@Test
	private func dateValue() {
		#expect(AnyCodableValue.date(.distantFuture).dateValue == .distantFuture)
		#expect(AnyCodableValue.bool(true).dateValue == nil)
		#expect(AnyCodableValue.string("example").dateValue == nil)
		#expect(AnyCodableValue.double(12_345.6789).dateValue == nil)
		#expect(AnyCodableValue.float(12_345.6789).dateValue == nil)
		#expect(AnyCodableValue.integer(-12_345).dateValue == nil)
		#expect(AnyCodableValue.integer8(-123).dateValue == nil)
		#expect(AnyCodableValue.integer16(-12_345).dateValue == nil)
		#expect(AnyCodableValue.integer32(-12_345).dateValue == nil)
		#expect(AnyCodableValue.integer64(-12_345).dateValue == nil)
		#expect(AnyCodableValue.unsignedInteger(12_345).dateValue == nil)
		#expect(AnyCodableValue.unsignedInteger8(123).dateValue == nil)
		#expect(AnyCodableValue.unsignedInteger16(12_345).dateValue == nil)
		#expect(AnyCodableValue.unsignedInteger32(12_345).dateValue == nil)
		#expect(AnyCodableValue.unsignedInteger64(12_345).dateValue == nil)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).dateValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).dateValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).dateValue == nil)
	}

	@Test
	private func boolValue() {
		#expect(AnyCodableValue.date(.distantFuture).boolValue == nil)
		#expect(AnyCodableValue.bool(true).boolValue == true)
		#expect(AnyCodableValue.string("example").boolValue == nil)
		#expect(AnyCodableValue.double(12_345.6789).boolValue == nil)
		#expect(AnyCodableValue.float(12_345.6789).boolValue == nil)
		#expect(AnyCodableValue.integer(-12_345).boolValue == nil)
		#expect(AnyCodableValue.integer8(-123).boolValue == nil)
		#expect(AnyCodableValue.integer16(-12_345).boolValue == nil)
		#expect(AnyCodableValue.integer32(-12_345).boolValue == nil)
		#expect(AnyCodableValue.integer64(-12_345).boolValue == nil)
		#expect(AnyCodableValue.unsignedInteger(12_345).boolValue == nil)
		#expect(AnyCodableValue.unsignedInteger8(123).boolValue == nil)
		#expect(AnyCodableValue.unsignedInteger16(12_345).boolValue == nil)
		#expect(AnyCodableValue.unsignedInteger32(12_345).boolValue == nil)
		#expect(AnyCodableValue.unsignedInteger64(12_345).boolValue == nil)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).boolValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).boolValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).boolValue == nil)
	}

	@Test
	private func stringValue() {
		#expect(AnyCodableValue.date(.distantFuture).stringValue == nil)
		#expect(AnyCodableValue.bool(true).stringValue == nil)
		#expect(AnyCodableValue.string("example").stringValue == "example")
		#expect(AnyCodableValue.double(12_345.6789).stringValue == nil)
		#expect(AnyCodableValue.float(12_345.6789).stringValue == nil)
		#expect(AnyCodableValue.integer(-12_345).stringValue == nil)
		#expect(AnyCodableValue.integer8(-123).stringValue == nil)
		#expect(AnyCodableValue.integer16(-12_345).stringValue == nil)
		#expect(AnyCodableValue.integer32(-12_345).stringValue == nil)
		#expect(AnyCodableValue.integer64(-12_345).stringValue == nil)
		#expect(AnyCodableValue.unsignedInteger(12_345).stringValue == nil)
		#expect(AnyCodableValue.unsignedInteger8(123).stringValue == nil)
		#expect(AnyCodableValue.unsignedInteger16(12_345).stringValue == nil)
		#expect(AnyCodableValue.unsignedInteger32(12_345).stringValue == nil)
		#expect(AnyCodableValue.unsignedInteger64(12_345).stringValue == nil)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).stringValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).stringValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).stringValue == nil)
	}

	@Test
	private func doubleValue() {
		#expect(AnyCodableValue.date(.distantFuture).doubleValue == nil)
		#expect(AnyCodableValue.bool(true).doubleValue == nil)
		#expect(AnyCodableValue.string("example").doubleValue == nil)
		#expect(AnyCodableValue.double(123).doubleValue == 123)
		#expect(AnyCodableValue.float(123).doubleValue == 123)
		#expect(AnyCodableValue.integer(123).doubleValue == 123)
		#expect(AnyCodableValue.integer8(123).doubleValue == 123)
		#expect(AnyCodableValue.integer16(123).doubleValue == 123)
		#expect(AnyCodableValue.integer32(123).doubleValue == 123)
		#expect(AnyCodableValue.integer64(123).doubleValue == 123)
		#expect(AnyCodableValue.unsignedInteger(123).doubleValue == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).doubleValue == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).doubleValue == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).doubleValue == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).doubleValue == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).doubleValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).doubleValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).doubleValue == nil)
	}

	@Test
	private func floatValue() {
		#expect(AnyCodableValue.date(.distantFuture).floatValue == nil)
		#expect(AnyCodableValue.bool(true).floatValue == nil)
		#expect(AnyCodableValue.string("example").floatValue == nil)
		#expect(AnyCodableValue.double(123).floatValue == 123)
		#expect(AnyCodableValue.float(123).floatValue == 123)
		#expect(AnyCodableValue.integer(123).floatValue == 123)
		#expect(AnyCodableValue.integer8(123).floatValue == 123)
		#expect(AnyCodableValue.integer16(123).floatValue == 123)
		#expect(AnyCodableValue.integer32(123).floatValue == 123)
		#expect(AnyCodableValue.integer64(123).floatValue == 123)
		#expect(AnyCodableValue.unsignedInteger(123).floatValue == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).floatValue == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).floatValue == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).floatValue == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).floatValue == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).floatValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).floatValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).floatValue == nil)
	}

	@Test
	private func integerValue() {
		#expect(AnyCodableValue.date(.distantFuture).integerValue == nil)
		#expect(AnyCodableValue.bool(true).integerValue == nil)
		#expect(AnyCodableValue.string("example").integerValue == nil)
		#expect(AnyCodableValue.double(123).integerValue == 123)
		#expect(AnyCodableValue.float(123).integerValue == 123)
		#expect(AnyCodableValue.integer(123).integerValue == 123)
		#expect(AnyCodableValue.integer8(123).integerValue == 123)
		#expect(AnyCodableValue.integer16(123).integerValue == 123)
		#expect(AnyCodableValue.integer32(123).integerValue == 123)
		#expect(AnyCodableValue.integer64(123).integerValue == 123)
		#expect(AnyCodableValue.unsignedInteger(123).integerValue == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).integerValue == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).integerValue == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).integerValue == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).integerValue == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).integerValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).integerValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).integerValue == nil)
	}

	@Test
	private func integer8Value() {
		#expect(AnyCodableValue.date(.distantFuture).integer8Value == nil)
		#expect(AnyCodableValue.bool(true).integer8Value == nil)
		#expect(AnyCodableValue.string("example").integer8Value == nil)
		#expect(AnyCodableValue.double(123).integer8Value == 123)
		#expect(AnyCodableValue.float(123).integer8Value == 123)
		#expect(AnyCodableValue.integer(123).integer8Value == 123)
		#expect(AnyCodableValue.integer8(123).integer8Value == 123)
		#expect(AnyCodableValue.integer16(123).integer8Value == 123)
		#expect(AnyCodableValue.integer32(123).integer8Value == 123)
		#expect(AnyCodableValue.integer64(123).integer8Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).integer8Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).integer8Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).integer8Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).integer8Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).integer8Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).integer8Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).integer8Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).integer8Value == nil)
	}

	@Test
	private func integer16Value() {
		#expect(AnyCodableValue.date(.distantFuture).integer16Value == nil)
		#expect(AnyCodableValue.bool(true).integer16Value == nil)
		#expect(AnyCodableValue.string("example").integer16Value == nil)
		#expect(AnyCodableValue.double(123).integer16Value == 123)
		#expect(AnyCodableValue.float(123).integer16Value == 123)
		#expect(AnyCodableValue.integer(123).integer16Value == 123)
		#expect(AnyCodableValue.integer8(123).integer16Value == 123)
		#expect(AnyCodableValue.integer16(123).integer16Value == 123)
		#expect(AnyCodableValue.integer32(123).integer16Value == 123)
		#expect(AnyCodableValue.integer64(123).integer16Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).integer16Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).integer16Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).integer16Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).integer16Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).integer16Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).integer16Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).integer16Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).integer16Value == nil)
	}

	@Test
	private func integer32Value() {
		#expect(AnyCodableValue.date(.distantFuture).integer32Value == nil)
		#expect(AnyCodableValue.bool(true).integer32Value == nil)
		#expect(AnyCodableValue.string("example").integer32Value == nil)
		#expect(AnyCodableValue.double(123).integer32Value == 123)
		#expect(AnyCodableValue.float(123).integer32Value == 123)
		#expect(AnyCodableValue.integer(123).integer32Value == 123)
		#expect(AnyCodableValue.integer8(123).integer32Value == 123)
		#expect(AnyCodableValue.integer16(123).integer32Value == 123)
		#expect(AnyCodableValue.integer32(123).integer32Value == 123)
		#expect(AnyCodableValue.integer64(123).integer32Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).integer32Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).integer32Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).integer32Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).integer32Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).integer32Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).integer32Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).integer32Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).integer32Value == nil)
	}

	@Test
	private func integer64Value() {
		#expect(AnyCodableValue.date(.distantFuture).integer64Value == nil)
		#expect(AnyCodableValue.bool(true).integer64Value == nil)
		#expect(AnyCodableValue.string("example").integer64Value == nil)
		#expect(AnyCodableValue.double(123).integer64Value == 123)
		#expect(AnyCodableValue.float(123).integer64Value == 123)
		#expect(AnyCodableValue.integer(123).integer64Value == 123)
		#expect(AnyCodableValue.integer8(123).integer64Value == 123)
		#expect(AnyCodableValue.integer16(123).integer64Value == 123)
		#expect(AnyCodableValue.integer32(123).integer64Value == 123)
		#expect(AnyCodableValue.integer64(123).integer64Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).integer64Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).integer64Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).integer64Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).integer64Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).integer64Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).integer64Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).integer64Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).integer64Value == nil)
	}

	@Test
	private func unsignedIntegerValue() {
		#expect(AnyCodableValue.date(.distantFuture).unsignedIntegerValue == nil)
		#expect(AnyCodableValue.bool(true).unsignedIntegerValue == nil)
		#expect(AnyCodableValue.string("example").unsignedIntegerValue == nil)
		#expect(AnyCodableValue.double(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.float(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.integer(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.integer8(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.integer16(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.integer32(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.integer64(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.unsignedInteger(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).unsignedIntegerValue == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).unsignedIntegerValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).unsignedIntegerValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).unsignedIntegerValue == nil)
	}

	@Test
	private func unsignedInteger8Value() {
		#expect(AnyCodableValue.date(.distantFuture).unsignedInteger8Value == nil)
		#expect(AnyCodableValue.bool(true).unsignedInteger8Value == nil)
		#expect(AnyCodableValue.string("example").unsignedInteger8Value == nil)
		#expect(AnyCodableValue.double(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.float(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.integer(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.integer8(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.integer16(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.integer32(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.integer64(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).unsignedInteger8Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).unsignedInteger8Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).unsignedInteger8Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).unsignedInteger8Value == nil)
	}

	@Test
	private func unsignedInteger16Value() {
		#expect(AnyCodableValue.date(.distantFuture).unsignedInteger16Value == nil)
		#expect(AnyCodableValue.bool(true).unsignedInteger16Value == nil)
		#expect(AnyCodableValue.string("example").unsignedInteger16Value == nil)
		#expect(AnyCodableValue.double(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.float(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.integer(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.integer8(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.integer16(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.integer32(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.integer64(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).unsignedInteger16Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).unsignedInteger16Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).unsignedInteger16Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).unsignedInteger16Value == nil)
	}

	@Test
	private func unsignedInteger32Value() {
		#expect(AnyCodableValue.date(.distantFuture).unsignedInteger32Value == nil)
		#expect(AnyCodableValue.bool(true).unsignedInteger32Value == nil)
		#expect(AnyCodableValue.string("example").unsignedInteger32Value == nil)
		#expect(AnyCodableValue.double(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.float(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.integer(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.integer8(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.integer16(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.integer32(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.integer64(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).unsignedInteger32Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).unsignedInteger32Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).unsignedInteger32Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).unsignedInteger32Value == nil)
	}

	@Test
	private func unsignedInteger64Value() {
		#expect(AnyCodableValue.date(.distantFuture).unsignedInteger64Value == nil)
		#expect(AnyCodableValue.bool(true).unsignedInteger64Value == nil)
		#expect(AnyCodableValue.string("example").unsignedInteger64Value == nil)
		#expect(AnyCodableValue.double(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.float(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.integer(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.integer8(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.integer16(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.integer32(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.integer64(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.unsignedInteger(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.unsignedInteger8(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.unsignedInteger16(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.unsignedInteger32(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.unsignedInteger64(123).unsignedInteger64Value == 123)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).unsignedInteger64Value == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).unsignedInteger64Value == nil)
		#expect(AnyCodableValue.array([.string("example")]).unsignedInteger64Value == nil)
	}

	@Test
	private func dataValue() {
		#expect(AnyCodableValue.date(.distantFuture).dataValue == nil)
		#expect(AnyCodableValue.bool(true).dataValue == nil)
		#expect(AnyCodableValue.string("example").dataValue == nil)
		#expect(AnyCodableValue.double(12_345.6789).dataValue == nil)
		#expect(AnyCodableValue.float(12_345.6789).dataValue == nil)
		#expect(AnyCodableValue.integer(-12_345).dataValue == nil)
		#expect(AnyCodableValue.integer8(-123).dataValue == nil)
		#expect(AnyCodableValue.integer16(-12_345).dataValue == nil)
		#expect(AnyCodableValue.integer32(-12_345).dataValue == nil)
		#expect(AnyCodableValue.integer64(-12_345).dataValue == nil)
		#expect(AnyCodableValue.unsignedInteger(12_345).dataValue == nil)
		#expect(AnyCodableValue.unsignedInteger8(123).dataValue == nil)
		#expect(AnyCodableValue.unsignedInteger16(12_345).dataValue == nil)
		#expect(AnyCodableValue.unsignedInteger32(12_345).dataValue == nil)
		#expect(AnyCodableValue.unsignedInteger64(12_345).dataValue == nil)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).dataValue == Data([00, 11, 22, 33, 44, 55]))
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).dataValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).dataValue == nil)
	}

	@Test
	private func dictionaryValue() {
		#expect(AnyCodableValue.date(.distantFuture).dictionaryValue == nil)
		#expect(AnyCodableValue.bool(true).dictionaryValue == nil)
		#expect(AnyCodableValue.string("example").dictionaryValue == nil)
		#expect(AnyCodableValue.double(12_345.6789).dictionaryValue == nil)
		#expect(AnyCodableValue.float(12_345.6789).dictionaryValue == nil)
		#expect(AnyCodableValue.integer(-12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.integer8(-123).dictionaryValue == nil)
		#expect(AnyCodableValue.integer16(-12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.integer32(-12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.integer64(-12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.unsignedInteger(12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.unsignedInteger8(123).dictionaryValue == nil)
		#expect(AnyCodableValue.unsignedInteger16(12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.unsignedInteger32(12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.unsignedInteger64(12_345).dictionaryValue == nil)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).dictionaryValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).dictionaryValue == [12_345: .string("example")])
		#expect(AnyCodableValue.array([.string("example")]).dictionaryValue == nil)
	}

	@Test
	private func arrayValue() {
		#expect(AnyCodableValue.date(.distantFuture).arrayValue == nil)
		#expect(AnyCodableValue.bool(true).arrayValue == nil)
		#expect(AnyCodableValue.string("example").arrayValue == nil)
		#expect(AnyCodableValue.double(12_345.6789).arrayValue == nil)
		#expect(AnyCodableValue.float(12_345.6789).arrayValue == nil)
		#expect(AnyCodableValue.integer(-12_345).arrayValue == nil)
		#expect(AnyCodableValue.integer8(-123).arrayValue == nil)
		#expect(AnyCodableValue.integer16(-12_345).arrayValue == nil)
		#expect(AnyCodableValue.integer32(-12_345).arrayValue == nil)
		#expect(AnyCodableValue.integer64(-12_345).arrayValue == nil)
		#expect(AnyCodableValue.unsignedInteger(12_345).arrayValue == nil)
		#expect(AnyCodableValue.unsignedInteger8(123).arrayValue == nil)
		#expect(AnyCodableValue.unsignedInteger16(12_345).arrayValue == nil)
		#expect(AnyCodableValue.unsignedInteger32(12_345).arrayValue == nil)
		#expect(AnyCodableValue.unsignedInteger64(12_345).arrayValue == nil)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).arrayValue == nil)
		#expect(AnyCodableValue.dictionary([12_345: .string("example")]).arrayValue == nil)
		#expect(AnyCodableValue.array([.string("example")]).arrayValue == [.string("example")])
	}

	@Test
	private func debugDescription() {
		#expect(AnyCodableValue.date(.distantFuture).debugDescription == #".date(4001-01-01 00:00:00 +0000)"#)
		#expect(AnyCodableValue.bool(true).debugDescription == #".bool(true)"#)
		#expect(AnyCodableValue.string("example").debugDescription == #".string(example)"#)
		#expect(AnyCodableValue.double(12_345.6789).debugDescription == #".double(12345.6789)"#)
		#expect(AnyCodableValue.float(12_345.6789).debugDescription == #".float(12345.679)"#)
		#expect(AnyCodableValue.integer(.min).debugDescription == #".integer(-9223372036854775808)"#)
		#expect(AnyCodableValue.integer8(.min).debugDescription == #".integer8(-128)"#)
		#expect(AnyCodableValue.integer16(.min).debugDescription == #".integer16(-32768)"#)
		#expect(AnyCodableValue.integer32(.min).debugDescription == #".integer32(-2147483648)"#)
		#expect(AnyCodableValue.integer64(.min).debugDescription == #".integer64(-9223372036854775808)"#)
		#expect(AnyCodableValue.unsignedInteger(.max).debugDescription == #".unsignedInteger(18446744073709551615)"#)
		#expect(AnyCodableValue.unsignedInteger8(.max).debugDescription == #".unsignedInteger8(255)"#)
		#expect(AnyCodableValue.unsignedInteger16(.max).debugDescription == #".unsignedInteger16(65535)"#)
		#expect(AnyCodableValue.unsignedInteger32(.max).debugDescription == #".unsignedInteger32(4294967295)"#)
		#expect(AnyCodableValue.unsignedInteger64(.max).debugDescription == #".unsignedInteger64(18446744073709551615)"#)
		#expect(AnyCodableValue.data(Data([00, 11, 22, 33, 44, 55])).debugDescription == #".data(6 bytes)"#)
		#expect(
			AnyCodableValue.dictionary(
				[12_345: .string("example")]
			).debugDescription == #".dictionary([12345: .string(example)])"#
		)
		#expect(AnyCodableValue.array([.string("example")]).debugDescription == #".array([.string(example)])"#)
	}
}
