import Foundation

/// Fallback Questionnaire for unclassified items.
public struct GenericQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: InventoryItemClassifier { .other }
    
    public var notes: String
    public var manualTags: [String]
    
    public init(notes: String, tags: [String] = []) {
        self.notes = notes
        self.manualTags = tags
    }
    
    public func generateTags() -> [String] {
        var tags = manualTags
        tags.append("type:other")
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        return ["notes": notes]
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "notes": NSLocalizedString("question.genericNotes", bundle: .inventoryKit, value: "Description / Notes:", comment: "Question: Notes"),
            "manualTags": NSLocalizedString("question.manualTags", bundle: .inventoryKit, value: "Custom Tags (comma separated):", comment: "Question: Tags")
        ]
    }
}
