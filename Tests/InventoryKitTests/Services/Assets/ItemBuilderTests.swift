import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class ItemBuilderTests: XCTestCase {
    
    func testUserBuilder() {
        let builder = UserInventoryItemBuilder(name: "My Retro Computer")
        
        let asset: any InventoryAsset = try! builder
            .setType("hardware")
            .addTag("collection")
            .setAcquisition(source: "Garage Sale", date: Date(timeIntervalSince1970: 1000000000))
            .setLocation("Home")
            .build()
            
        XCTAssertEqual(asset.name, "My Retro Computer")
        XCTAssertEqual(asset.type, "hardware")
        XCTAssertTrue(asset.tags.contains("collection"))
        XCTAssertEqual(asset.acquisitionSource, "Garage Sale")
        XCTAssertEqual(asset.custodyLocation, "Home")
    }
    
    func testReferenceProductBuilder() {
        let builder = ReferenceProductBuilder(title: "Super Mario Bros")
        
        let product: any Product = try! builder
            .setPlatform("NES")
            .setPublisher("Nintendo")
            .build()
            
        XCTAssertEqual(product.title, "Super Mario Bros") 
        XCTAssertEqual(product.platform, "NES")
        XCTAssertEqual(product.publisher, "Nintendo")
    }
    
    func testReferenceManufacturerBuilder() {
        let builder = ReferenceManufacturerBuilder(name: "Nintendo")
        
        let manufacturer: any Manufacturer = try! builder
            .addAlias("Nintendo Co., Ltd.")
            .setDescription("The Giant")
            .build()
            
        XCTAssertEqual(manufacturer.name, "Nintendo")
        XCTAssertTrue(manufacturer.aliases.contains("Nintendo Co., Ltd."))
        XCTAssertEqual(manufacturer.description, "The Giant")
    }
}
