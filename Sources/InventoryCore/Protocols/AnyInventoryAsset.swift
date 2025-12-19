import Foundation

/// Type-erased wrapper for `InventoryAssetProtocol`.
///
/// This wrapper allows storing protocol-conforming types in collections while maintaining
/// value semantics and enabling CloudKit/CoreData integration.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct AnyInventoryAsset: InventoryAssetProtocol, Identifiable, Sendable {
    public let id: UUID
    public let identifiers: [InventoryIdentifier]
    public let name: String
    public let type: String?
    public let location: String?
    public let source: InventorySource?
    public let lifecycle: InventoryLifecycle?
    public let mro: InventoryMROInfo?
    public let health: InventoryHealth?
    public let components: [InventoryComponentLink]
    public let relationshipRequirements: [InventoryRelationshipRequirement]
    public let linkedAssets: [InventoryLinkedAsset]
    public let tags: [String]
    public let copyright: CopyrightInfo?
    public let metadata: [String: String]
    public let productID: UUID?
    
    /// Creates a type-erased wrapper from any `InventoryAssetProtocol`.
    public init(_ asset: any InventoryAssetProtocol) {
        self.id = asset.id
        self.identifiers = asset.identifiers
        self.name = asset.name
        self.type = asset.type
        self.location = asset.location
        self.source = asset.source
        self.lifecycle = asset.lifecycle
        self.mro = asset.mro
        self.health = asset.health
        self.components = asset.components
        self.relationshipRequirements = asset.relationshipRequirements
        self.linkedAssets = asset.linkedAssets
        self.tags = asset.tags
        self.copyright = asset.copyright
        self.metadata = asset.metadata
        self.productID = asset.productID
    }
    
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnyInventoryAsset: Equatable {
    public static func == (lhs: AnyInventoryAsset, rhs: AnyInventoryAsset) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.identifiers == rhs.identifiers &&
        lhs.type == rhs.type &&
        lhs.location == rhs.location &&
        lhs.source == rhs.source &&
        lhs.lifecycle == rhs.lifecycle &&
        lhs.mro == rhs.mro &&
        lhs.health == rhs.health &&
        lhs.components == rhs.components &&
        lhs.relationshipRequirements == rhs.relationshipRequirements &&
        lhs.linkedAssets == rhs.linkedAssets &&
        lhs.tags == rhs.tags &&
        lhs.copyright == rhs.copyright &&
        lhs.metadata == rhs.metadata &&
        lhs.productID == rhs.productID
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnyInventoryAsset: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(identifiers)
        hasher.combine(type)
        hasher.combine(location)
        hasher.combine(source)
        hasher.combine(lifecycle)
        hasher.combine(mro)
        hasher.combine(health)
        hasher.combine(components)
        hasher.combine(relationshipRequirements)
        hasher.combine(linkedAssets)
        hasher.combine(tags)
        hasher.combine(copyright)
        hasher.combine(metadata)
        hasher.combine(productID)
    }
}

