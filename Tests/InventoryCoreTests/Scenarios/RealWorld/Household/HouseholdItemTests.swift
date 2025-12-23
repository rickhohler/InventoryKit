import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit // Using Builder here

final class HouseholdItemTests: XCTestCase {

    func testVintageLamp() {
        // Scenario: A generic vintage item (Lamp) tracked in inventory.
        // It doesn't have a "Publisher" or "PlatformType", but has "Manufacturer" and "Condition".
        
        let builder = UserInventoryItemBuilder(name: "Vintage Desk Lamp")
        
        let lamp: any InventoryAsset = try! builder
            .setType("Household")
            // .setDescription("Brass Banker's Lamp") // Not available in UserInventoryItemBuilder
            .setCondition("Excellent")
            .setLocation("Study Desk")
            .addTag("antique")
            .setAcquisition(source: "Estate Sale", date: Date())
            .build()
            
        // 1. Verify Basic Properties
        XCTAssertEqual(lamp.name, "Vintage Desk Lamp")
        XCTAssertEqual(lamp.type, "Household")
        // XCTAssertEqual(lamp.description, "Brass Banker's Lamp")
        XCTAssertEqual(lamp.custodyLocation, "Study Desk")
        
        // 2. Verify Metadata absence (shouldn't have 'platform')
        XCTAssertNil(lamp.metadata["platform"])
        
        // 3. Verify Tags
        XCTAssertTrue(lamp.tags.contains("antique"))
        
        // 4. Verify Acquisition
        XCTAssertEqual(lamp.acquisitionSource, "Estate Sale")
        
        // 5. Verify it conforms to InventoryAsset
        XCTAssertNotNil(lamp as any InventoryCompoundBase)
    }
}
