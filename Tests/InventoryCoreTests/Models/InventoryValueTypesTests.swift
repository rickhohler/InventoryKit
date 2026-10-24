//
//  InventoryValueTypesTests.swift
//  InventoryCoreTests
//
//  Value types whose JSON must match what existing clients already store.
//

import XCTest
import InventoryTypes

final class InventoryValueTypesTests: XCTestCase {

    private func sortedJSON<T: Encodable>(_ value: T) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return String(decoding: try encoder.encode(value), as: UTF8.self)
    }

    private func roundTrip<T: Codable>(_ type: T.Type, _ json: String) throws -> String {
        try sortedJSON(try JSONDecoder().decode(T.self, from: Data(json.utf8)))
    }

    // MARK: - Stored shapes (fixtures use the key order found in real stores)

    func testRawIdentifierRoundTripsLegacyKinds() throws {
        let uuid = #"{"value":"9c1f0a4e-6b0e-4d0a-9a51-3b8f2a1c7d10","type":"uuid"}"#
        XCTAssertEqual(try roundTrip(RawIdentifier.self, uuid),
                       #"{"type":"uuid","value":"9c1f0a4e-6b0e-4d0a-9a51-3b8f2a1c7d10"}"#)
        let serial = try JSONDecoder().decode(RawIdentifier.self, from: Data(#"{"type":"serialNumber","value":"IA2S2-1"}"#.utf8))
        XCTAssertEqual(serial.identifierType, .serialNumber)
        XCTAssertEqual(RawIdentifier(type: "uuid", value: "x").identifierType, .uuid)
        XCTAssertEqual(RawIdentifier(.serialNumber, value: "x").type, "serial_number")
    }

    func testUnknownIdentifierKindSurvives() throws {
        let json = #"{"type":"isbn","value":"123"}"#
        XCTAssertEqual(try roundTrip(RawIdentifier.self, json), json)
        XCTAssertNil(try JSONDecoder().decode(RawIdentifier.self, from: Data(json.utf8)).identifierType)
    }

    func testIdentifierTypeDecodesUUID() throws {
        XCTAssertEqual(try JSONDecoder().decode(IdentifierType.self, from: Data(#""uuid""#.utf8)), .uuid)
        XCTAssertEqual(IdentifierType.upc.rawValue, "barcode")
    }

    func testComponentLinkShape() throws {
        let id = UUID(uuidString: "11111111-2222-3333-4444-555555555555")!
        XCTAssertEqual(try sortedJSON(ComponentLinkModel(assetID: id)),
                       #"{"assetID":"11111111-2222-3333-4444-555555555555","quantity":1}"#)
        let stored = #"{"note":"left drive","quantity":2,"assetID":"11111111-2222-3333-4444-555555555555"}"#
        XCTAssertEqual(try roundTrip(ComponentLinkModel.self, stored),
                       #"{"assetID":"11111111-2222-3333-4444-555555555555","note":"left drive","quantity":2}"#)
    }

    func testCopyrightRoundTrip() throws {
        let stored = #"{"metadata":{"source":"woz"},"year":1983,"text":"© 1983 Broderbund Software","holder":"Broderbund Software"}"#
        XCTAssertEqual(try roundTrip(CopyrightInfoModel.self, stored),
                       #"{"holder":"Broderbund Software","metadata":{"source":"woz"},"text":"© 1983 Broderbund Software","year":1983}"#)
    }

    // MARK: - Copyright extraction

    func testExtractCopyrightSign() {
        let c = CopyrightInfoModel.extract(from: "© 1983 Broderbund Software")
        XCTAssertEqual(c.text, "© 1983 Broderbund Software")
        XCTAssertEqual(c.year, 1983)
        XCTAssertEqual(c.holder, "Broderbund Software")
    }

    func testExtractByAndCopyrightForms() {
        let by = CopyrightInfoModel.extract(from: "Copyright (C) 1981 BY H. ALAN GRIESEMER & STEPHAN C. BRADSHAW")
        XCTAssertEqual(by.year, 1981)
        XCTAssertEqual(by.holder, "H. ALAN GRIESEMER & STEPHAN C. BRADSHAW")
        XCTAssertEqual(CopyrightInfoModel.extract(from: "Copyright 1983 Apple Computer").holder, "Apple Computer")
        XCTAssertEqual(CopyrightInfoModel.extract(from: "©1983 Broderbund Software").holder, "Broderbund Software")
        XCTAssertEqual(CopyrightInfoModel.extract(from: "© 1984 Sirius (Revised)").holder, "Sirius")
    }

    func testExtractFallsBackToTextAfterYear() {
        let c = CopyrightInfoModel.extract(from: "Game 1985 BY Brøderbund")
        XCTAssertEqual(c.year, 1985)
        XCTAssertEqual(c.holder, "Brøderbund")
        XCTAssertNil(CopyrightInfoModel.extract(from: "no year here").holder)
    }

    func testTagsForTwoHolders() {
        let tags = CopyrightInfoModel(text: "x", year: 1981, holder: "H. ALAN GRIESEMER & STEPHAN C. BRADSHAW").createTags()
        XCTAssertEqual(tags, ["copyright:extracted", "copyright:1981", "copyright:1980s", "copyright:griesemer", "copyright:bradshaw"])
    }

    func testTagsWithoutTextOrYear() {
        XCTAssertEqual(CopyrightInfoModel(holder: "The Learning Company").createTags(), ["copyright:company"])
        XCTAssertEqual(CopyrightInfoModel().createTags(), [])
    }
}
