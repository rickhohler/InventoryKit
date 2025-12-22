import XCTest
import InventoryCore

final class RealWorldInventoryTests: XCTestCase {

    // MARK: - Scenario 1: Karateka (Physical vs Digital)
    
    func testKaratekaPhysicalVsDigital() {
        // 1. Digital Backup
        let digitalCopy = MockInventoryItem(
            name: "Karateka.dsk",
            typeClassifier: .software, // Defaults to digital
            tags: ["Backup"]
        )
        
        XCTAssertEqual(digitalCopy.typeClassifier, .software)
        XCTAssertEqual(digitalCopy.typeClassifier.category, .digital)
        
        // 2. Physical Boxed Copy
        // User indicates they have the Box, Manual, and Disk
        let contents: InventoryPackageContents = [.box, .manual, .media]
        
        let physicalCopy = MockInventoryItem(
            name: "Karateka (Original Box)",
            typeClassifier: .physicalSoftware, // Explicitly physical software
            tags: ["CIB", "Original"] // Tags might store the string representation or we map contents to tags
        )
        
        XCTAssertEqual(physicalCopy.typeClassifier, .physicalSoftware)
        XCTAssertEqual(physicalCopy.typeClassifier.category, .physical)
        
        // Check that Standard CIB definition matches this user's contents
        XCTAssertEqual(contents, .standardCIB)
        XCTAssertTrue(contents.contains(.box))
        XCTAssertTrue(contents.contains(.manual))
        XCTAssertTrue(contents.contains(.media))
    }
    
    // MARK: - Scenario 2: Sound Blaster (Hardware)
    
    func testSoundBlasterHardware() {
        // User has the Card (media/device), Box, but NO Manual, NO Cables.
        let mySoundBlasterContents: InventoryPackageContents = [.box, .media] // Media here implies the card itself or driver disks? 
        // Actually for hardware, "media" usually means software media. The hardware ITSELF is the primary item.
        // But let's assume 'media' tracks the driver disks.
        
        let soundBlaster = MockInventoryItem(
            name: "Sound Blaster 16",
            typeClassifier: .computerHardware,
            tags: ["In Box", "Missing Manual"]
        )
        
        XCTAssertEqual(soundBlaster.typeClassifier, .computerHardware)
        XCTAssertEqual(soundBlaster.typeClassifier.category, .physical)
        
        // Verify Content Logic
        // It is NOT complete CIB because it lacks manual/cables/psu
        XCTAssertNotEqual(mySoundBlasterContents, .hardwareCIB)
        
        // But it has the Box
        XCTAssertTrue(mySoundBlasterContents.contains(.box))
        
        // Check what is missing from CIB
        let missingItems = InventoryPackageContents.hardwareCIB.subtracting(mySoundBlasterContents)
        XCTAssertTrue(missingItems.contains(.manual))
        XCTAssertTrue(missingItems.contains(.cables))
        XCTAssertTrue(missingItems.contains(.powerSupply))
    }
}

// MARK: - Mock Helper
// Simple Mock to test the logic of the types
struct MockInventoryItem: InventoryItem {
    let name: String
    var sizeOrWeight: Int64? = nil
    var typeIdentifier: String = "public.data"
    var fileHashes: [String : String]? = nil
    var serialNumber: String? = nil
    let typeClassifier: InventoryItemClassifier
    let identifiers: [any InventoryIdentifier] = []
    let ids: [any InventoryIdentifier] = []
    let productID: InventoryIdentifier? = nil
    let tags: [String] // Simulating tags for metadata
    var sourceCode: (any InventorySourceCode)? = nil
    
    // Missing Protocol Stubs
    var accessionNumber: String? = nil
    var mediaFormat: InventoryMediaFormat? = nil
}
