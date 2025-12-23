import Foundation

// MARK: - Inventory Asset Protocol

/// Main protocol for an Inventory Asset.
/// Represents a specific, concrete instance of an item in the user's custody.

public protocol InventoryAsset: InventoryCompoundBase,
                                      InventoryItem,
                                      InventoryAssetIdentificationProtocol,
                                      InventoryAssetLocationProtocol,
                                      InventoryAssetLifecycleProtocol,
                                      InventoryAssetRelationshipProtocol,
                                      InventoryAssetMetadataProtocol,
                                      Sendable {
    
    // MARK: - Rich Data Models
    var source: (any InventorySource)? { get }
    var lifecycle: (any InventoryLifecycle)? { get }
    var health: (any InventoryHealth)? { get }
    var mro: (any InventoryMROInfo)? { get }
    var copyright: (any CopyrightInfo)? { get }
    
    // MARK: - Graph
    var components: [any InventoryComponentLink] { get }
    var relationshipRequirements: [any InventoryRelationshipRequirement] { get }
    
    // Explicit overrides or clarifications for Base properties if needed
}

// MARK: - Base Protocols

/// Identification attributes for an asset.
public protocol InventoryAssetIdentificationProtocol: Sendable {
    // id is inherited from InventoryCompoundBase
    
    // Base uses 'title'. Let's alias or use title.
    // var title: String { get set } // Inherited
    
    /// User-defined name/label for the asset.
    var name: String { get set }
    
    /// Type of the asset (e.g., "software", "hardware").
    var type: String? { get set }
    
    /// External identifiers (UPC, Serial Number, etc.).
    /// Note: Protocol uses generic, but typical usage implies strict types.
    var identifiers: [any InventoryIdentifier] { get set }
    
    /// Museum/Catalog Accession Number (e.g. "2025.1.42")
    var accessionNumber: String? { get set }
    
    /// Optional link to an authoritative Product record.
    /// This is nil for Standalone/Unidentified assets.
    var productID: UUID? { get set }
}

/// Location and Custody attributes.
public protocol InventoryAssetLocationProtocol: Sendable {
    /// Where the asset is physically or digitally stored (e.g., "Shelf A", "Downloads/").
    /// Deprecated: Use `location` instead.
    var custodyLocation: String? { get set }
    
    /// The strong-typed location of the asset (Physical Room, Container, or Digital DigitalVolume).
    var location: ItemLocationType? { get set }
    
    /// The immediate source this specific unit was acquired from (e.g., "eBay", "Archive.org").
    /// distinct from the "Manufacturer" who created the product.
    var acquisitionSource: String? { get set }
    
    /// The full chain of custody/ownership history.
    var provenance: String? { get set }
}

/// Lifecycle and Health attributes.
public protocol InventoryAssetLifecycleProtocol: Sendable {
    /// Date when the asset was acquired/added to inventory.
    var acquisitionDate: Date? { get set }
    
    /// Current condition of the asset (e.g., "Mint", "Damaged", "Incomplete").
    var condition: String? { get set }
    
    /// Deep technical analysis of the file (e.g., "Original Dump", "Modified Sector").
    /// Stores the result of a Forensic Classifier.
    var forensicClassification: String? { get set }
}

/// Relationship attributes.
public protocol InventoryAssetRelationshipProtocol: Sendable {
    /// How this asset relates to its linked product or other assets.
    /// e.g. "derived_from" (Disk Image from Physical), "variant_of" (v1.1).
    var relationshipType: AssetRelationshipType? { get set }
    
    /// Linked assets (e.g. Peripherals, Dependencies).
    var linkedAssets: [any InventoryLinkedAsset] { get set }
}

/// Metadata attributes.
public protocol InventoryAssetMetadataProtocol: Sendable {
    /// Arbitrary user tags.
    var tags: [String] { get set }
    
    /// Extended key-value metadata.
    var metadata: [String: String] { get set }
}
