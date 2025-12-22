import Foundation

/// Questionnaire for General Physical Items and Storage.
public struct PhysicalItemQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: InventoryItemClassifier = .physicalItem // or .storageContainer
    
    public var material: InventoryTag.Material
    public var condition: InventoryTag.Condition
    public var primaryColor: String?
    
    public init(
        classifier: InventoryItemClassifier = .physicalItem,
        material: InventoryTag.Material = .plastic,
        condition: InventoryTag.Condition = .good,
        primaryColor: String? = nil
    ) {
        self.targetClassifier = classifier
        self.material = material
        self.condition = condition
        self.primaryColor = primaryColor
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        tags.append(material.rawValue)
        tags.append(condition.rawValue)
        if let col = primaryColor {
            tags.append("color:\(col.lowercased())")
        }
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        attrs["material"] = material.rawValue
        attrs["condition"] = condition.rawValue
        if let col = primaryColor { attrs["color"] = col }
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "material": NSLocalizedString("question.material", bundle: .inventoryKit, value: "Material:", comment: "Question: Material"),
            "condition": NSLocalizedString("question.condition", bundle: .inventoryKit, value: "Condition:", comment: "Question: Condition"),
            "primaryColor": NSLocalizedString("question.primaryColor", bundle: .inventoryKit, value: "Primary Color:", comment: "Question: Color")
        ]
    }
}
