import XCTest
import InventoryCore
import InventoryTypes

// Mock Vendor relying on default implementations
private struct MinimalVendor: Vendor, Sendable {
    var id: UUID
    var name: String
    var address: (any Address)? = nil
    var inceptionDate: Date? = nil
    var websites: [URL] = []
    var contactEmail: String? = nil
    var contactPhone: String? = nil
    var metadata: [String : String] = [:]
}

final class VendorTests: XCTestCase {
    
    func testVendorAddressFormatting() {
        let address = MockAddress(
            address: "1 Infinite Loop",
            city: "Cupertino",
            region: "CA",
            postalCode: "95014",
            country: "USA"
        )
        
        let expected = "1 Infinite Loop, Cupertino, CA, 95014, USA"
        
        XCTAssertEqual(address.formattedAddress, expected)
    }
    
    func testVendorAddressFormattingEmpty() {
        let address = MockAddress(address: "")
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
