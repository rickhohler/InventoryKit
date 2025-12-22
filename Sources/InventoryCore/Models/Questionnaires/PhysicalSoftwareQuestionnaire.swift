import Foundation

/// Questionnaire for Physical Software (Games, Apps).
public struct PhysicalSoftwareQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: InventoryItemClassifier { .physicalSoftware }
    
    // MARK: - Core Components
    public var hasBox: Bool
    public var hasManual: Bool
    public var hasMedia: Bool // Disk, Cartridge, CD
    public var hasRegistrationCard: Bool
    public var hasMaps: Bool
    
    // MARK: - Condition
    public enum Condition: String, Codable, Sendable, CaseIterable {
        case sealed = "Sealed"
        case mint = "Mint"
        case good = "Good"
        case fair = "Fair"
        case poor = "Poor"
        case loose = "Loose" // Often implies no box/manual, but can describe the media's state
    }
    public var overallCondition: Condition
    
    // MARK: - Notes
    public var damageNotes: String? // "Water damage on manual", "Box crushed"
    public var provenanceNotes: String? // "Bought at Babbages 1990"
    
    public init(
        hasBox: Bool = false,
        hasManual: Bool = false,
        hasMedia: Bool = true,
        hasRegistrationCard: Bool = false,
        hasMaps: Bool = false,
        overallCondition: Condition = .good,
        damageNotes: String? = nil,
        provenanceNotes: String? = nil
    ) {
        self.hasBox = hasBox
        self.hasManual = hasManual
        self.hasMedia = hasMedia
        self.hasRegistrationCard = hasRegistrationCard
        self.hasMaps = hasMaps
        self.overallCondition = overallCondition
        self.damageNotes = damageNotes
        self.provenanceNotes = provenanceNotes
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        
        // CIB Logic
        if hasBox && hasManual && hasMedia {
            tags.append(InventoryTag.Condition.cib.rawValue)
        } else if !hasBox && !hasManual && hasMedia {
            tags.append(InventoryTag.Condition.loose.rawValue)
        } else {
            // "Incomplete" isn't in our standard tags yet, maybe use 'loose' or define incomplete?
            // For now, let's just not tag it as CIB/Loose if it's mixed.
            // Or add incomplete to shared tags.
        }
        
        if overallCondition == .sealed {
            tags.append(InventoryTag.Condition.sealed.rawValue)
        }
        
        if hasRegistrationCard { tags.append(InventoryTag.Content.registrationCard.rawValue) }
        if hasMaps { tags.append(InventoryTag.Content.map.rawValue) }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        
        // Map Bool -> String
        attrs["has_box"] = String(hasBox)
        attrs["has_manual"] = String(hasManual)
        attrs["has_media"] = String(hasMedia)
        attrs["has_reg_card"] = String(hasRegistrationCard)
        attrs["has_maps"] = String(hasMaps)
        
        // Condition
        attrs["condition_grade"] = overallCondition.rawValue
        
        // Notes
        if let damage = damageNotes, !damage.isEmpty {
            attrs["notes_damage"] = damage
        }
        if let text = provenanceNotes, !text.isEmpty {
            attrs["notes_provenance"] = text
        }
        
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "hasBox": NSLocalizedString("question.hasBox", bundle: .inventoryKit, value: "Does it have the original box?", comment: "Question: Has Box"),
            "hasManual": NSLocalizedString("question.hasManual", bundle: .inventoryKit, value: "Does it include the manual?", comment: "Question: Has Manual"),
            "hasMedia": NSLocalizedString("question.hasMedia", bundle: .inventoryKit, value: "Is the game media (disk/cart) present?", comment: "Question: Has Media"),
            "hasRegistrationCard": NSLocalizedString("question.hasRegistrationCard", bundle: .inventoryKit, value: "Is the registration card included?", comment: "Question: Has Reg Card"),
            "hasMaps": NSLocalizedString("question.hasMaps", bundle: .inventoryKit, value: "Are there any maps included?", comment: "Question: Has Maps"),
            "overallCondition": NSLocalizedString("question.overallCondition", bundle: .inventoryKit, value: "What is the overall condition?", comment: "Question: Condition"),
            "damageNotes": NSLocalizedString("question.damageNotes", bundle: .inventoryKit, value: "Describe any visible damage:", comment: "Question: Damage Notes"),
            "provenanceNotes": NSLocalizedString("question.provenanceNotes", bundle: .inventoryKit, value: "Where/When did you acquire this?", comment: "Question: Provenance")
        ]
    }
}
