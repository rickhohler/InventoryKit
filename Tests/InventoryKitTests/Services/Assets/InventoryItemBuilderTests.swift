import XCTest
import InventoryCore
@testable import InventoryKit

final class BuilderTests: XCTestCase {
    
    func testUserBuilder() {
        let builder = UserInventoryItemBuilder(name: "My Retro Computer")
        
        let asset: any InventoryAsset = builder
            .setType("hardware")
            .addTag("collection")
            .build()
            
        XCTAssertEqual(asset.name, "My Retro Computer")
        XCTAssertEqual(asset.type, "hardware")
        XCTAssertTrue(asset.tags.contains("collection"))
        XCTAssertNil(asset.source)
    }
    
    func testLibraryBuilder() {
        let builder = LibraryItemBuilder(title: "Super Mario Bros")
        
        let asset: any InventoryAsset = builder
            .setPlatform("NES")
            .setPublisher("Nintendo")
            .build()
            
        XCTAssertEqual(asset.name, "Super Mario Bros")
        XCTAssertEqual(asset.metadata["platform"], "NES")
        XCTAssertEqual(asset.metadata["publisher"], "Nintendo")
        XCTAssertEqual(asset.custodyLocation, "Public Library")
    }
}
