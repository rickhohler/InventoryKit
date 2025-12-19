//
//  InventoryStandardRelationshipTypes.swift
//  InventoryKit
//
//  Standard relationship types for InventoryKit (domain-agnostic)
//

import Foundation

/// Standard relationship types for InventoryKit (domain-agnostic).
///
/// These types can be used to establish `InventoryLinkedAsset` connections
/// and `InventoryRelationshipRequirement` definitions across various inventory domains.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum InventoryStandardRelationshipTypes {
    
    // MARK: - Component/Embedded
    
    /// Asset contains/embeds another asset
    public static let hasComponent = InventoryRelationshipType(
        id: "has_component",
        displayName: "Has Component",
        description: "Asset contains/embeds another asset"
    )
    
    /// Asset is embedded in another asset (reverse of `has_component`)
    public static let isComponentOf = InventoryRelationshipType(
        id: "is_component_of",
        displayName: "Is Component Of",
        description: "Asset is embedded in another asset"
    )
    
    /// Component installed in a system/device
    public static let installedIn = InventoryRelationshipType(
        id: "installed_in",
        displayName: "Installed In",
        description: "Component installed in a system/device"
    )
    
    /// Container relationship (e.g., case contains motherboard, box contains item)
    public static let contains = InventoryRelationshipType(
        id: "contains",
        displayName: "Contains",
        description: "Asset contains another asset (general containment)"
    )
    
    // MARK: - Compatibility/Usage
    
    /// Asset is compatible with another asset
    public static let compatibleWith = InventoryRelationshipType(
        id: "compatible_with",
        displayName: "Compatible With",
        description: "Asset is compatible with another asset"
    )
    
    /// Asset is used by another asset
    public static let usedBy = InventoryRelationshipType(
        id: "used_by",
        displayName: "Used By",
        description: "Asset is used by another asset"
    )
    
    /// Asset uses another asset (reverse of `used_by`)
    public static let uses = InventoryRelationshipType(
        id: "uses",
        displayName: "Uses",
        description: "Asset uses another asset"
    )
    
    /// Asset requires another asset to function
    public static let requires = InventoryRelationshipType(
        id: "requires",
        displayName: "Requires",
        description: "Asset requires another asset to function"
    )
    
    /// Asset is required by another asset (reverse of `requires`)
    public static let requiredBy = InventoryRelationshipType(
        id: "required_by",
        displayName: "Required By",
        description: "Asset is required by another asset"
    )
    
    // MARK: - Connection/Attachment
    
    /// Asset connects to another asset
    public static let connectsTo = InventoryRelationshipType(
        id: "connects_to",
        displayName: "Connects To",
        description: "Asset connects to another asset"
    )
    
    /// Asset is connected to another asset (reverse of `connects_to`)
    public static let connectedTo = InventoryRelationshipType(
        id: "connected_to",
        displayName: "Connected To",
        description: "Asset is connected to another asset"
    )
    
    /// Asset is attached to another asset
    public static let attachedTo = InventoryRelationshipType(
        id: "attached_to",
        displayName: "Attached To",
        description: "Asset is attached to another asset"
    )
    
    /// Asset attaches to another asset (reverse of `attached_to`)
    public static let attachesTo = InventoryRelationshipType(
        id: "attaches_to",
        displayName: "Attaches To",
        description: "Asset attaches to another asset"
    )
    
    // MARK: - Spatial/Proximity
    
    /// Asset is next to or in vicinity of another asset
    public static let nextTo = InventoryRelationshipType(
        id: "next_to",
        displayName: "Next To",
        description: "Asset is next to or in vicinity of another asset"
    )
    
    /// Asset is adjacent to another asset (reverse of `next_to`)
    public static let adjacentTo = InventoryRelationshipType(
        id: "adjacent_to",
        displayName: "Adjacent To",
        description: "Asset is adjacent to another asset"
    )
    
    /// Asset is near another asset (general proximity)
    public static let near = InventoryRelationshipType(
        id: "near",
        displayName: "Near",
        description: "Asset is near another asset (general proximity)"
    )
    
    /// Asset is located with another asset (stored/kept together)
    public static let locatedWith = InventoryRelationshipType(
        id: "located_with",
        displayName: "Located With",
        description: "Asset is located with another asset (stored/kept together)"
    )
    
    // MARK: - Data/Media
    
    /// Data stored on media
    public static let storedOn = InventoryRelationshipType(
        id: "stored_on",
        displayName: "Stored On",
        description: "Data stored on media"
    )
    
    /// Media contains data/software (reverse of `stored_on`)
    public static let containsData = InventoryRelationshipType(
        id: "contains_data",
        displayName: "Contains Data",
        description: "Media contains data/software"
    )
    
    /// Asset is backup of another asset
    public static let backupOf = InventoryRelationshipType(
        id: "backup_of",
        displayName: "Backup Of",
        description: "Asset is backup of another asset"
    )
    
    /// Asset is copy of another asset
    public static let copyOf = InventoryRelationshipType(
        id: "copy_of",
        displayName: "Copy Of",
        description: "Asset is copy of another asset"
    )
    
    /// Asset derived from another asset
    public static let derivedFrom = InventoryRelationshipType(
        id: "derived_from",
        displayName: "Derived From",
        description: "Asset derived from another asset"
    )
    
    /// Digital asset represents physical asset
    public static let represents = InventoryRelationshipType(
        id: "represents",
        displayName: "Represents",
        description: "Digital asset represents physical asset"
    )
    
    /// Physical asset represented by digital asset (reverse of `represents`)
    public static let representedBy = InventoryRelationshipType(
        id: "represented_by",
        displayName: "Represented By",
        description: "Physical asset represented by digital asset"
    )
    
    // MARK: - Documentation
    
    /// Asset documents another asset
    public static let documents = InventoryRelationshipType(
        id: "documents",
        displayName: "Documents",
        description: "Asset documents another asset"
    )
    
    /// Asset is documented by another asset (reverse of `documents`)
    public static let documentedBy = InventoryRelationshipType(
        id: "documented_by",
        displayName: "Documented By",
        description: "Asset is documented by another asset"
    )
    
    /// Asset accompanies another asset
    public static let accompanies = InventoryRelationshipType(
        id: "accompanies",
        displayName: "Accompanies",
        description: "Asset accompanies another asset"
    )
    
    /// Asset is accompanied by another asset (reverse of `accompanies`)
    public static let accompaniedBy = InventoryRelationshipType(
        id: "accompanied_by",
        displayName: "Accompanied By",
        description: "Asset is accompanied by another asset"
    )
    
    // MARK: - Visual/Media
    
    /// Image/photo of an asset
    public static let imageOf = InventoryRelationshipType(
        id: "image_of",
        displayName: "Image Of",
        description: "Image/photo of an asset"
    )
    
    /// Asset has image/photo (reverse of `image_of`)
    public static let hasImage = InventoryRelationshipType(
        id: "has_image",
        displayName: "Has Image",
        description: "Asset has image/photo"
    )
    
    /// Artwork for an asset
    public static let artworkFor = InventoryRelationshipType(
        id: "artwork_for",
        displayName: "Artwork For",
        description: "Artwork for an asset"
    )
    
    /// Asset has artwork (reverse of `artwork_for`)
    public static let hasArtwork = InventoryRelationshipType(
        id: "has_artwork",
        displayName: "Has Artwork",
        description: "Asset has artwork"
    )
    
    /// Packaging for an asset
    public static let packagingFor = InventoryRelationshipType(
        id: "packaging_for",
        displayName: "Packaging For",
        description: "Packaging for an asset"
    )
    
    /// Asset has packaging (reverse of `packaging_for`)
    public static let hasPackaging = InventoryRelationshipType(
        id: "has_packaging",
        displayName: "Has Packaging",
        description: "Asset has packaging"
    )
    
    // MARK: - Collection/Grouping
    
    /// Asset is part of a collection
    public static let partOfCollection = InventoryRelationshipType(
        id: "part_of_collection",
        displayName: "Part Of Collection",
        description: "Asset is part of a collection"
    )
    
    /// Collection contains asset (reverse of `part_of_collection`)
    public static let containsAsset = InventoryRelationshipType(
        id: "contains_asset",
        displayName: "Contains Asset",
        description: "Collection contains an asset"
    )
    
    /// Collection contains another collection (nested collections)
    public static let containsCollection = InventoryRelationshipType(
        id: "contains_collection",
        displayName: "Contains Collection",
        description: "Collection contains another collection"
    )
    
    /// Collection is part of parent collection (reverse of `contains_collection`)
    public static let partOfParentCollection = InventoryRelationshipType(
        id: "part_of_parent_collection",
        displayName: "Part Of Parent Collection",
        description: "Collection is part of parent collection"
    )
    
    /// Asset is member of a series
    public static let seriesMember = InventoryRelationshipType(
        id: "series_member",
        displayName: "Series Member",
        description: "Asset is member of a series"
    )
    
    /// Asset is version/variant of another asset
    public static let versionOf = InventoryRelationshipType(
        id: "version_of",
        displayName: "Version Of",
        description: "Asset is version/variant of another asset"
    )
    
    /// Asset is variant of another asset
    public static let variantOf = InventoryRelationshipType(
        id: "variant_of",
        displayName: "Variant Of",
        description: "Asset is variant of another asset"
    )
    
    // MARK: - Product/Catalog
    
    /// Asset is instance of a Product (catalog entry)
    public static let instanceOf = InventoryRelationshipType(
        id: "instance_of",
        displayName: "Instance Of",
        description: "Asset is instance of a Product (catalog entry)"
    )
    
    /// Product has asset instances (reverse of `instance_of`)
    public static let hasInstances = InventoryRelationshipType(
        id: "has_instances",
        displayName: "Has Instances",
        description: "Product has instances (assets)"
    )
    
    /// Asset references a Product in catalog
    public static let referencesProduct = InventoryRelationshipType(
        id: "references_product",
        displayName: "References Product",
        description: "Asset references a Product in catalog"
    )
    
    // MARK: - All Standard Types
    
    /// All standard relationship types
    public static let all: [InventoryRelationshipType] = [
        hasComponent, isComponentOf, installedIn, contains,
        compatibleWith, usedBy, uses, requires, requiredBy,
        connectsTo, connectedTo, attachedTo, attachesTo,
        nextTo, adjacentTo, near, locatedWith,
        storedOn, containsData, backupOf, copyOf, derivedFrom, represents, representedBy,
        documents, documentedBy, accompanies, accompaniedBy,
        imageOf, hasImage, artworkFor, hasArtwork, packagingFor, hasPackaging,
        partOfCollection, containsAsset, containsCollection, partOfParentCollection,
        seriesMember, versionOf, variantOf,
        instanceOf, hasInstances, referencesProduct
    ]
}

