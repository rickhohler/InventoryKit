import Foundation

public extension InventoryFormattingStrategies {
    
    /// Basic string cleaning strategy.
    /// Performs trimming of whitespace/newlines and Unicode normalization.
    struct BasicCleanupStrategy: FormattingStrategy {
        
        public init() {}
        
        public func format(_ value: String) -> String {
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
                .precomposedStringWithCanonicalMapping
        }
    }
}
