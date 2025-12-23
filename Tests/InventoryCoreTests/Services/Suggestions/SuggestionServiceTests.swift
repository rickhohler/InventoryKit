import XCTest
import InventoryCore
import InventoryTypes

final class SuggestionServiceTests: XCTestCase {
    
    func testManufacturerSuggestion() async {
        let context = MockContext()
        let service = SuggestionService(context: context)
        
        // Input: "Apple"
        let suggestions = await service.suggestManufacturers(for: "Apple")
        
        // Assert: Should find "Apple Computer, Inc."
        XCTAssertFalse(suggestions.isEmpty)
        XCTAssertEqual(suggestions.first?.suggestedValue, "Apple Computer, Inc.")
        XCTAssertGreaterThanOrEqual(suggestions.first!.confidence, 0.8)
    }
    
    func testManufacturerEnrichment() async {
        let context = MockContext()
        let service = SuggestionService(context: context)
        
        // Input: "Apple"
        var manufacturer = MockReferenceManufacturer(slug: "apple", name: "Apple")
        
        // Action: Enrich
        await service.enrichManufacturer(&manufacturer)
        
        // Assert: Should auto-complete to "Apple Computer, Inc."
        XCTAssertEqual(manufacturer.name, "Apple Computer, Inc.")
    }
}
