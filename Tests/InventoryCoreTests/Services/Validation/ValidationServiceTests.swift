import XCTest
import InventoryCore
import InventoryTypes

final class ValidationServiceTests: XCTestCase {
    
    func testSystemRequirementsValidation() {
        let context = MockContext()
        let service = InventoryValidationService(context: context)
        
        // 1. Valid Case
        let validReqs = MockSystemRequirements(minMemory: 1024, recommendedMemory: 2048)
        let validRes = service.validate(validReqs)
        XCTAssertTrue(validRes.isValid)
        XCTAssertTrue(validRes.errors.isEmpty)
        XCTAssertTrue(validRes.warnings.isEmpty)
        
        // 2. Logic Warning (Rec < Min)
        let weirdReqs = MockSystemRequirements(minMemory: 2048, recommendedMemory: 1024)
        let weirdRes = service.validate(weirdReqs)
        XCTAssertTrue(weirdRes.isValid) // Technically valid, but warns
        XCTAssertTrue(weirdRes.warnings.contains("Recommended memory is less than minimum memory."))
        
        // 3. Error Case (Negative Memory)
        let badReqs = MockSystemRequirements(minMemory: -500)
        let badRes = service.validate(badReqs)
        XCTAssertFalse(badRes.isValid)
        XCTAssertFalse(badRes.errors.isEmpty)
    }
}
