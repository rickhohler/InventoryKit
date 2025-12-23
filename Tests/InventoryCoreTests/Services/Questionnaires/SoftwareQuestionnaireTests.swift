import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class SoftwareQuestionnaireTests: XCTestCase {
    
    // MARK: - Physical Software Scenarios
    
    func testPhysical_BigBoxCIB() {
        // Scenario: Ultima IV for Apple II - Complete In Box
        var q = PhysicalSoftwareQuestionnaire()
        q.hasBox = true
        q.hasManual = true
        q.hasMedia = true // Diskettes
        q.hasMaps = true // Cloth map!
        q.hasRegistrationCard = false // Lost over time
        q.overallCondition = .good
        q.provenanceNotes = "Purchased on eBay 2010"
        
        // Tags
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Condition.cib.rawValue), "Should be CIB")
        XCTAssertTrue(tags.contains(TagType.Content.map.rawValue), "Should have map tag")
        XCTAssertFalse(tags.contains(TagType.Condition.loose.rawValue))
        
        // Attributes
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["has_box"], "true")
        XCTAssertEqual(attrs["condition_grade"], "Good")
        XCTAssertEqual(attrs["notes_provenance"], "Purchased on eBay 2010")
        
        // Questions
        XCTAssertNotNil(q.localizedQuestions["hasMaps"])
        XCTAssertEqual(q.targetClassifier, .physicalSoftware)
    }
    
    func testPhysical_LooseCartridge() {
        // Scenario: Super Mario Bros / Duck Hunt - Loose Cart
        let q = PhysicalSoftwareQuestionnaire(
            hasBox: false,
            hasManual: false,
            hasMedia: true,
            overallCondition: .loose,
            damageNotes: "Label peeling"
        )
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Condition.loose.rawValue))
        XCTAssertFalse(tags.contains(TagType.Condition.cib.rawValue))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["has_box"], "false")
        XCTAssertEqual(attrs["notes_damage"], "Label peeling")
    }
    
    func testPhysical_PartialComponents() {
        // Scenario: Game with Box but no Manual
        let q = PhysicalSoftwareQuestionnaire(
            hasBox: true,
            hasManual: false,
            hasMedia: true
        )
        
        let tags = q.generateTags()
        // Should NOT be CIB, should NOT be Loose.
        XCTAssertFalse(tags.contains(TagType.Condition.cib.rawValue))
        XCTAssertFalse(tags.contains(TagType.Condition.loose.rawValue))
    }
    
    // MARK: - Digital Software Scenarios
    
    func testDigital_CrackedGame() {
        // Scenario: Prince of Persia (Cracked by 4am)
        var q = DigitalSoftwareQuestionnaire()
        q.format = .diskImage // DSK
        q.isCracked = true
        q.hasTrainer = true
        q.region = "USA"
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Format.diskImage.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.cracked.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.trainer.rawValue))
        XCTAssertTrue(tags.contains("region:usa"))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["is_cracked"], "true")
        XCTAssertEqual(attrs["region"], "USA")
        
        XCTAssertNotNil(q.localizedQuestions["isCracked"])
        XCTAssertEqual(q.targetClassifier, .software) // Digital defaults to .software or user defined? code says default param is .software
    }
    
    func testDigital_FluxPreservation() {
        // Scenario: Oregon Trail - Raw Flux Dump (WOZ) - Verified
        let q = DigitalSoftwareQuestionnaire(
            classifier: .software,
            format: .fluxImage, // WOZ
            isCracked: false,
            isVerifiedClean: true, // TOSEC match
            isOriginalDump: true // I dumped it myself
        )
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Format.fluxImage.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.verifiedClean.rawValue))
        XCTAssertTrue(tags.contains(TagType.DigitalState.originalDump.rawValue))
        XCTAssertFalse(tags.contains(TagType.DigitalState.cracked.rawValue))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["format_type"], "Flux Image")
        XCTAssertEqual(attrs["is_original_dump"], "true")
    }
}
