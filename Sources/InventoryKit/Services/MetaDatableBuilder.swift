import Foundation
import InventoryCore

/// A builder that supports attaching metadata strings and applying questionnaires.
public protocol MetaDatableBuilder {
    /// The specific type of questionnaire this builder accepts.
    associatedtype QuestionnaireType
    
    /// Adds a single key-value metadata entry.
    /// - Returns: The builder instance for chaining.
    func addMetadata(_ key: String, _ value: String) -> Self
    
    /// Applies the results of a questionnaire to the builder's metadata.
    /// - Returns: The builder instance for chaining.
    func applyQuestionnaire(_ questionnaire: QuestionnaireType) -> Self
}

public extension MetaDatableBuilder {
    /// Default implementation for applying a generic InventoryQuestionnaire
    /// if the associated type conforms to it.
    /// Note: Swift protocols with associated types can be tricky with extentions like this,
    /// so concrete types usually implement it. But we can provide a helper.
}
