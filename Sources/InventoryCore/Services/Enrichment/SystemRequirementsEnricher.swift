import Foundation
import InventoryTypes

/// Orchestrates system requirements enrichment by iterating through registered strategies.
/// Strategies should be ordered by priority (e.g., Verified > Computed > Inferred).
public struct SystemRequirementsEnricher {
    
    private let strategies: [any SystemRequirementsEnrichmentStrategy]
    
    /// Initializes the enricher with a list of strategies.
    /// - Parameter strategies: Ordered list of strategies. First non-nil result wins.
    public init(strategies: [any SystemRequirementsEnrichmentStrategy]) {
        self.strategies = strategies
    }
    
    /// Enriches the product with system requirements using the configured strategies.
    /// - Parameter product: The product to enrich.
    /// - Returns: The first non-nil `InventorySystemRequirements` found, or nil if none succeed.
    public func enrich(product: any Product) -> InventorySystemRequirements? {
        for strategy in strategies {
            if let result = strategy.enrich(product: product) {
                return result
            }
        }
        return nil
    }
}
