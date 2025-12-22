import XCTest
import InventoryCore

// Use existing Mocks from MockReferenceModels.swift and MockAsset.swift
// assuming they are available in the test target.

final class InventoryRealWorldScenarioTests: XCTestCase {

    func testUltimaIVScenario() {
        // 1. Manufacturer: Origin Systems
        let originSystems = MockReferenceManufacturer(
            id: UUID(),
            slug: "origin-systems",
            name: "Origin Systems",
            description: "Legendary RPG creator"
        )
        
        // 2. Product: Ultima IV (Reference)
        // Using MockReferenceProduct which conforms to InventoryCompoundBase
        let ultimaIVProduct = MockReferenceProduct(
            id: UUID(),
            title: "Ultima IV: Quest of the Avatar",
            manufacturer: originSystems,
            releaseDate: Date(timeIntervalSince1970: 500000000), // ~1985
            dataSource: nil
            // referenceProductID removed as it's not in init
        )
        
        // Verify Product details
        XCTAssertEqual(ultimaIVProduct.title, "Ultima IV: Quest of the Avatar")
        XCTAssertEqual(ultimaIVProduct.manufacturer?.name, "Origin Systems")
        
        // 3. User Asset: My Boxed Copy
        // MockAsset conforms to InventoryAsset -> InventoryCompoundBase
        let myCopy = MockAsset(
            name: "My Ultima IV Box", // Changed from title to name
            manufacturer: originSystems // Linked to same manufacturer
        )
        
        XCTAssertEqual(myCopy.title, "My Ultima IV Box")
        XCTAssertEqual(myCopy.manufacturer?.name, "Origin Systems")
        
        // 4. Components (Children)
        // Let's add disks and manuals to the user asset.
        
        struct MockItem: InventoryItem {
            var id: UUID = UUID()
            var name: String
            var type: String?
            var size: Int64?
            var quantity: Int = 1
            var serialNumber: String?
            var typeClassifier: InventoryItemClassifier
            var identifiers: [any InventoryIdentifier] = []
            
            // Missing protocols
            var sizeOrWeight: Int64? { size }
            var typeIdentifier: String { type ?? "unknown" }
            var fileHashes: [String : String]? = nil
            var productID: (any InventoryIdentifier)? = nil
        }
        
        let disk1 = MockItem(name: "Program Disk", type: "DSK", typeClassifier: .diskImage)
        let manual = MockItem(name: "Manual", type: "PDF", typeClassifier: .document)
        let map = MockItem(name: "Cloth Map", type: "JPG", typeClassifier: .graphic)
        
        // Manually assigning children if MockAsset allows it.
        // MockAsset: `public var children: [any InventoryItem]` is a var.
        var mutableCopy = myCopy
        mutableCopy.children = [disk1, manual, map]
        
        // 5. Verification
        XCTAssertEqual(mutableCopy.children.count, 3)
        XCTAssertEqual(mutableCopy.children.first?.name, "Program Disk")
        XCTAssertEqual(mutableCopy.children.first?.typeClassifier, .diskImage)
        
        // Check filtering (simulating a smart folder)
        let digitalItems = mutableCopy.children.filter { $0.typeClassifier.category == InventoryItemClassifier.InventoryCategory.digital }
        XCTAssertEqual(digitalItems.count, 3) 
        
        let physicalItems = mutableCopy.children.filter { $0.typeClassifier.category == InventoryItemClassifier.InventoryCategory.physical }
        XCTAssertEqual(physicalItems.count, 0)
        
        // Let's add a physical item
        let ankh = MockItem(name: "Metal Ankh", type: "Object", typeClassifier: .physicalItem)
        mutableCopy.children.append(ankh)
        
        XCTAssertEqual(mutableCopy.children.count, 4)
        XCTAssertEqual(mutableCopy.children.last?.typeClassifier.category, InventoryItemClassifier.InventoryCategory.physical)
    }
}
