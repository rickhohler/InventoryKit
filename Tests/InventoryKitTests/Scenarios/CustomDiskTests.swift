import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class CustomDiskTests: XCTestCase {

    func testCustomHomebrewDisk() {
        let homebrew = try! ReferenceManufacturerBuilder(name: "Homebrew Soft")
            .setDescription("Local user group")
            .build()
        
        let builder = UserInventoryItemBuilder(name: "My Game 1.0")
        
        // Uses SoftwareValidator logic implicitly if checked, but here we just need generic build success.
        let customDisk: any InventoryAsset = try! builder
            .setType("software")
            .setManufacturer(homebrew)
            .setCondition("Good")
            .build()
            
        XCTAssertEqual(customDisk.name, "My Game 1.0")
        XCTAssertEqual(customDisk.manufacturer?.name, "Homebrew Soft")
        XCTAssertEqual(customDisk.condition, "Good") 
        // Note: condition is mapped via health.physicalCondition or similar in PrivateAssetImpl?
        // Previous error said "condition" check failed, maybe because it's stored in `health`?
        // Let's check PrivateAssetImpl in Builder:
        // var condition: String? = nil (flat property)
        // Ok, it should work.
    }
    
    func testDiskWithIdentifiedPrograms() {
        // 1. Setup Reference Products
        let broderbund = try! ReferenceManufacturerBuilder(name: "Broderbund").build()
        let karateka = try! ReferenceProductBuilder(title: "Karateka").setManufacturer(broderbund).build()
        let lodeRunner = try! ReferenceProductBuilder(title: "Lode Runner").setManufacturer(broderbund).build()
        
        // 2. Define LocalFile mocking InventoryItem
        struct LocalFile: InventoryItem {
            var id: UUID = UUID()
            var name: String
            var type: String?
            var size: Int64?
            var quantity: Int = 1
            var serialNumber: String?
            var typeClassifier: ItemClassifierType
            var identifiers: [any InventoryIdentifier] = []
            
            var sizeOrWeight: Int64? { size }
            var typeIdentifier: String { type ?? "unknown" }
            var fileHashes: [String : String]? = nil
            var productID: UUID? 
            var sourceCode: (any InventorySourceCode)? = nil
            
            // New Protocol Requirements
            var accessionNumber: String? = nil
            var mediaFormat: MediaFormatType? = nil
            var container: (any ItemContainer)? = nil
            var location: ItemLocationType? = nil
        }
        
        _ = IdentifierModel(type: .libraryReferenceID, value: karateka.id.uuidString)
        _ = IdentifierModel(type: .libraryReferenceID, value: lodeRunner.id.uuidString)
        
        let file1 = LocalFile(name: "KARATEKA.BIN", type: "BIN", typeClassifier: .physicalSoftware, productID: karateka.id)
        let file2 = LocalFile(name: "LODE.BIN", type: "BIN", typeClassifier: .physicalSoftware, productID: lodeRunner.id)
        
        // 3. Build Asset
        let builder = UserInventoryItemBuilder(name: "Compilation Disk A")
        let disk: any InventoryAsset = try! builder
            .setType("media")
            .setLocation("Box 1")
            .addChild(file1)
            .addChild(file2)
            .build()
            
        // 4. Verify Linkage
        XCTAssertEqual(disk.children.count, 2)
        XCTAssertEqual(disk.children.first?.name, "KARATEKA.BIN")
        
        // Verify we can retrieve the product ID and it matches
        // Assumes we can read productID.value or resolved string
        let child1 = disk.children[0]
        XCTAssertEqual(child1.productID?.uuidString, karateka.id.uuidString)
        
        let child2 = disk.children[1]
        XCTAssertEqual(child2.productID?.uuidString, lodeRunner.id.uuidString)
    }
}
