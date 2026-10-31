import Foundation
import InventoryTypes

public extension InventoryFormattingStrategies {
    
    /// Strategy to correct names from a table of lowercased names and their corrections.
    ///
    /// `init()` uses a built-in table of retro-computing names (e.g. "broderbund" -> "Brøderbund"),
    /// which moves to RetroData in InventoryKit 3.0, when the default becomes an empty table.
    /// Pass your own table with `init(corrections:)`.
    struct NameCorrectionStrategy: FormattingStrategy {
        
        private let corrections: [String: String]

        /// The built-in retro-computing table used by `init()` in 2.x.
        static let builtInCorrections: [String: String] = [
            // Manufacturers
            "broderbund": "Brøderbund",
            "broderbund software": "Brøderbund Software",
            "electronic arts": "Electronic Arts",
            "ea": "Electronic Arts",
            "ssi": "Strategic Simulations Inc.",
            "sublogic": "subLOGIC",
            "microprose": "MicroProse",
            
            // Products
            "choplifter": "Choplifter",
            "lode runner": "Lode Runner",
            "karateka": "Karateka"
        ]
        
        /// Uses the built-in retro-computing table (2.x behavior; empty in 3.0).
        public init() {
            self.corrections = Self.builtInCorrections
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
