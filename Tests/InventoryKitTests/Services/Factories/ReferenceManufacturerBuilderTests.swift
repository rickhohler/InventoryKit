import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class ReferenceManufacturerBuilderTests: XCTestCase {
    
    struct MockQuestionnaire: ManufacturerQuestionnaire {
        func generateAttributes() -> [String : String] {
            return ["Source": "Questionnaire"]
        }
        func generateTags() -> [String] { return [] }
        var localizedQuestions: [String : String] { return [:] }
    }

    func testBuild_Success() throws {
        let builder = ReferenceManufacturerBuilder(name: "Nintendo")
        let url = URL(string: "https://nintendo.com")!
        let id = UUID()
        
        let mfg = try builder
            .setID(id)
            .addAlias("Big N")
            .setWebsite(url)
            .setDescription("Gaming Giant")
            .addMetadata("HQ", "Kyoto")
            .build()
        
        XCTAssertEqual(mfg.id, id)
        XCTAssertEqual(mfg.name, "Nintendo")
        XCTAssertEqual(mfg.aliases.contains("Big N"), true)
        XCTAssertEqual(mfg.aliases.contains("Big N"), true)
        // Website is not in public protocol
        XCTAssertEqual(mfg.description, "Gaming Giant")
        XCTAssertEqual(mfg.metadata["HQ"], "Kyoto")
        XCTAssertEqual(mfg.slug, "nintendo")
    }
    
    func testApplyQuestionnaire() throws {
        let builder = ReferenceManufacturerBuilder(name: "Sega")
        let mfg = try builder
            .applyQuestionnaire(MockQuestionnaire())
            .build()
        
        XCTAssertEqual(mfg.metadata["Source"], "Questionnaire")
    }
    
    func testBuild_EmptyName_Throws() {
        let builder = ReferenceManufacturerBuilder(name: "   ")
        
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .missingRequiredField(let field, _) = validationError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(field, "name")
        }
    }
}
