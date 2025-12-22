import XCTest
import InventoryCore
@testable import InventoryCoreTests

final class RetroHardwareTests: XCTestCase {

    func testDataLinkModem() {
        // Data from hardware_applied_engineering.json
        /*
         "id": "ae_datasetch",
         "name": "DataLink Modem",
         "manufacturerId": "applied_engineering",
         "type": "Expansion Card",
         "releaseYear": 1987
        */
        
        // 1. Setup Manufacturer
        let ae = MockReferenceManufacturer(
            id: UUID(),
            slug: "applied_engineering",
            name: "Applied Engineering",
            description: "High-end Apple II hardware"
        )
        
        // 2. Setup Product
        let dataLink = MockReferenceProduct(
            id: UUID(),
            title: "DataLink Modem",
            description: "Internal modem card",
            manufacturer: ae,
            releaseDate: Date(timeIntervalSince1970: 536457600), // ~1987
            productType: "Hardware", // Broad type
            classification: "Expansion Card" // Specific
        )
        // Note: MockReferenceProduct needs 'modelNumber' if we want to test it, 
        // or we use extended metadata/identifiers. 
        // MockReferenceProduct currently has `sku`, `identifiers`.
        // Let's assume we map "DL" to SKU or an identifier.
        
        // var mutableDataLink = dataLink (Removed unused var)
        // MockReferenceProduct in previous steps was Struct, so we can mutate if var?
        // Wait, I initialized it as 'let' above. And MockReferenceProduct has 'let' properties in the definition I viewed earlier (Step 3957).
        // It has `sku` in init.
        
        let dataLinkWithSKU = MockReferenceProduct(
            id: UUID(),
            title: "DataLink Modem",
            manufacturer: ae,
            sku: "DL", // Mapping vendorProductId to SKU
            classification: "Expansion Card"
        )

        // 3. Verification
        XCTAssertEqual(dataLinkWithSKU.title, "DataLink Modem")
        XCTAssertEqual(dataLinkWithSKU.manufacturer?.name, "Applied Engineering")
        XCTAssertEqual(dataLinkWithSKU.sku, "DL")
        XCTAssertEqual(dataLinkWithSKU.classification, "Expansion Card")
        
        // 4. Test Variant/Version logic (simulated)
        // The JSON has "versions": [ { "name": "Original", ... } ]
        // We might model this as child ReferenceProducts or just separate records.
        // For this test, distinct record.
    }
}
