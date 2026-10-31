import Foundation
import InventoryTypes

/// Strategy to suggest manufacturers from a list of known names supplied by the client (for
/// retro computing, RetroData's `RetroDataNameTables.manufacturers`).
public struct ReferenceManufacturerLookupStrategy: SuggestionStrategy {
    
    private let knownManufacturers: [String]

    /// An empty list: nothing is suggested.
    public init() {
        self.knownManufacturers = []
    }

    /// Suggests from `knownManufacturers`.
    public init(knownManufacturers: [String]) {
        self.knownManufacturers = knownManufacturers
    }
    
    public func suggest(for query: String) async -> [InventorySuggestion] {
        let normalizedQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return knownManufacturers.compactMap { candidate in
            let normalizedCandidate = candidate.lowercased()
            
            // Exact Match (Unlikely to need suggestion, but confirming validity)
            if normalizedCandidate == normalizedQuery {
                return InventorySuggestion(original: query, suggested: candidate, confidence: 1.0, source: "Reference DB")
            }
            
            // Contains
            if normalizedCandidate.contains(normalizedQuery) {
                return InventorySuggestion(original: query, suggested: candidate, confidence: 0.8, source: "Reference DB")
            }
            
            return nil
        }
        .sorted { $0.confidence > $1.confidence }
    }
}
