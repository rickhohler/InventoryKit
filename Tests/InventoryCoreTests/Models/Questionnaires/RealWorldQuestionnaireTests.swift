import XCTest
import InventoryCore
import InventoryTypes
import InventoryKit

/// Real-world scenario tests for Questionnaires.
/// Ensures that complex, realistic data inputs result in the correct Metadata and Tags.
final class RealWorldQuestionnaireTests: XCTestCase {
    
    // MARK: - Scenario 1: Doom II (Physical, Floppy, MS-DOS)
    func testScenario_DoomII_Physical() throws {
        // User has a physical copy of Doom II on 3.5" floppies.
        // It is complete in box, but the manual has some water damage.
        
        let q = PhysicalSoftwareQuestionnaire(
            hasBox: true,
            hasManual: true,
            hasMedia: true,
            hasRegistrationCard: false,
            hasMaps: false,
            overallCondition: .good, // Box is good
            damageNotes: "Water damage on manual pages 3-4",
            provenanceNotes: "Purchased at Electronics Boutique, 1994"
        )
        
        // 1. Verify Tags
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Condition.cib.rawValue), "Should be Complete In Box")
        XCTAssertFalse(tags.contains(TagType.Condition.sealed.rawValue))
        XCTAssertFalse(tags.contains(TagType.Condition.loose.rawValue))
        
        // 2. Verify Attributes
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["condition_grade"], "Good") // Condition rawValue is "Good"
        XCTAssertEqual(attrs["notes_damage"], "Water damage on manual pages 3-4")
        XCTAssertEqual(attrs["notes_provenance"], "Purchased at Electronics Boutique, 1994")
        XCTAssertEqual(attrs["has_box"], "true")
        
        // 3. Builder Integration (Mock usage)
        // ...
    }
    
    // MARK: - Scenario 2: Lode Runner (Digital, Flux Image, Apple II)
    func testScenario_LodeRunner_Digital() throws {
        // User has a .woz flux dump of their original Lode Runner disk.
        // It is verified clean against a known database.
        
        let q = DigitalSoftwareQuestionnaire(
            classifier: .software,
            format: .fluxImage,
            isCracked: false,
            hasTrainer: false,
            isVerifiedClean: true,
            region: "NTSC",
            isOriginalDump: true // User dumped it themselves
        )
        
        // 1. Verify Tags
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Format.fluxImage.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.originalDump.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.verifiedClean.rawValue))
        XCTAssertTrue(tags.contains("region:ntsc"))
        XCTAssertFalse(tags.contains(TagType.DigitalState.cracked.rawValue))
        
        // 2. Verify Attributes
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["format_type"], "Flux Image")
        XCTAssertEqual(attrs["is_original_dump"], "true")
        XCTAssertEqual(attrs["is_clean"], "true")
    }
    
    // MARK: - Scenario 3: Sound Blaster 16 (Hardware, Loose)
    func testScenario_SoundBlaster16() throws {
        // User has a loose Sound Blaster 16 card.
        // No box, no manual. Functional.
        
        let q = HardwareQuestionnaire(
            classifier: .computerHardware,
            hasBox: false,
            hasManual: false,
            hasPowerSupply: false, // Internal card, n/a
            hasCables: false,
            isFunctional: true,
            needsRecap: false,
            cosmeticCondition: .good,
            serialNumber: "SB16-99887766",
            modNotes: nil,
            damageNotes: nil
        )
        
        // 1. Verify Tags
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Condition.working.rawValue))
        XCTAssertFalse(tags.contains(TagType.Condition.boxed.rawValue))
        XCTAssertFalse(tags.contains(TagType.Condition.modded.rawValue))
        
        // 2. Verify Attributes
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["is_functional"], "true")
        XCTAssertEqual(attrs["condition_cosmetic"], "Good")
        XCTAssertEqual(attrs["serial_number"], "SB16-99887766")
        XCTAssertNil(attrs["notes_mods"])
    }
    
    // MARK: - Scenario 4: Origin Systems (Publisher)
    func testScenario_OriginSystems() throws {
        // Creating a Reference Manufacturer for Origin Systems.
        
        let q = SoftwarePublisherQuestionnaire(
            isIndie: false,
            primaryRegion: "USA",
            notablePlatforms: ["Apple II", "PC", "Amiga"],
            status: .defunct // Acquired by EA
        )
        
        let builder = ReferenceManufacturerBuilder(name: "Origin Systems")
            .applyQuestionnaire(q)
            .setDescription("Legendary RPG developer.")
        
        let manuf = try builder.build()
        
        XCTAssertEqual(manuf.name, "Origin Systems")
        XCTAssertEqual(manuf.metadata["type"], "Software Publisher")
        XCTAssertEqual(manuf.metadata["status"], "Defunct")
        XCTAssertEqual(manuf.metadata["region"], "USA")
        
        // Verify platform list flattened correctly
        let platforms = manuf.metadata["platforms"]
        XCTAssertNotNil(platforms)
        XCTAssertTrue(platforms!.contains("Apple II"))
    }
    
    // MARK: - Scenario 5: Commodore (Hardware Manufacturer)
    func testScenario_Commodore() throws {
        let q = HardwareManufacturerQuestionnaire(
            manufacturerType: .computer,
            primaryRegion: "USA",
            status: .defunct
        )
        
        let builder = ReferenceManufacturerBuilder(name: "Commodore Business Machines")
            .applyQuestionnaire(q)
            
        let manuf = try builder.build()
        
        guard let refManuf = manuf as? ReferenceManufacturer else {
            XCTFail("Expected ReferenceManufacturer")
            return
        }
        
        XCTAssertEqual(refManuf.metadata["hardware_category"], "Computer Systems")
        XCTAssertEqual(refManuf.metadata["status"], "Defunct")
    }
}
