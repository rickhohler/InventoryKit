import XCTest
@testable import InventoryCore
import InventoryTypes

final class ReferenceProtocolTests: XCTestCase {
    
    func testReferenceManufacturer() {
        // Given
        let manufacturer = MockReferenceManufacturer(
            slug: "broderbund",
            name: "Broderbund",
            aliases: ["Broderbund Software"],
            description: "Famous educational software company"
        )
        
        // Then
        XCTAssertEqual(manufacturer.slug, "broderbund")
        XCTAssertEqual(manufacturer.name, "Broderbund")
        XCTAssertEqual(manufacturer.aliases.first, "Broderbund Software")
        XCTAssertNotNil(manufacturer.id) // check generated UUID or provided
    }
    
    func testReferenceProduct() {
        // Given
        let manufacturer = MockReferenceManufacturer(slug: "mecc", name: "MECC")
        let url = URL(string: "https://wikipedia.org/wiki/The_Oregon_Trail")!
        
        let product = MockReferenceProduct(
            title: "The Oregon Trail",
            description: "Educational game about pioneer life.",
            manufacturer: manufacturer,
            releaseDate: Date(),
            wikipediaUrl: url,
            platforms: ["Apple II", "DOS"]
        )
        
        // Then
        XCTAssertEqual(product.title, "The Oregon Trail")
        XCTAssertEqual(product.manufacturer?.name, "MECC")
        XCTAssertEqual(product.wikipediaUrl?.absoluteString, "https://wikipedia.org/wiki/The_Oregon_Trail")
        XCTAssertEqual(product.platforms?.count, 2)
        
        // Verify CompoundBase conformance
        XCTAssertEqual(product.children.count, 0)
        XCTAssertNil(product.referenceProductID, "Authority record should have nil referenceProductID")
    }
    
    var referenceProductID: (any InventoryIdentifier)?
    var sourceCode: (any InventorySourceCode)?
    func testReferenceLibrary() {
         let lib = MockReferenceLibrary(name: "Internet Archive", transport: "ia_swift", isVerified: true)
         XCTAssertEqual(lib.name, "Internet Archive")
         XCTAssertEqual(lib.transport, "ia_swift")
         XCTAssertTrue(lib.isVerified)
    }
}
