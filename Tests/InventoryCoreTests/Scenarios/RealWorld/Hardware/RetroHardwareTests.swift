import XCTest
import InventoryCore
@testable import InventoryCoreTests

final class RetroHardwareTests: XCTestCase {
    
    var configurator: InventoryConfigurator!
    
    override func setUp() {
        super.setUp()
        configurator = MockInventoryConfigurator()
    }

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
        var ae = MockReferenceManufacturer(slug: "", name: "")
        
        configurator.configure(
            &ae,
            id: UUID(),
            name: "Applied Engineering",
            slug: "applied_engineering",
            description: "High-end Apple II hardware",
            metadata: [:],
            aliases: []
        )
        
        // 2. Setup Product
        var dataLink = MockReferenceProduct(title: "")
        
        configurator.configure(
            &dataLink,
            id: UUID(),
            title: "DataLink Modem",
            description: "Internal modem card",
            sku: "DL", // Mapping vendorProductId to SKU
            productType: "Hardware", // Broad type
            classification: "Expansion Card", // Specific
            genre: nil,
            releaseDate: Date(timeIntervalSince1970: 536457600), // ~1987
            platform: nil
        )
        dataLink.manufacturer = ae
        
        // 3. Verification
        XCTAssertEqual(dataLink.title, "DataLink Modem")
        XCTAssertEqual(dataLink.manufacturer?.name, "Applied Engineering")
        XCTAssertEqual(dataLink.sku, "DL")
        XCTAssertEqual(dataLink.classification, "Expansion Card")
        
        // 4. Test Variant/Version logic (simulated)
        // The JSON has "versions": [ { "name": "Original", ... } ]
        // We might model this as child ReferenceProducts or just separate records.
        // For this test, distinct record.
    }
}
