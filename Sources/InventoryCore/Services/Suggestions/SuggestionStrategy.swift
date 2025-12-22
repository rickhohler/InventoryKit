import Foundation

/// A suggestion for a correction or enhancement.
public struct InventorySuggestion: Sendable, Equatable {
    public let originalValue: String
    public let suggestedValue: String
    public let confidence: Double // 0.0 to 1.0
    public let source: String // e.g. "Reference Database"
    
    public init(original: String, suggested: String, confidence: Double, source: String) {
        self.originalValue = original
        self.suggestedValue = suggested
        self.confidence = confidence
        self.source = source
    }
}

/// A strategy for suggesting improvements or valid entities based on input.
public protocol SuggestionStrategy: Sendable {
    /// Suggests valid entities matching the query.
    /// - Parameter query: The user input or current value.
    /// - Returns: A list of suggestions.
    func suggest(for query: String) async -> [InventorySuggestion]
}
