import Foundation

// MARK: - Inventory Product Protocol

/// Main protocol for an Inventory Product.
// MARK: - Inventory Product Protocol

/// Main protocol for an Inventory Product.
/// Represents the abstract "Authority Record" for a software title or hardware model.
public protocol Product: Sendable,
                                        ProductIdentificationProtocol,
                                        ProductMetadataProtocol,
                                        ProductCreatorProtocol,
                                        ProductTemporalProtocol,
                                        ProductSpecificationProtocol,
                                        ProductRelationshipProtocol,
                                        ProductReferenceProtocol {
    
    /// Extended metadata definitions.
    var metadata: [String: String] { get set }
    
    /// **Foreign Key**: Link to the "Reference Catalog Entry" (Authority Record).
    /// *   If this IS a Reference Catalog Entry, this is `nil`.
    /// *   If this is a User Product (Stub/Derivative), this points to the Authority Record.
    var referenceProductID: InventoryIdentifier? { get set }
}

// MARK: - Base Protocols

public protocol ProductIdentificationProtocol {
    var id: UUID { get set }
    var sku: String? { get set }
    var identifiers: [any InventoryIdentifier] { get set }
}

public protocol ProductMetadataProtocol {
    var title: String { get set }
    var description: String? { get set }
    // Note: ProductType is usually an enum (Software/Hardware)
    var productType: String? { get set }
    var classification: String? { get set }
    var genre: String? { get set }
    
    /// Information about source code availability.
    var sourceCode: (any InventorySourceCode)? { get set }
}

public protocol ProductCreatorProtocol {
    /// The primary creator/manufacturer.
    var manufacturer: (any Manufacturer)? { get set }
    
    /// Additional credit fields.
    var publisher: String? { get set }
    var developer: String? { get set }
    var creator: String? { get set }
}

public protocol ProductTemporalProtocol {
    var releaseDate: Date? { get set }
    var productionDate: Date? { get set }
}

public protocol ProductSpecificationProtocol {
    var platform: String? { get set }
    var systemRequirements: (any InventorySystemRequirements)? { get set }
    var version: String? { get set }
}

public protocol ProductRelationshipProtocol {
    // Linked resources
    var instanceIDs: [UUID] { get set }
    var artworkIDs: [UUID] { get set }
    var screenshotIDs: [UUID] { get set }
    var instructionIDs: [UUID] { get set }
    var collectionIDs: [UUID] { get set }
}

public protocol ProductReferenceProtocol {
    // External IDs (MobyGames ID, etc)
    // Using string dictionaries or custom struct arrays
    var references: [String: String] { get set }
}
