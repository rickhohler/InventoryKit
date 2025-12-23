import Foundation
import InventoryTypes

/// Service responsible for validating Inventory Entities against business rules.
///
/// The `InventoryValidationService` accesses `InventoryAppLogicValidators` to perform checks on
/// entities like `InventorySystemRequirements`.
///
/// ## Usage
/// ```swift
/// let service = InventoryValidationService(context: context)
/// let result = service.validate(requirements)
/// if !result.isValid {
///     print(result.errors)
/// }
/// ```
public struct InventoryValidationService: Sendable {
    
    // MARK: - Dependencies
    
    private let context: Context
    
    // MARK: - Initialization
    
    /// Initializes the validation service.
    /// - Parameter context: The shared `Context`.
    public init(context: Context) {
        self.context = context
    }
    
    /// Validates system requirements.
    /// - Parameter requirements: The requirements to validate.
    /// - Returns: A `ValidationResult` containing errors and warnings.
    public func validate(_ requirements: any InventorySystemRequirements) -> ValidationResult {
        var errors: [String] = []
        var warnings: [String] = []
        
        // Example: Validate Memory
        if let minMem = requirements.minMemory {
            let res = InventoryAppLogicValidators.PositiveNumberValidator().validate(minMem)
            errors.append(contentsOf: res.errors)
            warnings.append(contentsOf: res.warnings)
        }
        
        // Example logic: Recommended >= Minimum
        if let min = requirements.minMemory, let rec = requirements.recommendedMemory, rec < min {
            warnings.append("Recommended memory is less than minimum memory.")
        }
        
        return ValidationResult(
            isValid: errors.isEmpty,
            warnings: warnings,
            errors: errors
        )
    }
}
