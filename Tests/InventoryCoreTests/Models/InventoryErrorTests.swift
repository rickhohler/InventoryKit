import XCTest
import InventoryCore

final class InventoryErrorTests: XCTestCase {
    
    func testErrorDescriptions() {
        let url = URL(fileURLWithPath: "/tmp/test.yaml")
        let v1 = InventorySchemaVersion(major: 1, minor: 0, patch: 0)
        let v2 = InventorySchemaVersion(major: 2, minor: 0, patch: 0)
        
        XCTAssertEqual(InventoryError.unreadableFile(url).description, "Unable to read inventory YAML at /tmp/test.yaml.")
        XCTAssertEqual(InventoryError.unsupportedDataEncoding.description, "Inventory data must be UTF-8 encoded.")
        XCTAssertEqual(InventoryError.schemaIncompatible(expected: v1, actual: v2).description, "Schema 2.0.0 is not compatible with expected major version 1.")
        XCTAssertEqual(InventoryError.yamlDecodingFailed("Err").description, "Failed to decode inventory YAML: Err")
        XCTAssertEqual(InventoryError.yamlEncodingFailed("Err").description, "Failed to encode inventory YAML: Err")
        XCTAssertEqual(InventoryError.storageError("Err").description, "Storage error: Err")
        XCTAssertEqual(InventoryError.vendorOperationNotSupported("Err").description, "Vendor operation not supported: Err")
        XCTAssertEqual(InventoryError.notImplemented("Err").description, "Not implemented: Err")
    }
}
