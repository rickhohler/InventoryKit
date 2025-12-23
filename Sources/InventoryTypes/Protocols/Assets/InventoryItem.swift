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
    
    // MARK: - Provenance
    /// Unique accession number for museum/library tracking (e.g., "2025.1.4").
    var accessionNumber: String? { get }
    
    // MARK: - Verification
    /// Cryptographic hashes for digital items (e.g. MD5, SHA1).
    var fileHashes: [String: String]? { get }
    
    /// Serial number for physical items.
    var serialNumber: String? { get }
    
    // MARK: - Classification
    /// High-level classification (Software, Firmware, DiskImage, Archive, Document, Hardware, etc.).
    var typeClassifier: ItemClassifierType { get }
    
    /// Specific physical format (e.g., Floppy 5.25", Cassette).
    /// Primarily used when `typeClassifier` is `.media` or `.hardware`.
    var mediaFormat: MediaFormatType? { get }
    
    // MARK: - Identification
    /// Strongly-typed external or internal identifiers.
    var identifiers: [any InventoryIdentifier] { get }
    
    /// **Foreign Key**: Link to the Product definition (Reference or User).
    var productID: UUID? { get }
    
    /// Details about the source code if available.
    var sourceCode: (any InventorySourceCode)? { get }
    
    // MARK: - Location
    /// The container this item is stored in (optional).
    var container: (any ItemContainer)? { get }
    
    /// The location of the item (if not in a container, or redundant).
    var location: ItemLocationType? { get }
}


