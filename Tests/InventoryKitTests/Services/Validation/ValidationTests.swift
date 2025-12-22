import XCTest
import InventoryCore
@testable import InventoryKit

final class ValidationTests: XCTestCase {
    
    func testNameValidation() {
        let builder = UserInventoryItemBuilder(name: "   ") // Empty name
        
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .missingRequiredField(let field, _) = validationError else {
                XCTFail("Expected missingRequiredField error")
                return
            }
            XCTAssertEqual(field, "name")
        }
    }
    
    func testSoftwareValidator() {
        let builder = UserInventoryItemBuilder(name: "My Game")
            .withValidator(SoftwareValidator())
            .setType("hardware") // Wrong type
            
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .businessRuleViolation(let rule) = validationError else {
                XCTFail("Expected businessRuleViolation error")
                return
            }
            XCTAssertTrue(rule.contains("software"))
        }
    }
    
    func testHardwareValidator() {
        // Missing manufacturer
        let builder = UserInventoryItemBuilder(name: "My API Card")
            .withValidator(HardwareValidator())
            .setType("hardware")
            
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .missingRequiredField(let field, _) = validationError else {
                XCTFail("Expected missingRequiredField error")
                return
            }
            XCTAssertEqual(field, "manufacturer")
        } 
    }
    
    func testSuccessfulValidation() {
        struct MockValidationManufacturer: InventoryManufacturer {
            var id: UUID = UUID()
            var name: String = "Test Corp"
            var slug: String = "test-corp"
            var aliases: [String] = []
            var description: String? = nil
            var metadata: [String : String] = [:]
            
            // Extra protocol requirements
            var alsoKnownAs: [String] = []
            var alternativeSpellings: [String] = []
            var commonMisspellings: [String] = []
            var email: String? = nil
            var addresses: [any InventoryAddress] = []
            var associatedPeople: [any InventoryContact] = []
            var developers: [any InventoryContact] = []
            
            // Legacy/Private fields (optional but harmless)
            var country: String? = nil
            var website: URL? = nil
            var foundedYear: Int? = nil
            var dissolvedYear: Int? = nil
            var logo: (any InventoryItem)? = nil
        }
        
        let manufacturer = MockValidationManufacturer()
        let builder = UserInventoryItemBuilder(name: "Apple IIe")
            .withValidator(HardwareValidator())
            .setType("hardware")
            .setManufacturer(manufacturer)
            
        XCTAssertNoThrow(try builder.build())
    }
}
