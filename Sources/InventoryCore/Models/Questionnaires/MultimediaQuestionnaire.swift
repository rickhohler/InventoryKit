import Foundation

/// Questionnaire for Multimedia (Audio, Video, Graphics).
public struct MultimediaQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: InventoryItemClassifier = .multimedia
    
    public var format: InventoryTag.MediaFormat? // Optional because it could be digital generic
    public var durationMinutes: Int?
    public var isPhysical: Bool
    
    public init(
        classifier: InventoryItemClassifier = .multimedia,
        format: InventoryTag.MediaFormat? = nil,
        durationMinutes: Int? = nil,
        isPhysical: Bool = true
    ) {
        self.targetClassifier = classifier
        self.format = format
        self.durationMinutes = durationMinutes
        self.isPhysical = isPhysical
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        if let fmt = format {
            tags.append(fmt.rawValue)
        }
        tags.append(isPhysical ? InventoryTag.Format.physical.rawValue : InventoryTag.Format.digital.rawValue)
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        if let fmt = format { attrs["format"] = fmt.rawValue }
        if let dur = durationMinutes { attrs["duration_min"] = String(dur) }
        attrs["is_physical"] = String(isPhysical)
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "format": NSLocalizedString("question.mediaFormat", bundle: .inventoryKit, value: "Format (e.g. VHS, DVD):", comment: "Question: Format"),
            "durationMinutes": NSLocalizedString("question.duration", bundle: .inventoryKit, value: "Duration in minutes:", comment: "Question: Duration"),
            "isPhysical": NSLocalizedString("question.isPhysicalMedia", bundle: .inventoryKit, value: "Is this physical media?", comment: "Question: Physical")
        ]
    }
}
