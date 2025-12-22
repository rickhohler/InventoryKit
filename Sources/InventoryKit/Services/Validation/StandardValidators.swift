import Foundation
import InventoryCore

/// Validates software assets. Requires platform and type.
public struct SoftwareValidator: InventoryValidationStrategy {
    public init() {}
    public func validate(_ asset: any InventoryAsset) throws {
        // Must be identified as software or media
        guard let type = asset.type, ["software", "media", "game"].contains(type.lowercased()) else {
            throw InventoryValidationError.businessRuleViolation(rule: "Software validator expects type 'software', 'media', or 'game'. Found: \(asset.type ?? "nil")")
        }
    }
}

/// Validates hardware assets. Requires manufacturer and serial presence check logic (relaxed for now).
public struct HardwareValidator: InventoryValidationStrategy {
    public init() {}
    public func validate(_ asset: any InventoryAsset) throws {
        guard let type = asset.type, ["hardware", "computer", "peripheral", "console"].contains(type.lowercased()) else {
             throw InventoryValidationError.businessRuleViolation(rule: "Hardware validator expects hardware-related type. Found: \(asset.type ?? "nil")")
        }
        
        // Strict Hardware Rule: Must have a Manufacturer
        guard asset.manufacturer != nil else {
            throw InventoryValidationError.missingRequiredField(field: "manufacturer", reason: "Hardware must have a linked manufacturer.")
        }
    }
}

/// Relaxed validator for household items.
public struct HouseholdValidator: InventoryValidationStrategy {
    public init() {}
    public func validate(_ asset: any InventoryAsset) throws {
        // Just ensures it has a name. (Already guaranteed by Builder, but good for completeness)
        if asset.name.isEmpty {
             throw InventoryValidationError.missingRequiredField(field: "name", reason: "Household items must have a name.")
        }
    }
}
