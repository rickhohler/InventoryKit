import XCTest
import InventoryCore
@testable import InventoryCoreTests
// @testable import InventoryKit // Not needed if we use MockAsset directly?
// Actually we want to test InventoryAsset protocol, so constructing MockAsset is fine.

final class InventoryRealWorldCoverageTests: XCTestCase {

    func testKitchenSinkAsset() {
        // Goal: Populate EVERY field in InventoryAsset to ensure protocols hold data correctly.
        
        // 1. Rich Components
        let health = MockHealth(
            physicalCondition: .good,
            operationalStatus: .working,
            notes: "Fan replaced 2024",
            lastDiagnosticAt: Date()
        )
        
        // 2. MRO
        let mro = MockMRO(
            sku: "A2S2024",
            vendor: "RetroParts Inc",
            quantityOnHand: 1,
            reorderPoint: 0,
            reorderQuantity: 5
        )
        
        // 3. Copyright
        let copyright = MockCopyright(
            text: "(c) 1988 Origin Systems",
            year: 1988,
            holder: "Origin Systems",
            license: "Proprietary",
            metadata: ["registration": "TX-123"]
        )
        
        // 4. Lifecycle
        let event = MockLifecycleEvent(timestamp: Date(), actor: "Rick", note: "Acquired")
        let lifecycle = MockLifecycle(stage: .active, events: [event])
        
        // 5. Links
        let compLink = MockComponentLink(assetID: UUID(), quantity: 1, note: "Power Supply")
        let req = MockRelationshipRequirement(name: "Monitor", typeID: "display", required: true)
        let link = MockLinkedAsset(assetID: UUID(), typeID: "display", note: "Connected Monitor")
        
        // 6. Source
        let source = MockSource(origin: "eBay Auction #12345")
        
        // 7. Base Data
        let manufacturer = MockReferenceManufacturer(id: UUID(), slug: "origin", name: "Origin Systems")
        
        // Construct the "Kitchen Sink" Asset
        let asset = MockAsset(
            id: UUID(),
            name: "Ultima V - Collector's Box",
            description: "Complete in Box",
            manufacturer: manufacturer,
            releaseDate: Date(), // approx 1988
            type: "software",
            identifiers: [MockIdentifier(type: .upc, value: "123456789")],
            tags: ["RPG", "Classic"],
            metadata: ["edition": "Collector"],
            provenance: "From original owner",
            acquisitionSource: "eBay",
            forensicClassification: "Original",
            custodyLocation: "Shelf A",
            productID: UUID(),
            
            // Inject Rich Models
            source: source,
            lifecycle: lifecycle,
            health: health,
            mro: mro,
            copyright: copyright,
            components: [compLink],
            relationshipRequirements: [req],
            linkedAssets: [link]
        )
        
        // Assertions - Prove data made it in
        XCTAssertEqual(asset.name, "Ultima V - Collector's Box")
        XCTAssertEqual(asset.health?.physicalCondition, .good)
        XCTAssertEqual(asset.mro?.sku, "A2S2024")
        XCTAssertEqual(asset.copyright?.year, 1988)
        XCTAssertEqual(asset.components.count, 1)
        XCTAssertEqual(asset.relationshipRequirements.first?.name, "Monitor")
        XCTAssertEqual(asset.linkedAssets.first?.typeID, "display")
        XCTAssertEqual(asset.lifecycle?.events.count, 1)
        
        // Prove Base Protocol conformance via protocol witness
        let protocolWitness: any InventoryAsset = asset
        XCTAssertNotNil(protocolWitness.health)
        XCTAssertNotNil(protocolWitness.mro)
    }
}
