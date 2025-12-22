import Foundation

/// Protocol for a questionnaire that captures detailed condition/provenance info
/// and maps it to the generic Tags/Attributes storage of a User Asset.
public protocol InventoryQuestionnaire: Sendable, Codable {
    /// The target classification for the asset being described.
    var targetClassifier: InventoryItemClassifier { get }
    
    /// Generates the list of tags (e.g., "CIB", "Sealed", "Damage").
    func generateTags() -> [String]
    
    /// Generates key-value attributes (e.g., "box_condition": "Good", "notes": "Water damage").
    func generateAttributes() -> [String: String]
    
    /// Returns a list of localized labels for the questions/fields in this questionnaire.
    /// Key should contain the field name (e.g., "hasBox") and Value the localized question prompt.
    var localizedQuestions: [String: String] { get }
}
