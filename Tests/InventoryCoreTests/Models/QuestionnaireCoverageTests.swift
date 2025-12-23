import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class QuestionnaireCoverageTests: XCTestCase {
    
    // MARK: - Software Publisher
    
    func testSoftwarePublisherQuestionnaire() {
        // Test defaults
        let qDefault = SoftwarePublisherQuestionnaire()
        XCTAssertFalse(qDefault.isIndie)
        XCTAssertEqual(qDefault.status, .defunct)
        XCTAssertNil(qDefault.primaryRegion)
        
        let tagsDefault = qDefault.generateTags()
        XCTAssertTrue(tagsDefault.contains("type:publisher"))
        XCTAssertTrue(tagsDefault.contains("status:defunct"))
        
        // Test custom init
        let qCustom = SoftwarePublisherQuestionnaire(
            isIndie: true,
            primaryRegion: "USA",
            notablePlatforms: ["Apple II", "C64"],
            status: .active
        )
        
        let tagsCustom = qCustom.generateTags()
        XCTAssertTrue(tagsCustom.contains("type:publisher"))
        XCTAssertTrue(tagsCustom.contains("status:indie"))
        XCTAssertTrue(tagsCustom.contains("status:active"))
        XCTAssertTrue(tagsCustom.contains("platform:apple ii"))
        XCTAssertTrue(tagsCustom.contains("platform:c64"))
        
        let attrs = qCustom.generateAttributes()
        XCTAssertEqual(attrs["type"], "Software Publisher")
        XCTAssertEqual(attrs["is_indie"], "true")
        XCTAssertEqual(attrs["status"], "Active")
        XCTAssertEqual(attrs["region"], "USA")
        XCTAssertTrue(attrs["platforms"]!.contains("Apple II"))
        
        XCTAssertFalse(qCustom.localizedQuestions.isEmpty)
        
        // Test Enum Coverage
        for s in SoftwarePublisherQuestionnaire.CompanyStatus.allCases {
            XCTAssertFalse(s.rawValue.isEmpty)
        }
    }
    
    // MARK: - Hardware Manufacturer
    
    func testHardwareManufacturerQuestionnaire() {
        // Test defaults
        let qDefault = HardwareManufacturerQuestionnaire()
        XCTAssertEqual(qDefault.manufacturerType, .peripherals)
        XCTAssertEqual(qDefault.status, .defunct)
        
        let tagsDefault = qDefault.generateTags()
        XCTAssertTrue(tagsDefault.contains("type:hardware_mfg"))
        XCTAssertTrue(tagsDefault.contains("type:peripheral"))
        XCTAssertTrue(tagsDefault.contains("status:defunct"))
        
        // Test custom
        let qCustom = HardwareManufacturerQuestionnaire(
            manufacturerType: .computer,
            primaryRegion: "Japan",
            status: .acquired
        )
        
        let tagsCustom = qCustom.generateTags()
        XCTAssertTrue(tagsCustom.contains("type:computer"))
        XCTAssertTrue(tagsCustom.contains("status:acquired"))
        
        let attrs = qCustom.generateAttributes()
        XCTAssertEqual(attrs["type"], "Hardware Manufacturer")
        XCTAssertEqual(attrs["hardware_category"], HardwareManufacturerQuestionnaire.HardwareType.computer.rawValue)
        XCTAssertEqual(attrs["region"], "Japan")
        
        XCTAssertFalse(qCustom.localizedQuestions.isEmpty)
        
        // Test Enum Coverage
        for s in HardwareManufacturerQuestionnaire.CompanyStatus.allCases {
            XCTAssertFalse(s.rawValue.isEmpty)
        }
        for t in HardwareManufacturerQuestionnaire.HardwareType.allCases {
            XCTAssertFalse(t.rawValue.isEmpty)
        }
    }
    
    // MARK: - Peripheral Questionnaire
    
    func testPeripheralQuestionnaire() {
        // Defaults
        let qDefault = PeripheralQuestionnaire()
        XCTAssertEqual(qDefault.interface, .usb)
        XCTAssertFalse(qDefault.isWireless)
        XCTAssertEqual(qDefault.targetClassifier, .peripheral)
        
        let tagsDefault = qDefault.generateTags()
        XCTAssertTrue(tagsDefault.contains("interface:usb"))
        XCTAssertTrue(tagsDefault.contains("condition:good"))
        XCTAssertTrue(tagsDefault.contains("condition:working"))
        
        // Custom
        let qCustom = PeripheralQuestionnaire(
            interface: .adb,
            requiresDrivers: true,
            isWireless: true,
            compatibility: ["Mac"],
            condition: .cib,
            isFunctional: false
        )
        
        // Check attributes
        let attrs = qCustom.generateAttributes()
        XCTAssertEqual(attrs["interface"], "interface:adb")
        XCTAssertEqual(attrs["is_wireless"], "true")
        XCTAssertEqual(attrs["requires_drivers"], "true")
        XCTAssertEqual(attrs["is_functional"], "false")
        XCTAssertEqual(attrs["compatibility"], "Mac")
        
        // Check Tags
        let tags = qCustom.generateTags()
        XCTAssertTrue(tags.contains("interface:adb"))
        XCTAssertTrue(tags.contains("feature:wireless"))
        XCTAssertTrue(tags.contains("req:drivers"))
        XCTAssertTrue(tags.contains("condition:cib"))
        XCTAssertTrue(tags.contains("condition:not_working"))
        XCTAssertTrue(tags.contains("compat:mac"))
        
        XCTAssertFalse(qCustom.localizedQuestions.isEmpty)
    }
    
    // MARK: - Physical Item Questionnaire
    
    func testPhysicalItemQuestionnaire_Valid() {
        let q = PhysicalItemQuestionnaire(
            classifier: .storageContainer,
            material: .wood,
            condition: .fair,
            primaryColor: "Brown"
        )
        
        XCTAssertEqual(q.targetClassifier, .storageContainer)
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains("material:wood"))
        XCTAssertTrue(tags.contains("condition:fair"))
        XCTAssertTrue(tags.contains("color:brown"))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["material"], "material:wood")
        XCTAssertEqual(attrs["color"], "Brown")
        
        XCTAssertFalse(q.localizedQuestions.isEmpty)
    }
    
    // MARK: - Publication Questionnaire
    
    func testPublicationQuestionnaire() {
        let q = PublicationQuestionnaire(
            title: "Swift Guide",
            author: "Apple",
            isbn: "12345",
            publicationYear: 2014,
            pageCount: 500,
            binding: .digitalPDF
        )
        
        XCTAssertEqual(q.targetClassifier, .document)
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains("format:pdf"))
        XCTAssertTrue(tags.contains("vintage")) // logic says if year != nil append vintage
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["title"], "Swift Guide")
        XCTAssertEqual(attrs["author"], "Apple")
        XCTAssertEqual(attrs["isbn"], "12345")
        XCTAssertEqual(attrs["year"], "2014")
        XCTAssertEqual(attrs["page_count"], "500")
        XCTAssertEqual(attrs["binding"], "format:pdf")
        
        XCTAssertFalse(q.localizedQuestions.isEmpty)
    }
}
