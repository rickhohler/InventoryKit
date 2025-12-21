import Foundation

// MARK: - Inventory Product Protocol

/// Main protocol for an Inventory Product.
/// Represents the abstract "Authority Record" for a software title or hardware model.
public protocol InventoryProduct: Sendable,
                                        InventoryProductIdentificationProtocol,
                                        InventoryProductMetadataProtocol,
                                        InventoryProductCreatorProtocol,
                                        InventoryProductTemporalProtocol,
                                        InventoryProductSpecificationProtocol,
                                        InventoryProductRelationshipProtocol,
                                        InventoryProductReferenceProtocol {
    
    /// Extended metadata definitions.
    var metadata: [String: String] { get }
    
    /// **Foreign Key**: Link to the "Reference Catalog Entry" (Authority Record).
    /// *   If this IS a Reference Catalog Entry, this is `nil`.
    /// *   If this is a User Product (Stub/Derivative), this points to the Authority Record.
    var referenceProductID: InventoryIdentifier? { get }
}

// MARK: - Base Protocols

public protocol InventoryProductIdentificationProtocol {
    var id: UUID { get }
    var sku: String? { get }
    var identifiers: [any InventoryIdentifier] { get }
}

public protocol InventoryProductMetadataProtocol {
    var title: String { get }
    var description: String? { get }
    // Note: ProductType is usually an enum (Software/Hardware)
    var productType: String? { get }
    var classification: String? { get }
    var genre: String? { get }
}

public protocol InventoryProductCreatorProtocol {
    /// The primary creator/manufacturer.
    var manufacturer: (any InventoryManufacturer)? { get }
    
    /// Additional credit fields.
    var publisher: String? { get }
    var developer: String? { get }
    var creator: String? { get }
}

public protocol InventoryProductTemporalProtocol {
    var releaseDate: Date? { get }
    var productionDate: Date? { get }
}

public protocol InventoryProductSpecificationProtocol {
    var platform: String? { get }
    var systemRequirements: String? { get }
    var version: String? { get }
}

public protocol InventoryProductRelationshipProtocol {
    // Linked resources
    var instanceIDs: [UUID] { get }
    var artworkIDs: [UUID] { get }
    var screenshotIDs: [UUID] { get }
    var instructionIDs: [UUID] { get }
    var collectionIDs: [UUID] { get }
}

public protocol InventoryProductReferenceProtocol {
    // External IDs (MobyGames ID, etc)
    // Using string dictionaries or custom struct arrays
    var references: [String: String] { get }
}
