import Foundation

/// The abstract base type for the Metadata Record describing a single component (File, Chip, PCB).
/// Describes the properties of a component in the catalog.
public protocol InventoryItem: Sendable {
    // MARK: - Properties
    /// The name or filename of the item.
    var name: String { get }
    
    /// The size (bytes) or weight (grams) of the item.
    var sizeOrWeight: Int64? { get }
    
    /// The specific type identifier (e.g., UTI for files, Part Number for hardware).
    var typeIdentifier: String { get }
    
    // MARK: - Verification
    /// Cryptographic hashes for digital items (e.g. MD5, SHA1).
    var fileHashes: [String: String]? { get }
    
    /// Serial number for physical items.
    var serialNumber: String? { get }
    
    // MARK: - Classification
    /// High-level classification (Media, Art, Doc, Hardware).
    var typeClassifier: InventoryItemClassifier { get }
    
    // MARK: - Identification
    /// Strongly-typed external or internal identifiers.
    var identifiers: [any InventoryIdentifier] { get }
}
