import XCTest
import InventoryCore
@testable import InventoryCoreTests

final class RetroSoftwareTests: XCTestCase {

    func testKaratekaModel() {
        // Data from RetroData/titles.json (Karateka)
        /*
         "id" : "karateka",
         "title" : "Karateka",
         "publisherId" : "broderbund",
         "releaseYear" : 1984,
         "uuid" : "F1ABD7C5-1613-4855-8798-D112EA7A679D",
         "platforms" : ["apple2", "c64", "dos", "nes", "atari8bit"]
        */
        
        // 1. Setup Manufacturer (Publisher)
        let broderbund = MockReferenceManufacturer(
            id: UUID(), // In real app, uuidv5 from "broderbund"
            slug: "broderbund",
            name: "Broderbund"
        )
        
        // 2. Setup Product
        let karateka = MockReferenceProduct(
            id: UUID(uuidString: "F1ABD7C5-1613-4855-8798-D112EA7A679D")!,
            title: "Karateka",
            description: "Karate (空手), also karate-do...",
            manufacturer: broderbund,
            releaseDate: Date(timeIntervalSince1970: 441763200), // ~1984
            dataSource: nil, // Mock doesn't strictly need this
            sku: nil,
            productType: "Software",
            classification: "Game",
            genre: "Fighting",
            publisher: "Broderbund",
            platforms: ["Apple II", "C64", "DOS", "NES", "Atari 8-bit"]
        )
        
        // 3. Verification
        XCTAssertEqual(karateka.title, "Karateka")
        XCTAssertEqual(karateka.manufacturer?.name, "Broderbund")
        XCTAssertEqual(karateka.platforms?.count, 5)
        XCTAssertTrue(karateka.platforms?.contains("Apple II") ?? false)
        XCTAssertEqual(karateka.id.uuidString, "F1ABD7C5-1613-4855-8798-D112EA7A679D")
        
        // 4. Verify Protocol Conformance
        // InventoryCompoundBase
        // 4. Verify Protocol Conformance
        // InventoryCompoundBase
        XCTAssertEqual(karateka.title, "Karateka")
        
        // MockReferenceProduct uses standard InventoryProduct/CompoundBase props
        // It does not explicitly duplicate 'name' unless added.
        // So we check title.
    }
}
