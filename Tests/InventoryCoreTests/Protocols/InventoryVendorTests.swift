import XCTest
import InventoryCore

// Mock Vendor relying on default implementations
private struct MinimalVendor: InventoryVendor, Sendable {
    let id: UUID
    let name: String
    // All other properties use default implementations
}

final class InventoryVendorTests: XCTestCase {
    
    func testVendorAddressFormatting() {
        let address = VendorAddress(
            street1: "1 Infinite Loop",
            city: "Cupertino",
            stateOrProvince: "CA",
            postalCode: "95014",
            country: "USA"
        )
        
        let expected = """
        1 Infinite Loop
        Cupertino, CA, 95014
        USA
        """
        
        XCTAssertEqual(address.formattedAddress, expected)
    }
    
    func testVendorAddressFormattingEmpty() {
        let address = VendorAddress()
        XCTAssertEqual(address.formattedAddress, "")
    }
    
    func testVendorDefaultImplementations() {
        let vendor = MinimalVendor(id: UUID(), name: "Test Vendor")
        
        XCTAssertNil(vendor.address)
        XCTAssertNil(vendor.inceptionDate)
        XCTAssertTrue(vendor.websites.isEmpty)
        XCTAssertNil(vendor.contactEmail)
        XCTAssertNil(vendor.contactPhone)
        XCTAssertTrue(vendor.metadata.isEmpty)
    }
}
