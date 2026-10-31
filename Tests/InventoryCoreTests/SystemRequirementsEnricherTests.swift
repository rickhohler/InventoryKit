import XCTest
import InventoryCore
import InventoryTypes

/// `SystemRequirementsEnricher` asks its strategies in order. (Platform heuristics such as the
/// Apple II one live in the platform packages; RetroStorageApple tests theirs.)
final class SystemRequirementsEnricherTests: XCTestCase {

    private struct FixedStrategy: SystemRequirementsEnrichmentStrategy {
        let memory: Int64?
        func enrich(product: any Product) -> InventorySystemRequirements? {
            memory.map { MockSystemRequirements(minMemory: $0) }
        }
    }

    private let product = MockReferenceProduct(title: "Test Product", releaseDate: Date())

    func testFirstNonNilResultWins() {
        let enricher = SystemRequirementsEnricher(strategies: [FixedStrategy(memory: 999), FixedStrategy(memory: 1)])
        XCTAssertEqual(enricher.enrich(product: product)?.minMemory, 999)
    }

    func testStrategiesThatDeclineAreSkipped() {
        let enricher = SystemRequirementsEnricher(strategies: [FixedStrategy(memory: nil), FixedStrategy(memory: 64)])
        XCTAssertEqual(enricher.enrich(product: product)?.minMemory, 64)
    }

    func testNoStrategyNoRequirements() {
        XCTAssertNil(SystemRequirementsEnricher(strategies: []).enrich(product: product))
        XCTAssertNil(SystemRequirementsEnricher(strategies: [FixedStrategy(memory: nil)]).enrich(product: product))
    }
}
