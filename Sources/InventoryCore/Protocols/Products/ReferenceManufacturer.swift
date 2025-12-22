import Foundation

/// A "Reference Manufacturer" (Creator).
/// Represents a verified brand or author in the Reference Catalog.
public protocol ReferenceManufacturer: InventoryManufacturer {
    /// Legacy string ID (Slug).
    /// Used for URL lookups and legacy file matching.
    var slug: String { get }
    
    /// Visual representations (Logos, Office Photos, etc).
    var images: [ReferenceItem] { get }
}
