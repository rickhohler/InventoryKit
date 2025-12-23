import Foundation

/// A "Reference Catalog Item" (File Specification).
/// Represents the "Ideal" file/component as described by the Catalog.
/// e.g. "The Gold Monkey disk image having SHA1: abc..."
public protocol ReferenceItem: InventoryItem {
    /// The Product this item belongs to.
    var productID: InventoryIdentifier? { get }
    
    /// The expected checksums for verification.
    var expectedChecksums: [String: String]? { get }
    
    /// Is this item a "crack" or "modified" version?
    /// For Reference Items, this usually describes a known variant (e.g. "Cracked by 4am").
    var variantType: String? { get }
}
