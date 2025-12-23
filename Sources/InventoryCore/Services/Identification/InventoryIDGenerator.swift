import Foundation
import InventoryTypes
import DesignAlgorithmsKit

/// A utility for generating deterministic UUIDs (UUIDv5) for InventoryKit entities.
///
/// Use this generator for "Reference Data" (Manufacturers, Products, People) where you want
/// the same ID to be generated across different imports or systems based on a canonical name.
///
/// Usage:
/// ```swift
/// let manufacturerID = InventoryIDGenerator.generate(for: .manufacturer, name: "Apple Computer")
/// ```
public enum InventoryIDGenerator {
    
    /// Generates a deterministic UUIDv5 for a given name within a specific namespace.
    ///
    /// - Parameters:
    ///   - namespace: The domain namespace (e.g. `.manufacturer`).
    ///   - name: The canonical name or slug to hash.
    /// - Returns: A reproducible UUID (SHA-1 hash of namespace + name).
    public static func generate(for namespace: InventoryNamespace, name: String) -> UUID {
        return UUIDv5Generator.generate(namespace: namespace.uuid, name: name)
    }
}

/// Namespaces for deterministic UUID generation.
/// These act as the "Salt" for the UUIDv5 algorithm to ensure a "Apple" Manufacturer ID
/// is different from an "Apple" Product ID.
public enum InventoryNamespace: Sendable {
    
    /// Namespace for Manufacturers, Publishers, and Developers.
    case manufacturer
    
    /// Namespace for shared Reference Products (Software titles, Hardware models).
    case product
    
    /// Namespace for People (Contacts).
    case person
    
    /// Namespace for Reference Libraries/Data Sources.
    case library
    
    /// Namespace for Platforms (e.g. "Apple II", "Commodore 64").
    case platform
    
    /// The underlying UUID for the namespace.
    /// These are themselves random UUIDv4s, hardcoded to ensure stability.
    public var uuid: UUID {
        switch self {
        case .manufacturer:
            return UUID(uuidString: "d784a0c0-6d43-4e4b-90f7-1b0a88765432")!
        case .product:
            return UUID(uuidString: "e595b1d1-7e54-4f5c-81e8-2c1b99876543")!
        case .person:
            return UUID(uuidString: "f6a6c2e2-8f65-4d6d-92f9-3d2c00987654")!
        case .library:
            return UUID(uuidString: "a1b2c3d4-e5f6-4a5b-8c7d-9e8f77665544")!
        case .platform:
            return UUID(uuidString: "b2c3d4e5-f6a7-4b6c-9d8e-0f9a88776655")!
        }
    }
}
