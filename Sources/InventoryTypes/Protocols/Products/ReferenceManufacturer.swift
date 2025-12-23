import Foundation

/// A "Reference Manufacturer" (Creator).
/// Represents a verified brand or author in the Reference Catalog.
public protocol ReferenceManufacturer: Manufacturer {
    /// Legacy string ID (Slug).
    /// Used for URL lookups and legacy file matching.
    var slug: String { get set }
    
    /// Visual representations (Logos, Office Photos, etc).
    var images: [ReferenceItem] { get set }
}
