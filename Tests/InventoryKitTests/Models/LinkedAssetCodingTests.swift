//
//  LinkedAssetCodingTests.swift
//  InventoryKitTests
//

import XCTest
import InventoryKit

final class LinkedAssetCodingTests: XCTestCase {
    func testDecodesStoredShapeAndIsMutableAndHashable() throws {
        let stored = #"{"typeID":"manual","assetID":"11111111-2222-3333-4444-555555555555","note":"box"}"#
        var linked = try JSONDecoder().decode(LinkedAsset.self, from: Data(stored.utf8))
        XCTAssertEqual(linked.typeID, "manual")
        XCTAssertEqual(linked.note, "box")
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        XCTAssertEqual(String(decoding: try encoder.encode(linked), as: UTF8.self),
                       #"{"assetID":"11111111-2222-3333-4444-555555555555","note":"box","typeID":"manual"}"#)
        linked.note = nil
        XCTAssertEqual(Set([linked, linked]).count, 1)
    }
}
