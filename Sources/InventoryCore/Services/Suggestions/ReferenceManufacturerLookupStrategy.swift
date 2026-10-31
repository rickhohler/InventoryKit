import Foundation
import InventoryTypes

/// Strategy to suggest manufacturers from a list of known names.
///
/// `init()` uses a built-in list of six vintage-computing manufacturers, which moves to RetroData
/// in InventoryKit 3.0, when the default becomes an empty list. Pass your own list with
/// `init(knownManufacturers:)`.
public struct ReferenceManufacturerLookupStrategy: SuggestionStrategy {
    
    private let knownManufacturers: [String]

    /// The built-in list used by `init()` in 2.x.
    static let builtInManufacturers = [
        "Apple Computer, Inc.",
        "Commodore Business Machines",
        "Atari Corporation",
        "Sinclair Research Ltd.",
        "Brøderbund Software, Inc.",
        "Electronic Arts"
    ]
    
    /// Uses the built-in list (2.x behavior; empty in 3.0).
    public init() {
        self.knownManufacturers = Self.builtInManufacturers
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
