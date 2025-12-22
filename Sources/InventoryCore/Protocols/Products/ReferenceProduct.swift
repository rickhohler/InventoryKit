import Foundation

/// A "Reference Catalog Entry" (Authority Record).
/// Represents a known product in the universe (e.g., "MobyGames ID: 123", "The Oregon Trail").
/// This is distinct from a "User Product", which is a local instance.
public protocol ReferenceProduct: InventoryProduct, InventoryCompoundBase {
    /// The canonical web URL for this product (e.g., Wikipedia).
    var wikipediaUrl: URL? { get }
    
    /// The purchase URL (if still available).
    var purchaseUrl: URL? { get }
    
    /// The country of origin.
    var originCountry: String? { get }
    
    /// The year the product was discontinued (if applicable).
    var discontinuedYear: Int? { get }
    
    /// The platforms this product is available on (Array, unlike the singular base).
    var platforms: [String]? { get }
    
    /// Copyright registration string/ID.
    var copyrightRegistration: String? { get }
    
    /// URLs to manual PDFs (or filenames).
    /// Note: Base `InventoryProduct` uses `instructionIDs` (UUIDs). This offers a string-based alternative for external URLs.
    var manualUrls: [URL]? { get }
}
