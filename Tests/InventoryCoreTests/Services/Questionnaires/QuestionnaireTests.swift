import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class QuestionnaireTests: XCTestCase {
    
    func testHardwareQuestionnaire_C64Restoration() {
        // Scenario: User found an old Commodore 64 in the attic.
        // It has a box, cables, but is yellowed and needs a recap.
        
        var questionnaire = HardwareQuestionnaire(
            classifier: .computerHardware,
            hasBox: true,
            hasManual: false,
            hasPowerSupply: true,
            hasCables: true
        )
        
        // User inspects condition directly
        questionnaire.cosmeticCondition = .yellowed
        questionnaire.isFunctional = false // Won't turn on
        questionnaire.needsRecap = true // Black screen, common issue
        questionnaire.serialNumber = "C64-12345"
        questionnaire.damageNotes = "Missing 'W' key cap"
        
        // Verify Tags Generation
        let tags = questionnaire.generateTags()
        
        // Expect specific tags based on answers
        XCTAssertTrue(tags.contains(TagType.Condition.boxed.rawValue), "Should be boxed")
        XCTAssertTrue(tags.contains(TagType.Condition.yellowed.rawValue), "Should be yellowed")
        XCTAssertTrue(tags.contains(TagType.Condition.notWorking.rawValue), "Should be not working")
        
        // Verify Attributes for Metadata
        let attrs = questionnaire.generateAttributes()
        
        XCTAssertEqual(attrs["has_box"], "true")
        XCTAssertEqual(attrs["has_manual"], "false")
        XCTAssertEqual(attrs["condition_cosmetic"], "Yellowed")
        XCTAssertEqual(attrs["serial_number"], "C64-12345")
        XCTAssertEqual(attrs["notes_damage"], "Missing 'W' key cap")
        
        // Verify Localized Questions (Just ensuring keys exist)
        let questions = questionnaire.localizedQuestions
        XCTAssertNotNil(questions["needsRecap"])
    }
    
    func testHardwareQuestionnaire_MintInBox() {
        // Scenario: A perfect condition new-old-stock item
        let questionnaire = HardwareQuestionnaire(
            classifier: .peripheral,
            hasBox: true,
            hasManual: true,
            hasPowerSupply: false, // USB powered maybe?
            hasCables: true,
            isFunctional: true,
            needsRecap: false,
            cosmeticCondition: .mint
        )
        
        let tags = questionnaire.generateTags()
        XCTAssertTrue(tags.contains(TagType.Condition.working.rawValue))
        XCTAssertTrue(tags.contains(TagType.Condition.boxed.rawValue))
        
        let attrs = questionnaire.generateAttributes()
        XCTAssertEqual(attrs["condition_cosmetic"], "Mint")
        XCTAssertNil(attrs["notes_damage"])
        
        XCTAssertEqual(questionnaire.targetClassifier, .peripheral)
    }
    
    func testHardwareQuestionnaire_ModdedConsole() {
        // Scenario: A modded Game Boy
        var q = HardwareQuestionnaire()
        q.isFunctional = true
        q.modNotes = "IPS Screen, USB-C Charging"
        q.cosmeticCondition = .good
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains(TagType.Condition.modded.rawValue))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["notes_mods"], "IPS Screen, USB-C Charging")
    }
}
