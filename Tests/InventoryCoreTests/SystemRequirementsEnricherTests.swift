import XCTest
import InventoryCore

final class SystemRequirementsEnricherTests: XCTestCase {
    
    // Mock Product for testing
    struct SimpleProduct: InventoryProduct {
        var id = UUID()
        var sku: String?
        var identifiers: [any InventoryIdentifier] = []
        var title: String = "Test Product"
        var description: String?
        var productType: String?
        var classification: String?
        var genre: String?
        var manufacturer: (any InventoryManufacturer)?
        var publisher: String?
        var developer: String?
        var creator: String?
        var releaseDate: Date?
        var productionDate: Date?
        var platform: String?
        var systemRequirements: InventorySystemRequirements?
        var version: String?
        var instanceIDs: [UUID] = []
        var artworkIDs: [UUID] = []
        var screenshotIDs: [UUID] = []
        var instructionIDs: [UUID] = []
        var collectionIDs: [UUID] = []
        var references: [String : String] = [:]
        var metadata: [String : String] = [:]
    }
    
    func testHeuristicStrategy_Pre1983() {
        let strategy = HeuristicEnrichmentStrategy()
        
        var product = SimpleProduct()
        // 1982
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1982))
        product.releaseDate = date
        
        let result = strategy.enrich(product: product)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.minMemory, 48 * 1024)
        XCTAssertEqual(result?.cpuFamily, "6502")
    }
    
    func testHeuristicStrategy_1985() {
        let strategy = HeuristicEnrichmentStrategy()
        
        var product = SimpleProduct()
        // 1985
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1985))
        product.releaseDate = date
        
        let result = strategy.enrich(product: product)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.minMemory, 64 * 1024)
        XCTAssertEqual(result?.cpuFamily, "65C02")
    }
    
    func testHeuristicStrategy_1988() {
        let strategy = HeuristicEnrichmentStrategy()
        
        var product = SimpleProduct()
        // 1988
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1988))
        product.releaseDate = date
        
        let result = strategy.enrich(product: product)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.minMemory, 256 * 1024)
        XCTAssertEqual(result?.cpuFamily, "65816")
    }
    
    func testEnricherPriority() {
        // Create a mock strategy that always returns specific reqs
        struct FixedStrategy: SystemRequirementsEnrichmentStrategy {
            func enrich(product: any InventoryProduct) -> InventorySystemRequirements? {
                return InventorySystemRequirements(minMemory: 999)
            }
        }
        
        // Strategy 1 (Fixed) should win over Strategy 2 (Heuristic)
        let enricher = SystemRequirementsEnricher(strategies: [
            FixedStrategy(),
            HeuristicEnrichmentStrategy()
        ])
        
        var product = SimpleProduct()
        product.releaseDate = Date() // Would normally trigger heuristic
        
        let result = enricher.enrich(product: product)
        
        XCTAssertEqual(result?.minMemory, 999)
    }
}
