import XCTest
import InventoryCore
@testable import InventoryCoreTests

final class SystemRequirementsEnricherTests: XCTestCase {
    
    // Using MockProduct from InventoryCoreTests module
    
    func testHeuristicStrategy_Pre1983() {
        let strategy = AppleIIEnrichmentStrategy()
        
        // 1982
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1982))
        let product = MockProduct(title: "Test Product", releaseDate: date)
        
        let result = strategy.enrich(product: product)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.minMemory, 48 * 1024)
        XCTAssertEqual(result?.cpuFamily, "6502")
    }
    
    func testHeuristicStrategy_1985() {
        let strategy = AppleIIEnrichmentStrategy()
        
        // 1985
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1985))
        let product = MockProduct(title: "Test Product", releaseDate: date)
        
        let result = strategy.enrich(product: product)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.minMemory, 64 * 1024)
        XCTAssertEqual(result?.cpuFamily, "65C02")
    }
    
    func testHeuristicStrategy_1988() {
        let strategy = AppleIIEnrichmentStrategy()
        
        // 1988
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1988))
        let product = MockProduct(title: "Test Product", releaseDate: date)
        
        let result = strategy.enrich(product: product)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.minMemory, 256 * 1024)
        XCTAssertEqual(result?.cpuFamily, "65816")
    }
    
    func testEnricherPriority() {
        // Create a mock strategy that always returns specific reqs
        struct FixedStrategy: SystemRequirementsEnrichmentStrategy {
            func enrich(product: any InventoryProduct) -> InventorySystemRequirements? {
                return MockSystemRequirements(minMemory: 999)
            }
        }
        
        // Strategy 1 (Fixed) should win over Strategy 2 (Heuristic)
        let enricher = SystemRequirementsEnricher(strategies: [
            FixedStrategy(),
            AppleIIEnrichmentStrategy()
        ])
        
        let product = MockProduct(title: "Test Product", releaseDate: Date())
        
        let result = enricher.enrich(product: product)
        
        XCTAssertEqual(result?.minMemory, 999)
    }
}
