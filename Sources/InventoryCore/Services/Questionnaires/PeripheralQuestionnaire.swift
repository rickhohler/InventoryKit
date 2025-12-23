import InventoryTypes
import Foundation

/// Questionnaire for Peripherals (Mice, Keyboards, Monitors, Joyticks).
public struct PeripheralQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: ItemClassifierType { .peripheral }
    
    public var interface: TagType.Interface
    public var requiresDrivers: Bool
    public var isWireless: Bool
    public var compatibility: [String] // "Mac", "PC", "Amiga"
    
    public var condition: TagType.Condition
    public var isFunctional: Bool
    
    public init(
        interface: TagType.Interface = .usb,
        requiresDrivers: Bool = false,
        isWireless: Bool = false,
        compatibility: [String] = [],
        condition: TagType.Condition = .good,
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
        tags.append(isFunctional ? TagType.Condition.working.rawValue : TagType.Condition.notWorking.rawValue)
        
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
            "interface": InventoryLocalizedString("question.interface", value: "Connection Interface:", comment: "Question: Interface"),
            "requiresDrivers": InventoryLocalizedString("question.requiresDrivers", value: "Does it require drivers?", comment: "Question: Drivers"),
            "isWireless": InventoryLocalizedString("question.isWireless", value: "Is it wireless?", comment: "Question: Wireless"),
            "job_compatibility": InventoryLocalizedString("question.compatibility", value: "Compatible Systems (comma separated):", comment: "Question: Compatibility"),
            "condition": InventoryLocalizedString("question.condition", value: "Physical Condition:", comment: "Question: Condition"),
            "isFunctional": InventoryLocalizedString("question.isFunctional", value: "Is it currently functional?", comment: "Question: Functional")
        ]
    }
}
