import Foundation

public struct ValidationResult: Sendable, Equatable {
    public let isValid: Bool
    public let warnings: [String]
    public let errors: [String]
    
    public init(isValid: Bool = true, warnings: [String] = [], errors: [String] = []) {
        self.isValid = isValid
        self.warnings = warnings
        self.errors = errors
    }
    
    public static var valid: ValidationResult {
        return ValidationResult(isValid: true)
    }
    
    public static func failure(_ errors: [String]) -> ValidationResult {
        return ValidationResult(isValid: false, errors: errors)
    }
    
    public static func warning(_ warnings: [String]) -> ValidationResult {
        return ValidationResult(isValid: true, warnings: warnings)
    }
}

/// A strategy for validating specific data.
/// Adheres to SRP: Only Checks Validity. Does not fix data.
public protocol InventoryValidator: Sendable {
    associatedtype Input
    
    /// Validates the input.
    func validate(_ input: Input) -> ValidationResult
}
