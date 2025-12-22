import XCTest
import InventoryCore

final class InventoryItemMediaFormatTests: XCTestCase {
    
    // Mock Item conforming to the updated protocol
    struct MockMediaItem: InventoryItem {
        var name: String
        var sizeOrWeight: Int64?
        var typeIdentifier: String
        var accessionNumber: String?
        var fileHashes: [String : String]?
        var serialNumber: String?
        var typeClassifier: InventoryItemClassifier
        
        // The new property to test
        var mediaFormat: InventoryMediaFormat?
        
        var identifiers: [any InventoryIdentifier]
        
        var productID: (any InventoryIdentifier)? = nil
        var sourceCode: (any InventorySourceCode)? = nil
    }
    
    func testMediaFormatLabels() {
        // Enforce coverage on the `label` computed property
        XCTAssertEqual(InventoryMediaFormat.cassette.label, "Compact Cassette")
        XCTAssertEqual(InventoryMediaFormat.datTape.label, "DAT Tape")
        XCTAssertEqual(InventoryMediaFormat.reelToReel.label, "Reel-to-Reel Tape")
        XCTAssertEqual(InventoryMediaFormat.floppy525.label, "5.25\" Floppy Disk")
        XCTAssertEqual(InventoryMediaFormat.floppy35.label, "3.5\" Floppy Disk")
        XCTAssertEqual(InventoryMediaFormat.floppy8.label, "8\" Floppy Disk")
        XCTAssertEqual(InventoryMediaFormat.cdRom.label, "CD-ROM")
        XCTAssertEqual(InventoryMediaFormat.dvdRom.label, "DVD-ROM")
        XCTAssertEqual(InventoryMediaFormat.laserDisc.label, "LaserDisc")
        XCTAssertEqual(InventoryMediaFormat.cartridge.label, "Cartridge")
        XCTAssertEqual(InventoryMediaFormat.sdCard.label, "SD Card")
        XCTAssertEqual(InventoryMediaFormat.compactFlash.label, "CompactFlash")
        XCTAssertEqual(InventoryMediaFormat.pcmcia.label, "PCMCIA Card")
        XCTAssertEqual(InventoryMediaFormat.usbDrive.label, "USB Flash Drive")
        XCTAssertEqual(InventoryMediaFormat.digital.label, "Digital Download")
        XCTAssertEqual(InventoryMediaFormat.other.label, "Other")
    }
    
    func testWikipediaURLs() {
        // Enforce that we have valid URLs for key types
        XCTAssertEqual(InventoryMediaFormat.floppy525.wikipediaURL?.absoluteString, "https://en.wikipedia.org/wiki/Floppy_disk#5%C2%BC-inch_minifloppy")
        XCTAssertEqual(InventoryMediaFormat.cartridge.wikipediaURL?.absoluteString, "https://en.wikipedia.org/wiki/ROM_cartridge")
        XCTAssertEqual(InventoryMediaFormat.usbDrive.wikipediaURL?.absoluteString, "https://en.wikipedia.org/wiki/USB_flash_drive")
        XCTAssertNil(InventoryMediaFormat.other.wikipediaURL)
    }
    
    func testCodable() throws {
        // Verify JSON Roundtrip
        let original: InventoryMediaFormat = .floppy525
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(InventoryMediaFormat.self, from: data)
        
        XCTAssertEqual(original, decoded)
    }
    
    func testItemIntegration() {
        // 1. Test with a format
        var item = MockMediaItem(
            name: "Lode Runner",
            sizeOrWeight: nil,
            typeIdentifier: "game",
            accessionNumber: nil,
            fileHashes: nil,
            serialNumber: nil,
            typeClassifier: .physicalSoftware,
            mediaFormat: .floppy525,
            identifiers: []
        )
        XCTAssertEqual(item.mediaFormat, .floppy525)
        XCTAssertEqual(item.mediaFormat?.label, "5.25\" Floppy Disk")
        
        // 2. Test without a format (Optionality)
        item.mediaFormat = nil
        XCTAssertNil(item.mediaFormat)
    }
}
