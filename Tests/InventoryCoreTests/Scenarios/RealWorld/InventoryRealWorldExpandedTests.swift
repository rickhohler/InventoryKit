
import XCTest
import InventoryCore

final class InventoryRealWorldExpandedTests: XCTestCase {
    
    // MARK: - Local Mocks
    
    struct LocalMockProduct: InventoryProduct {
        var id: UUID = UUID()
        var title: String = "Test Product"
        var description: String?
        var manufacturer: (any InventoryManufacturer)?
        var releaseDate: Date?
        var dataSource: (any InventoryDataSource)?
        var children: [any InventoryItem] = []
        var images: [any InventoryItem] = []
        var identifiers: [any InventoryIdentifier] = []
        var sku: String?
        var productType: String?
        var classification: String?
        var genre: String?
        var publisher: String?
        var developer: String?
        var creator: String?
        var productionDate: Date?
        var platform: String?
        var systemRequirements: (any InventorySystemRequirements)?
        var version: String?
        var instanceIDs: [UUID] = []
        var artworkIDs: [UUID] = []
        var screenshotIDs: [UUID] = []
        var instructionIDs: [UUID] = []
        var collectionIDs: [UUID] = []
        var references: [String : String] = [:]
        var metadata: [String : String] = [:]
        var referenceProductID: (any InventoryIdentifier)? = nil
        var sourceCode: (any InventorySourceCode)? = nil
    }
    
    struct LocalMockItem: InventoryItem {
        var name: String
        var sizeOrWeight: Int64?
        var typeIdentifier: String
        var accessionNumber: String?
        var fileHashes: [String : String]?
        var serialNumber: String?
        var typeClassifier: InventoryItemClassifier
        var mediaFormat: InventoryMediaFormat?
        var identifiers: [any InventoryIdentifier] = []
        var productID: (any InventoryIdentifier)? = nil
        var sourceCode: (any InventorySourceCode)? = nil
    }
    
    // MARK: - Tests
    
    func testHomebrewGameWithSourceAndRequirements() {
        // Scenario: A user archives a Homebrew game they made.
        // It has source code on GitHub.
        // It runs on Apple IIe (Enhanced) so it needs 64KB RAM and 65C02.
        
        // 1. Define Requirements
        let reqs = MockSystemRequirements(
            minMemory: 640_000,
            recommendedMemory: 1024_000,
            cpuFamily: "65C02",
            video: "VGA",
            audio: "AdLib",
            minOsVersion: "ProDOS 2.4.2"
        )
        
        // 2. Define Source Code
        let source = MockSourceCode(
            url: URL(string: "https://github.com/retro/mygame")!,
            notes: "Build with Merlin 32"
        )
        
        // 3. Create Product Definition
        let product = LocalMockProduct(
            title: "My Homebrew RPG",
            systemRequirements: reqs,
            sourceCode: source
        )
        
        // Assertions
        XCTAssertEqual(product.systemRequirements?.minMemory, 640_000)
        XCTAssertEqual(product.systemRequirements?.cpuFamily, "65C02")
        XCTAssertEqual(product.sourceCode?.url.absoluteString, "https://github.com/retro/mygame")
        
        // 4. Create Library Item (Accession)
        // The museum ingests this disk into their collection.
        let diskItem = LocalMockItem(
            name: "Master Disk",
            sizeOrWeight: 143360,
            typeIdentifier: "public.data",
            accessionNumber: "2025.LIB.001",
            typeClassifier: .physicalSoftware,
            mediaFormat: .floppy525
        )
        
        XCTAssertEqual(diskItem.accessionNumber, "2025.LIB.001")
        XCTAssertEqual(diskItem.mediaFormat, .floppy525)
    }
    
    func testAccessionNumberUniquenessSimulated() {
        // Verify we can store different accession numbers
        let item1 = LocalMockItem(name: "A", sizeOrWeight: nil, typeIdentifier: "A", accessionNumber: "ACC-001", typeClassifier: .other)
        let item2 = LocalMockItem(name: "B", sizeOrWeight: nil, typeIdentifier: "B", accessionNumber: "ACC-002", typeClassifier: .other)
        
        XCTAssertNotEqual(item1.accessionNumber, item2.accessionNumber)
    }
    
    func testSystemRequirementsComparison() {
        // Verify we can check if requirements are met (logic check)
        let reqLow = MockSystemRequirements(minMemory: 16 * 1024)
        let reqHigh = MockSystemRequirements(minMemory: 64 * 1024)
        
        // Simple manual check logic (since struct doesn't have 'isSatisfiedBy' method yet, we test data integrity)
        XCTAssertTrue(reqHigh.minMemory! > reqLow.minMemory!)
    }
}
