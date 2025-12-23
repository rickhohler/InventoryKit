import XCTest
import InventoryCore
import InventoryTypes

final class ItemClassifierTests: XCTestCase {
    
    func testClassificationCategories() {
        // Software/Data -> Digital
        XCTAssertEqual(ItemClassifierType.software.category, .digital)
        XCTAssertEqual(ItemClassifierType.firmware.category, .digital)
        XCTAssertEqual(ItemClassifierType.diskImage.category, .digital)
        XCTAssertEqual(ItemClassifierType.archive.category, .digital)
        XCTAssertEqual(ItemClassifierType.document.category, .digital)
        XCTAssertEqual(ItemClassifierType.multimedia.category, .digital)
        XCTAssertEqual(ItemClassifierType.graphic.category, .digital)
        
        // Hardware -> Physical
        XCTAssertEqual(ItemClassifierType.computerHardware.category, .physical)
        XCTAssertEqual(ItemClassifierType.peripheral.category, .physical)
        XCTAssertEqual(ItemClassifierType.physicalItem.category, .physical)
        XCTAssertEqual(ItemClassifierType.storageContainer.category, .physical)
        
        // Other -> Digital (Default)
        XCTAssertEqual(ItemClassifierType.other.category, .digital)
    }
    
    func testCodable() throws {
        let original = ItemClassifierType.software
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ItemClassifierType.self, from: data)
        XCTAssertEqual(original, decoded)
    }
}
