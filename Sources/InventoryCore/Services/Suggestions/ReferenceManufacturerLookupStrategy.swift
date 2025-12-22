import Foundation

/// Strategy to suggest manufacturers from a reference list (Simulated).
/// In a real app, this would query Core Data or a web API.
public struct ReferenceManufacturerLookupStrategy: SuggestionStrategy {
    
    // Simulated Database
    private let knownManufacturers = [
        "Apple Computer, Inc.",
        "Commodore Business Machines",
        "Atari Corporation",
        "Sinclair Research Ltd.",
        "Brøderbund Software, Inc.",
        "Electronic Arts"
    ]
    
    public init() {}
    
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
