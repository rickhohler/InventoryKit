import XCTest
import InventoryCore
@testable import InventoryCoreTests

final class HarvestedLogicTests: XCTestCase {
    
    func testBasicCleanupStrategy() {
        let strategy = InventoryFormattingStrategies.BasicCleanupStrategy()
        let input = "  Hello   World  \n"
        // Trimming + Normalization should preserve internal spacing but trim ends
        XCTAssertEqual(strategy.format(input), "Hello   World")
    }
    
    func testStrictKeyStrategy() {
        let strategy = InventoryFormattingStrategies.StrictKeyStrategy()
        let input = "My File_Name (v1).zip!" // ! is invalid
        XCTAssertEqual(strategy.format(input), "My File_Name (v1).zip")
    }
    
    func testURLValidator() {
        let validator = InventoryAppLogicValidators.URLStringValidator()
        
        // Valid
        XCTAssertTrue(validator.validate("https://google.com").isValid)
        XCTAssertTrue(validator.validate("ftp://archive.org").isValid)
        
        // Invalid Scheme
        let schemeRes = validator.validate("invalid://test")
        XCTAssertFalse(schemeRes.isValid)
        XCTAssertTrue(schemeRes.errors.first?.contains("Invalid URL scheme") ?? false)
        
        // Missing Host
        let hostRes = validator.validate("https://")
        XCTAssertFalse(hostRes.isValid)
        
        // Invalid Format
        XCTAssertFalse(validator.validate("Not A URL").isValid)
    }
    
    func testDateValidator() {
        let validator = InventoryAppLogicValidators.DateValidator()
        
        // Valid (Current)
        XCTAssertTrue(validator.validate(Date()).isValid)
        
        // Warning (Ancient)
        let ancient = Calendar.current.date(from: DateComponents(year: 1940))!
        let warnRes = validator.validate(ancient)
        XCTAssertTrue(warnRes.isValid)
        XCTAssertTrue(warnRes.warnings.first?.contains("suspiciously early") ?? false)
        
        // Error (Future)
        let future = Calendar.current.date(from: DateComponents(year: 3000))!
        let errRes = validator.validate(future)
        XCTAssertFalse(errRes.isValid)
    }
}
