import Foundation
import InventoryTypes

public extension InventoryFormattingStrategies {
    
    /// Strategy to correct names from a table of names and their corrections, supplied by the
    /// client (for retro-computing names, RetroData's `RetroDataNameTables.nameCorrections`).
    struct NameCorrectionStrategy: FormattingStrategy {
        
        private let corrections: [String: String]

        /// An empty table: names are returned unchanged.
        public init() {
            self.corrections = [:]
        }

        /// Uses `corrections`, keyed by name; keys are matched case-insensitively and trimmed.
        public init(corrections: [String: String]) {
            var normalized: [String: String] = [:]
            for (key, value) in corrections {
                normalized[key.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)] = value
            }
            self.corrections = normalized
        }
        
        public func format(_ value: String) -> String {
            // Case-insensitive lookup
            let key = value.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            return corrections[key] ?? value
        }
    }
}
