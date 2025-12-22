import Foundation

/// Defines a strategy for enriching product data with system requirements.
public protocol SystemRequirementsEnrichmentStrategy {
    /// Attempts to determine system requirements for the given product.
    /// - Parameter product: The product to analyze.
    /// - Returns: Enriched requirements if determining them was possible, otherwise nil.
    func enrich(product: any InventoryProduct) -> InventorySystemRequirements?
}
