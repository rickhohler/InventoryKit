import Foundation

/// Standardized high-level relationships between two Assets or between an Asset and a Product.
public enum AssetRelationshipType: String, Codable, Sendable {
    /// This item is a variation of another (e.g., v1.0 vs v1.1).
    case variantOf = "variant_of"
    
    /// This item was created from another (e.g., Disk Image created from Physical Disk).
    case derivedFrom = "derived_from"
    
    /// This item is a physical part of another (e.g., Graphics Card inside a Computer).
    case componentOf = "component_of"
    
    /// This item is stored inside another (e.g., Floppy Disk inside Box).
    case containedIn = "contained_in"
    
    /// This item needs another to function (e.g., Game software requires Joystick hardware).
    case requires = "requires"
    
    /// This item was sold together with another (e.g., Manual bundled with Game).
    case bundledWith = "bundled_with"
}
