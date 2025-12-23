import InventoryTypes
import Foundation

/// Questionnaire for General Physical Items and Storage.
public struct PhysicalItemQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: ItemClassifierType = .physicalItem // or .storageContainer
    
    public var material: TagType.Material
    public var condition: TagType.Condition
    public var primaryColor: String?
    
    public init(
        classifier: ItemClassifierType = .physicalItem,
        material: TagType.Material = .plastic,
        condition: TagType.Condition = .good,
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
            "material": InventoryLocalizedString("question.material", value: "Material:", comment: "Question: Material"),
            "condition": InventoryLocalizedString("question.condition", value: "Condition:", comment: "Question: Condition"),
            "primaryColor": InventoryLocalizedString("question.primaryColor", value: "Primary Color:", comment: "Question: Color")
        ]
    }
}
