import Foundation

// MARK: - Inventory Asset Protocol

/// Main protocol for an Inventory Asset.
/// Represents a specific, concrete instance of an item in the user's custody.

public protocol InventoryAssetProtocol: InventoryAssetIdentificationProtocol,
                                      InventoryAssetLocationProtocol,
                                      InventoryAssetLifecycleProtocol,
                                      InventoryAssetRelationshipProtocol,
                                      InventoryAssetMetadataProtocol,
                                      Sendable {
    
    // MARK: - Rich Data Models
    var source: (any InventorySourceProtocol)? { get }
    var lifecycle: (any InventoryLifecycleProtocol)? { get }
    var health: (any InventoryHealthProtocol)? { get }
    var mro: (any InventoryMROInfoProtocol)? { get }
    var copyright: (any CopyrightInfoProtocol)? { get }
    
    // MARK: - Graph
    var components: [any InventoryComponentLinkProtocol] { get }
    var relationshipRequirements: [any InventoryRelationshipRequirementProtocol] { get }
    var linkedAssets: [any InventoryLinkedAssetProtocol] { get }
}

// MARK: - Base Protocols

/// Identification attributes for an asset.
public protocol InventoryAssetIdentificationProtocol: Sendable {
    /// Unique identifier for this asset instance.
    var id: UUID { get }
    
    /// User-defined name/label for the asset.
    var name: String { get }
    
    /// Type of the asset (e.g., "software", "hardware").
    var type: String? { get }
    
    /// External identifiers (UPC, Serial Number, etc.).
    /// Note: Protocol uses generic, but typical usage implies strict types.
    var identifiers: [any InventoryIdentifierProtocol] { get }
    
    /// Optional link to an authoritative Product record.
    /// This is nil for Standalone/Unidentified assets.
    var productID: UUID? { get }
}

/// Location and Custody attributes.
public protocol InventoryAssetLocationProtocol: Sendable {
    /// Where the asset is physically or digitally stored (e.g., "Shelf A", "Downloads/").
    var custodyLocation: String? { get }
    
    /// The immediate source this specific unit was acquired from (e.g., "eBay", "Archive.org").
    /// distinct from the "Manufacturer" who created the product.
    var acquisitionSource: String? { get }
    
    /// The full chain of custody/ownership history.
    var provenance: String? { get }
}

/// Lifecycle and Health attributes.
public protocol InventoryAssetLifecycleProtocol: Sendable {
    /// Date when the asset was acquired/added to inventory.
    var acquisitionDate: Date? { get }
    
    /// Current condition of the asset (e.g., "Mint", "Damaged", "Incomplete").
    var condition: String? { get }
    
    /// Deep technical analysis of the file (e.g., "Original Dump", "Modified Sector").
    /// Stores the result of a Forensic Classifier.
    var forensicClassification: String? { get }
}

/// Relationship attributes.
public protocol InventoryAssetRelationshipProtocol: Sendable {
    /// How this asset relates to its linked product or other assets.
    /// e.g. "derived_from" (Disk Image from Physical), "variant_of" (v1.1).
    var relationshipType: AssetRelationshipType? { get }
    
    // TODO: Define standard way to link to other *Assets* (not just Products)
    // var linkedAssetIDs: [UUID] { get }
}

/// Metadata attributes.
public protocol InventoryAssetMetadataProtocol: Sendable {
    /// Arbitrary user tags.
    var tags: [String] { get }
    
    /// Extended key-value metadata.
    var metadata: [String: String] { get }
}
