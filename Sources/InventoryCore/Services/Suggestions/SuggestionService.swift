import Foundation
import InventoryTypes

/// Service responsible for Data Enrichment via suggestions.
///
/// The `SuggestionService` adheres to the **Single Responsibility Principle**:
/// It suggests better or more complete data (e.g., auto-completion, database lookups)
/// but does not strictly enforce formats or validation rules.
///
/// ## Usage
/// ```swift
/// let service = SuggestionService(context: context)
/// await service.enrichManufacturer(&manufacturer)
/// ```
public struct SuggestionService: Sendable {
    
    private let context: Context
    private let manufacturerStrategy: any SuggestionStrategy
    
    /// Creates a new suggestion service.
    /// - Parameters:
    ///   - context: The shared `Context`.
    ///   - manufacturerStrategy: Strategy for looking up manufacturers. Defaults to `ReferenceManufacturerLookupStrategy`.
    public init(
        context: Context,
        manufacturerStrategy: any SuggestionStrategy = ReferenceManufacturerLookupStrategy()
    ) {
        self.context = context
        self.manufacturerStrategy = manufacturerStrategy
    }
    
    /// Suggests valid manufacturers based on current input.
    /// - Parameter query: The search string (e.g. "Apl").
    /// - Returns: An array of `InventorySuggestion`.
    public func suggestManufacturers(for query: String) async -> [InventorySuggestion] {
        return await manufacturerStrategy.suggest(for: query)
    }
    
    /// Auto-completes/Enriches a Manufacturer if a high-confidence match is found.
    /// - Parameter manufacturer: The manufacturer entity to enrich (inout).
    public func enrichManufacturer<T: Manufacturer>(_ manufacturer: inout T) async {
        let suggestions = await suggestManufacturers(for: manufacturer.name)
        
        // Auto-accept if confidence is very high (e.g. 0.8+)
        if let bestMatch = suggestions.first, bestMatch.confidence >= 0.8 {
            if manufacturer.name != bestMatch.suggestedValue {
                 context.configurator.configure(
                    &manufacturer,
                    id: nil,
                    name: bestMatch.suggestedValue,
                    slug: manufacturer.slug,
                    description: manufacturer.description,
                    metadata: manufacturer.metadata,
                    aliases: manufacturer.aliases
                )
            }
        }
    }
    
    /// Auto-completes/Enriches a Contact representing a Manufacturer.
    /// - Parameter contact: The contact entity to enrich (inout).
    public func enrichContact<T: Contact>(_ contact: inout T) async {
        let suggestions = await suggestManufacturers(for: contact.name)
        
        if let bestMatch = suggestions.first, bestMatch.confidence >= 0.8 {
            if contact.name != bestMatch.suggestedValue {
                 context.configurator.configure(
                    &contact,
                    id: nil,
                    name: bestMatch.suggestedValue,
                    title: nil,
                    email: nil,
                    notes: nil,
                    socialMedia: contact.socialMedia
                )
            }
        }
    }
}
