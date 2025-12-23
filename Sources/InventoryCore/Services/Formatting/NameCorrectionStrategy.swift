import Foundation
import InventoryTypes

public extension InventoryFormattingStrategies {
    
    /// Strategy to correct common naming errors in retro computing (e.g. "broderbund" -> "Brøderbund").
    struct NameCorrectionStrategy: FormattingStrategy {
        
        private let corrections: [String: String] = [
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
        
        public init() {}
        
        public func format(_ value: String) -> String {
            // Case-insensitive lookup
            let key = value.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            return corrections[key] ?? value
        }
    }
}
