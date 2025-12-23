import XCTest
@testable import InventoryCore
import InventoryTypes

final class ResourceNameTests: XCTestCase {
    
    func testResourceNameStructure() {
        let irn = InventoryResourceName(
            partition: .public,
            service: .product,
            namespace: "global",
            type: "hardware",
            id: "123456"
        )
        // inventory:public:product:global:hardware:123456
        XCTAssertEqual(irn.description, "inventory:public:product:global:hardware:123456")
    }
    
    func testBuilder() {
        let productID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let irn = InventoryResourceNameBuilder.publicProduct(type: "software", id: productID)
        XCTAssertEqual(irn.description, "inventory:public:product:global:software:00000000-0000-0000-0000-000000000001")
        
        let userID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        let assetID = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
        let assetIrn = InventoryResourceNameBuilder.privateAsset(userID: userID, type: "disk", id: assetID)
        XCTAssertEqual(assetIrn.description, "inventory:private:asset:11111111-1111-1111-1111-111111111111:disk:22222222-2222-2222-2222-222222222222")
        
        let vendorID = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
        let collectionID = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
        let collectionIrn = InventoryResourceNameBuilder.publicCollection(vendorID: vendorID, id: collectionID)
        XCTAssertEqual(collectionIrn.description, "inventory:public:collection:33333333-3333-3333-3333-333333333333:collection:44444444-4444-4444-4444-444444444444")
        
        // Test parsing
        let parsed = InventoryResourceName(irn.description)
        XCTAssertNotNil(parsed)
        XCTAssertEqual(parsed?.id, "00000000-0000-0000-0000-000000000001")
        XCTAssertEqual(parsed?.service, .product)
    }
    
    func testParsing() {
        let validString = "inventory:private:asset:user123:disk:disk1"
        let irn = InventoryResourceName(validString)
        XCTAssertNotNil(irn)
        XCTAssertEqual(irn?.partition, .private)
        XCTAssertEqual(irn?.service, .asset)
        XCTAssertEqual(irn?.namespace, "user123")
        XCTAssertEqual(irn?.type, "disk")
        XCTAssertEqual(irn?.id, "disk1")
        
        let invalidString = "invalid:format"
        XCTAssertNil(InventoryResourceName(invalidString))
    }
}
