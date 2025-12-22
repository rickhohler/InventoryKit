import XCTest
import InventoryCore
@testable import InventoryKit

final class StandardAssetFactoryTests: XCTestCase {
    
    func testCreateAsset_Success() throws {
        let factory = StandardAssetFactory()
        let id = UUID()
        let name = "Factory Asset"
        let provenance = "Unit Test"
        let tags = ["Tag1"]
        
        // Act
        let asset = try factory.createAsset(id: id, name: name, provenance: provenance, tags: tags)
        
        // Assert
        XCTAssertEqual(asset.id, id)
        XCTAssertEqual(asset.name, name)
        XCTAssertEqual(asset.provenance, provenance)
        XCTAssertTrue(asset.tags.contains("Tag1"))
        XCTAssertTrue(asset.tags.contains("Created via Factory"))
    }
    
    func testCreateAsset_WithValidator_Failure() {
        // Setup a validator that always fails or has strict rules
        struct FailValidator: InventoryValidationStrategy {
            func validate(_ asset: any InventoryAsset) throws {
                throw InventoryValidationError.businessRuleViolation(rule: "Fail Always")
            }
        }
        
        let factory = StandardAssetFactory(validator: FailValidator())
        let id = UUID()
        
        // Act & Assert
        XCTAssertThrowsError(try factory.createAsset(id: id, name: "Test", provenance: "Test", tags: [])) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .businessRuleViolation(let rule) = validationError else {
                XCTFail("Wrong error type")
                return
            }
            XCTAssertEqual(rule, "Fail Always")
        }
    }
}
