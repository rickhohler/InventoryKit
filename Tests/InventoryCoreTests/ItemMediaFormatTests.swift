import XCTest
import InventoryCore
import InventoryTypes

final class ItemMediaFormatTests: XCTestCase {
    
    // Mock Item conforming to the updated protocol
    struct MockMediaItem: InventoryItem {
        var name: String
        var sizeOrWeight: Int64?
        var typeIdentifier: String
        var accessionNumber: String?
        var fileHashes: [String : String]?
        var serialNumber: String?
        var typeClassifier: ItemClassifierType
        
        // The new property to test
        var mediaFormat: MediaFormatType?
        
        var identifiers: [any InventoryIdentifier]
        
        var productID: UUID? = nil
        var sourceCode: (any InventorySourceCode)? = nil

        var container: (any ItemContainer)? = nil
        var location: ItemLocationType? = nil
    }
    
    func testMediaFormatLabels() {
        // Enforce coverage on the `label` computed property
        XCTAssertEqual(MediaFormatType.cassette.label, "Compact Cassette")
        XCTAssertEqual(MediaFormatType.datTape.label, "DAT Tape")
        XCTAssertEqual(MediaFormatType.reelToReel.label, "Reel-to-Reel Tape")
        XCTAssertEqual(MediaFormatType.floppy525.label, "5.25\" Floppy Disk")
        XCTAssertEqual(MediaFormatType.floppy35.label, "3.5\" Floppy Disk")
        XCTAssertEqual(MediaFormatType.floppy8.label, "8\" Floppy Disk")
        XCTAssertEqual(MediaFormatType.cdRom.label, "CD-ROM")
        XCTAssertEqual(MediaFormatType.dvdRom.label, "DVD-ROM")
        XCTAssertEqual(MediaFormatType.laserDisc.label, "LaserDisc")
        XCTAssertEqual(MediaFormatType.cartridge.label, "Cartridge")
        XCTAssertEqual(MediaFormatType.sdCard.label, "SD Card")
        XCTAssertEqual(MediaFormatType.compactFlash.label, "CompactFlash")
        XCTAssertEqual(MediaFormatType.pcmcia.label, "PCMCIA Card")
        XCTAssertEqual(MediaFormatType.usbDrive.label, "USB Flash Drive")
        XCTAssertEqual(MediaFormatType.digital.label, "Digital Download")
        XCTAssertEqual(MediaFormatType.other.label, "Other")
    }
    
    func testWikipediaURLs() {
        // Enforce that we have valid URLs for key types
        XCTAssertEqual(MediaFormatType.floppy525.wikipediaURL?.absoluteString, "https://en.wikipedia.org/wiki/Floppy_disk#5%C2%BC-inch_minifloppy")
        XCTAssertEqual(MediaFormatType.cartridge.wikipediaURL?.absoluteString, "https://en.wikipedia.org/wiki/ROM_cartridge")
        XCTAssertEqual(MediaFormatType.usbDrive.wikipediaURL?.absoluteString, "https://en.wikipedia.org/wiki/USB_flash_drive")
        XCTAssertNil(MediaFormatType.other.wikipediaURL)
    }
    
    func testCodable() throws {
        // Verify JSON Roundtrip
        let original: MediaFormatType = .floppy525
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(MediaFormatType.self, from: data)
        
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
