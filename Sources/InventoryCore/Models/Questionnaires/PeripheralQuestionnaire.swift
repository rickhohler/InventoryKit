import Foundation

/// Questionnaire for Peripherals (Mice, Keyboards, Monitors, Joyticks).
public struct PeripheralQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: InventoryItemClassifier { .peripheral }
    
    public var interface: InventoryTag.Interface
    public var requiresDrivers: Bool
    public var isWireless: Bool
    public var compatibility: [String] // "Mac", "PC", "Amiga"
    
    public var condition: InventoryTag.Condition
    public var isFunctional: Bool
    
    public init(
        interface: InventoryTag.Interface = .usb,
        requiresDrivers: Bool = false,
        isWireless: Bool = false,
        compatibility: [String] = [],
        condition: InventoryTag.Condition = .good,
        isFunctional: Bool = true
    ) {
        self.interface = interface
        self.requiresDrivers = requiresDrivers
        self.isWireless = isWireless
        self.compatibility = compatibility
        self.condition = condition
        self.isFunctional = isFunctional
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        tags.append(interface.rawValue)
        
        if isWireless { tags.append("feature:wireless") }
        if requiresDrivers { tags.append("req:drivers") }
        
        tags.append(condition.rawValue)
        tags.append(isFunctional ? InventoryTag.Condition.working.rawValue : InventoryTag.Condition.notWorking.rawValue)
        
        for sys in compatibility {
            tags.append("compat:\(sys.lowercased())")
        }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        attrs["interface"] = interface.rawValue
        attrs["is_wireless"] = String(isWireless)
        attrs["requires_drivers"] = String(requiresDrivers)
        attrs["is_functional"] = String(isFunctional)
        attrs["condition"] = condition.rawValue
        attrs["compatibility"] = compatibility.joined(separator: ", ")
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "interface": NSLocalizedString("question.interface", bundle: .inventoryKit, value: "Connection Interface:", comment: "Question: Interface"),
            "requiresDrivers": NSLocalizedString("question.requiresDrivers", bundle: .inventoryKit, value: "Does it require drivers?", comment: "Question: Drivers"),
            "isWireless": NSLocalizedString("question.isWireless", bundle: .inventoryKit, value: "Is it wireless?", comment: "Question: Wireless"),
            "job_compatibility": NSLocalizedString("question.compatibility", bundle: .inventoryKit, value: "Compatible Systems (comma separated):", comment: "Question: Compatibility"),
            "condition": NSLocalizedString("question.condition", bundle: .inventoryKit, value: "Physical Condition:", comment: "Question: Condition"),
            "isFunctional": NSLocalizedString("question.isFunctional", bundle: .inventoryKit, value: "Is it currently functional?", comment: "Question: Functional")
        ]
    }
}
