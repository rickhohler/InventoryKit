import Foundation
import InventoryCore
import InventoryTypes

/// The retro name table and manufacturer list InventoryKit had built in before 3.0 (they now live
/// in RetroData), injected where tests exercise corrections and suggestions.
enum TestNameTables {
    static let corrections: [String: String] = [
        "broderbund": "Brøderbund",
        "broderbund software": "Brøderbund Software",
        "electronic arts": "Electronic Arts",
        "ea": "Electronic Arts",
        "ssi": "Strategic Simulations Inc.",
        "sublogic": "subLOGIC",
        "microprose": "MicroProse",
        "choplifter": "Choplifter",
        "lode runner": "Lode Runner",
        "karateka": "Karateka",
    ]

    static let manufacturers = [
        "Apple Computer, Inc.",
        "Commodore Business Machines",
        "Atari Corporation",
        "Sinclair Research Ltd.",
        "Brøderbund Software, Inc.",
        "Electronic Arts",
    ]

    static func formatting(_ context: Context) -> FormattingService {
        FormattingService(context: context, nameStrategy: InventoryFormattingStrategies.NameCorrectionStrategy(corrections: corrections))
    }

    static func suggestions(_ context: Context) -> SuggestionService {
        SuggestionService(context: context, manufacturerStrategy: ReferenceManufacturerLookupStrategy(knownManufacturers: manufacturers))
    }
}
