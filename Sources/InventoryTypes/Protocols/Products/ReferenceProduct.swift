import Foundation

/// A "Reference Catalog Entry" (Authority Record).
/// Represents a known product in the universe (e.g., "MobyGames ID: 123", "The Oregon Trail").
/// This is distinct from a "User Product", which is a local instance.
public protocol ReferenceProduct: Product, InventoryCompoundBase {
    /// The canonical web URL for this product (e.g., Wikipedia).
    var wikipediaUrl: URL? { get set }
    
    /// The purchase URL (if still available).
    var purchaseUrl: URL? { get set }
    
    /// The country of origin.
    var originCountry: String? { get set }
    
    /// The year the product was discontinued (if applicable).
    var discontinuedYear: Int? { get set }
    
    /// The platforms this product is available on (Array, unlike the singular base).
    var platforms: [String]? { get set }
    
    /// Copyright registration string/ID.
    var copyrightRegistration: String? { get set }
    
    /// URLs to manual PDFs (or filenames).
    /// Note: Base `Product` uses `instructionIDs` (UUIDs). This offers a string-based alternative for external URLs.
    var manualUrls: [URL]? { get set }
    
    
}
