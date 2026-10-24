import XCTest
import InventoryCore
import InventoryTypes
import InventoryKit

final class QuestionnaireIntegrationTests: XCTestCase {
    
    // MARK: - Digital Software Tests
    
    func testDigitalSoftwareQuestionnaire() {
        let q = DigitalSoftwareQuestionnaire(
            format: .fluxImage,
            isCracked: true,
            hasTrainer: true,
            isVerifiedClean: false,
            region: "NTSC",
            isOriginalDump: true
        )
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Format.fluxImage.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.cracked.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.trainer.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.originalDump.rawValue))
        XCTAssertTrue(tags.contains("region:ntsc"))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["format_type"], "Flux Image")
        XCTAssertEqual(attrs["is_cracked"], "true")
        XCTAssertEqual(attrs["region"], "NTSC")
    }
    
    func testReferenceProductBuilder_WithDigitalQuestionnaire() throws {
        let q = DigitalSoftwareQuestionnaire(format: .rom, isCracked: false, region: "PAL")
        
        let builder = ReferenceProductBuilder(title: "Test ROM")
            .applyQuestionnaire(q)
            .setPlatform("Genesis")
        
        let product = try builder.build()
        
        XCTAssertEqual(product.title, "Test ROM")
        XCTAssertEqual(product.metadata["format_type"], "ROM")
        XCTAssertEqual(product.metadata["region"], "PAL")
        // Note: Reference Products might not use tags directly, but metadata is key here.
    }
    
    // MARK: - Manufacturer Tests
    
    func testSoftwarePublisherQuestionnaire() {
        let q = SoftwarePublisherQuestionnaire(
            isIndie: true,
            primaryRegion: "USA",
            notablePlatforms: ["PC", "Mac"],
            status: .active
        )
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Manufacturer.publisher.rawValue))
        XCTAssertTrue(tags.contains(TagType.Manufacturer.indie.rawValue))
        XCTAssertTrue(tags.contains(TagType.Manufacturer.active.rawValue))
        XCTAssertTrue(tags.contains("platform:pc"))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["type"], "Software Publisher")
        XCTAssertEqual(attrs["status"], "Active")
        XCTAssertEqual(attrs["region"], "USA")
    }
    
    func testHardwareManufacturerQuestionnaire() {
        let q = HardwareManufacturerQuestionnaire(
            manufacturerType: .computer,
            status: .defunct
        )
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Manufacturer.hardware.rawValue))
        XCTAssertTrue(tags.contains("type:computer"))
        XCTAssertTrue(tags.contains(TagType.Manufacturer.defunct.rawValue))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["type"], "Hardware Manufacturer")
        XCTAssertEqual(attrs["hardware_category"], "Computer Systems")
    }
    
    func testReferenceManufacturerBuilder_WithQuestionnaire() throws {
        let q = SoftwarePublisherQuestionnaire(isIndie: false, status: .merged)
        
        let builder = ReferenceManufacturerBuilder(name: "Big Corp")
            .applyQuestionnaire(q)
            
        let manuf = try builder.build()
        
        guard let refManuf = manuf as? ReferenceManufacturer else {
            XCTFail("Expected ReferenceManufacturer")
            return
        }
        
        XCTAssertEqual(refManuf.name, "Big Corp")
        XCTAssertEqual(refManuf.metadata["status"], "Merged")
        XCTAssertEqual(refManuf.metadata["type"], "Software Publisher")
    }
    
    // MARK: - New Domains
    
    func testPeripheralQuestionnaire() {
        let q = PeripheralQuestionnaire(interface: .usb, requiresDrivers: true, compatibility: ["Mac"])
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Interface.usb.rawValue))
        XCTAssertTrue(tags.contains("req:drivers"))
        XCTAssertTrue(tags.contains("compat:mac"))
    }
    
    func testPublicationQuestionnaire() {
        let q = PublicationQuestionnaire(title: "Guide", binding: .hardcover)
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(PublicationQuestionnaire.Binding.hardcover.rawValue))
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["title"], "Guide")
    }
    
    func testMultimediaQuestionnaire() {
        let q = MultimediaQuestionnaire(format: .vhs, durationMinutes: 90)
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.MediaFormatType.vhs.rawValue))
        XCTAssertTrue(tags.contains(TagType.Format.physical.rawValue))
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["duration_min"], "90")
    }
    
    func testPhysicalItemQuestionnaire() {
        let q = PhysicalItemQuestionnaire(material: .wood, primaryColor: "Oak")
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Material.wood.rawValue))
        XCTAssertTrue(tags.contains("color:oak"))
    }
}
