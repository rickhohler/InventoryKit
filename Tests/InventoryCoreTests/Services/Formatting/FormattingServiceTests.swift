import XCTest
import InventoryCore
@testable import InventoryCoreTests

final class FormattingServiceTests: XCTestCase {
    
    func testNameCorrection() {
        // Setup
        let context = MockContext()
        let service = FormattingService(context: context)
        
        // Input: "broderbund" (lowercase, wrong special char)
        var contact = MockContact(name: "broderbund")
        
        // Action
        service.formatContact(&contact)
        
        // Assert: "Brøderbund" (Corrected)
        XCTAssertEqual(contact.name, "Brøderbund")
    }
    
    func testNoChangeNeeded() {
        let context = MockContext()
        let service = FormattingService(context: context)
        
        var contact = MockContact(name: "Apple Computer")
        service.formatContact(&contact)
        
        XCTAssertEqual(contact.name, "Apple Computer")
    }
    
    func testTrimming() {
        // Our strategy does trimming too
        let context = MockContext()
        let service = FormattingService(context: context)
        
        var contact = MockContact(name: "  electronic arts  ")
        service.formatContact(&contact)
        
        XCTAssertEqual(contact.name, "Electronic Arts")
    }
}
