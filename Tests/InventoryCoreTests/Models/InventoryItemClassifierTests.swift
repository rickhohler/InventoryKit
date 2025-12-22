import XCTest
import InventoryCore

final class InventoryItemClassifierTests: XCTestCase {
    
    func testClassificationCategories() {
        // Software/Data -> Digital
        XCTAssertEqual(InventoryItemClassifier.software.category, .digital)
        XCTAssertEqual(InventoryItemClassifier.firmware.category, .digital)
        XCTAssertEqual(InventoryItemClassifier.diskImage.category, .digital)
        XCTAssertEqual(InventoryItemClassifier.archive.category, .digital)
        XCTAssertEqual(InventoryItemClassifier.document.category, .digital)
        XCTAssertEqual(InventoryItemClassifier.multimedia.category, .digital)
        XCTAssertEqual(InventoryItemClassifier.graphic.category, .digital)
        
        // Hardware -> Physical
        XCTAssertEqual(InventoryItemClassifier.computerHardware.category, .physical)
        XCTAssertEqual(InventoryItemClassifier.peripheral.category, .physical)
        XCTAssertEqual(InventoryItemClassifier.physicalItem.category, .physical)
        XCTAssertEqual(InventoryItemClassifier.storageContainer.category, .physical)
        
        // Other -> Digital (Default)
        XCTAssertEqual(InventoryItemClassifier.other.category, .digital)
    }
    
    func testCodable() throws {
        let original = InventoryItemClassifier.software
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(InventoryItemClassifier.self, from: data)
        XCTAssertEqual(original, decoded)
    }
}
