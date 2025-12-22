import Foundation

/// A strategy for formatting or correcting entity data.
/// adheres to SRP: This strategy only knows how to clean/format data, not validate or enrich it.
public protocol FormattingStrategy: Sendable {
    
    /// Formats the given string value (e.g. name correction).
    /// - Parameter value: The raw string value.
    /// - Returns: The formatted/corrected string, or the original if no change needed.
    func format(_ value: String) -> String
}

/// Namespace for Formatting Strategies
public enum InventoryFormattingStrategies {}
