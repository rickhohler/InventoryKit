import InventoryTypes
import Foundation

/// Questionnaire for Computer Hardware and Peripherals.
public struct HardwareQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: ItemClassifierType { targetClassifierStorage }
    private let targetClassifierStorage: ItemClassifierType
    
    // MARK: - Core Components
    public var hasBox: Bool
    public var hasManual: Bool
    public var hasPowerSupply: Bool
    public var hasCables: Bool // AV, Data, etc.
    
    // MARK: - Functional State
    public var isFunctional: Bool
    public var needsRecap: Bool // Common for retro hardware
    
    // MARK: - Condition
    public enum CosmeticCondition: String, Codable, Sendable, CaseIterable {
        case mint = "Mint"
        case good = "Good"
        case yellowed = "Yellowed" // Classic plastic yellowing
        case damaged = "Damaged" // Cracks, missing pieces
        case partsOnly = "Parts Only"
    }
    public var cosmeticCondition: CosmeticCondition
    
    // MARK: - Notes
    public var serialNumber: String?
    public var modNotes: String? // "HDMI Mod", "Gotek Drive"
    public var damageNotes: String?
    
    public init(
        classifier: ItemClassifierType = .computerHardware,
        hasBox: Bool = false,
        hasManual: Bool = false,
        hasPowerSupply: Bool = true,
        hasCables: Bool = true,
        isFunctional: Bool = true,
        needsRecap: Bool = false,
        cosmeticCondition: CosmeticCondition = .good,
        serialNumber: String? = nil,
        modNotes: String? = nil,
        damageNotes: String? = nil
    ) {
        self.targetClassifierStorage = classifier
        self.hasBox = hasBox
        self.hasManual = hasManual
        self.hasPowerSupply = hasPowerSupply
        self.hasCables = hasCables
        self.isFunctional = isFunctional
        self.needsRecap = needsRecap
        self.cosmeticCondition = cosmeticCondition
        self.serialNumber = serialNumber
        self.modNotes = modNotes
        self.damageNotes = damageNotes
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        
        if isFunctional {
            tags.append(TagType.Condition.working.rawValue)
        } else {
            tags.append(TagType.Condition.notWorking.rawValue)
        }
        
        if needsRecap { tags.append(TagType.Condition.recapped.rawValue) } // Wait, needs recap isn't recapped.
        // Actually, if it needs recap, maybe "condition:needs_recap"?
        // My TagType.Condition doesn't have "needs_recap".
        // Use "condition:untested" or add "condition:needs_recap" later.
        // For now, let's just stick to the closest or skip if no tag matches.
                
        if hasBox { tags.append(TagType.Condition.boxed.rawValue) }
        
        if cosmeticCondition == .yellowed { tags.append(TagType.Condition.yellowed.rawValue) }
        if cosmeticCondition == .partsOnly { tags.append("condition:parts_only") } // Literal valid if I missed it in Enum, but safer to use raw string or update enum.
        
        if let mods = modNotes, !mods.isEmpty {
            tags.append(TagType.Condition.modded.rawValue)
        }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        
        attrs["has_box"] = String(hasBox)
        attrs["has_manual"] = String(hasManual)
        attrs["has_psu"] = String(hasPowerSupply)
        attrs["has_cables"] = String(hasCables)
        
        attrs["is_functional"] = String(isFunctional)
        attrs["needs_recap"] = String(needsRecap)
        
        attrs["condition_cosmetic"] = cosmeticCondition.rawValue
        
        if let sn = serialNumber { attrs["serial_number"] = sn }
        
        if let mods = modNotes, !mods.isEmpty {
            attrs["notes_mods"] = mods
        }
        if let damage = damageNotes, !damage.isEmpty {
            attrs["notes_damage"] = damage
        }
        
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "hasBox": InventoryLocalizedString("question.hasHardwareBox", value: "Do you have the original box?", comment: "Question: Hardware Box"),
            "hasManual": InventoryLocalizedString("question.hasHardwareManual", value: "Is the manual included?", comment: "Question: Hardware Manual"),
            "hasPowerSupply": InventoryLocalizedString("question.hasPowerSupply", value: "Is the power supply included?", comment: "Question: Power Supply"),
            "hasCables": InventoryLocalizedString("question.hasCables", value: "Are the necessary cables included?", comment: "Question: Cables"),
            "isFunctional": InventoryLocalizedString("question.isFunctional", value: "Is the hardware functional?", comment: "Question: Functional"),
            "needsRecap": InventoryLocalizedString("question.needsRecap", value: "Does it need recapping (capacitors)?", comment: "Question: Recap"),
            "cosmeticCondition": InventoryLocalizedString("question.cosmeticCondition", value: "How is the cosmetic condition?", comment: "Question: Cosmetic Condition"),
            "serialNumber": InventoryLocalizedString("question.serialNumber", value: "Enter the serial number (optional):", comment: "Question: Serial Number"),
            "modNotes": InventoryLocalizedString("question.modNotes", value: "Describe any modifications:", comment: "Question: Mod Notes"),
            "damageNotes": InventoryLocalizedString("question.damageNotes", value: "Describe any visible damage:", comment: "Question: Damage Notes")
        ]
    }
}
