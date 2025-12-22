import XCTest
import InventoryCore

final class AssetQuestionnaireTests: XCTestCase {
    
    // MARK: - Software Questionnaire
    
    func testPhysicalSoftwareQuestionnaire_CIB() {
        let q = PhysicalSoftwareQuestionnaire(
            hasBox: true,
            hasManual: true,
            hasMedia: true,
            overallCondition: .good
        )
        
        let tags = q.generateTags()
        let attrs = q.generateAttributes()
        
        XCTAssertTrue(tags.contains("CIB"))
        XCTAssertEqual(attrs["condition_grade"], "Good")
        XCTAssertEqual(attrs["has_box"], "true")
    }
    
    func testPhysicalSoftwareQuestionnaire_Loose() {
        let q = PhysicalSoftwareQuestionnaire(
            hasBox: false,
            hasManual: false,
            hasMedia: true,
            overallCondition: .loose,
            damageNotes: "Label peeling"
        )
        
        let tags = q.generateTags()
        let attrs = q.generateAttributes()
        
        XCTAssertTrue(tags.contains("Loose"))
        XCTAssertFalse(tags.contains("CIB"))
        XCTAssertEqual(attrs["notes_damage"], "Label peeling")
    }
    
    // MARK: - Hardware Questionnaire
    
    func testHardwareQuestionnaire_MintInBox() {
        let q = HardwareQuestionnaire(
            hasBox: true,
            hasManual: true,
            isFunctional: true,
            cosmeticCondition: .mint
        )
        
        let tags = q.generateTags()
        
        XCTAssertTrue(tags.contains("Working"), "Should be marked Working")
        XCTAssertTrue(tags.contains("Boxed"))
        // Mint condition doesn't generate a tag by default in my implementation (only Yellowed/PartsOnly)
        // But let's check attributes
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["condition_cosmetic"], "Mint")
    }
    
    func testHardwareQuestionnaire_Yellowed() {
        let q = HardwareQuestionnaire(
            isFunctional: true,
            cosmeticCondition: .yellowed,
            modNotes: "HDMI"
        )
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains("Yellowed"))
        XCTAssertTrue(tags.contains("Modded"))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["notes_mods"], "HDMI")
    }
}
