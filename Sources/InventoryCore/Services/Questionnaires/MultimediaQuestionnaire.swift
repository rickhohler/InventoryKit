import InventoryTypes
import Foundation

/// Questionnaire for Multimedia (Audio, Video, Graphics).
public struct MultimediaQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: ItemClassifierType = .multimedia
    
    public var format: TagType.MediaFormatType? // Optional because it could be digital generic
    public var durationMinutes: Int?
    public var isPhysical: Bool
    
    public init(
        classifier: ItemClassifierType = .multimedia,
        format: TagType.MediaFormatType? = nil,
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
        tags.append(isPhysical ? TagType.Format.physical.rawValue : TagType.Format.digital.rawValue)
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
            "format": InventoryLocalizedString("question.mediaFormat", value: "Format (e.g. VHS, DVD):", comment: "Question: Format"),
            "durationMinutes": InventoryLocalizedString("question.duration", value: "Duration in minutes:", comment: "Question: Duration"),
            "isPhysical": InventoryLocalizedString("question.isPhysicalMedia", value: "Is this physical media?", comment: "Question: Physical")
        ]
    }
}
