import Foundation

/// Strategy for validating Inventory Assets against business rules.
/// Conforms to DAK (Design Algorithms Kit) Strategy pattern.
public protocol InventoryValidationStrategy: Sendable {
    /// Validates the asset according to this strategy's rules.
    /// - Parameter asset: The asset to validate.
    /// - Throws: `InventoryValidationError` if validation fails.
    func validate(_ asset: any InventoryAsset) throws
}

public enum InventoryValidationError: Error, CustomStringConvertible, Equatable, Sendable {
    case missingRequiredField(field: String, reason: String)
    case invalidFormat(field: String, reason: String)
    case businessRuleViolation(rule: String)
    case validationFailed(errors: [String])
    
    public var description: String {
        switch self {
        case .missingRequiredField(let field, let reason):
            return "Missing required field '\(field)': \(reason)"
        case .invalidFormat(let field, let reason):
            return "Invalid format for '\(field)': \(reason)"
        case .businessRuleViolation(let rule):
            return "Business rule violation: \(rule)"
        case .validationFailed(let errors):
            return "Validation failed with errors: \(errors.joined(separator: ", "))"
        }
    }
}
