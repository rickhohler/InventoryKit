import XCTest
import InventoryCore
import InventoryTypes

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
    
    func testEmptyString() {
        let context = MockContext()
        let service = FormattingService(context: context)
        var contact = MockContact(name: "")
        service.formatContact(&contact)
        XCTAssertEqual(contact.name, "")
    }
    
    func testSpecialCharacters() {
        let context = MockContext()
        let service = FormattingService(context: context)
        // Ensure standard characters are preserved unless they map to something else
        var contact = MockContact(name: "A.C.E.")
        service.formatContact(&contact)
        XCTAssertEqual(contact.name, "A.C.E.")
        XCTAssertEqual(contact.name, "A.C.E.")
    }
    
    // MARK: - Manufacturer Tests
    
    struct LocalMockManufacturer: Manufacturer {
        var id: UUID = UUID()
        var slug: String = "test"
        var name: String
        var aliases: [String] = []
        var alsoKnownAs: [String] = []
        var alternativeSpellings: [String] = []
        var commonMisspellings: [String] = []
        var addresses: [any Address] = []
        var email: String?
        var associatedPeople: [any Contact] = []
        var developers: [any Contact] = []
        var description: String?
        var metadata: [String : String] = [:]
    }
    
    struct MockFormattingStrategy: FormattingStrategy {
        func format(_ value: String) -> String {
            return "Fixed Name"
        }
    }

    func testFormatManufacturer_Change() {
        let context = MockContext()
        let strategy = MockFormattingStrategy()
        let service = FormattingService(context: context, nameStrategy: strategy)
        
        var mfg = LocalMockManufacturer(name: "Bad Name")
        service.format(&mfg)
        
        XCTAssertEqual(mfg.name, "Fixed Name")
        // Check side effect on configurator
        XCTAssertNotNil((context.configurator as? MockConfigurator)?.configuredManufacturers[mfg.id])
    }
    
    func testFormatManufacturer_NoChange() {
        let context = MockContext()
        let service = FormattingService(context: context)
        
        var mfg = LocalMockManufacturer(name: "Sierra")
        service.format(&mfg)
        
        XCTAssertEqual(mfg.name, "Sierra")
        // Should NOT configure. Note: if casting fails, we might get nil anyway, but we check specific dictionary logic
        if let config = context.configurator as? MockConfigurator {
             XCTAssertNil(config.configuredManufacturers[mfg.id])
        }
    }
}
