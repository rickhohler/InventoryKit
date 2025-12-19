import Foundation

/// Protocol defining the contract for inventory assets.
///
/// This protocol allows clients to implement their own asset models (e.g., CloudKit/CoreData managed objects)
/// while maintaining compatibility with InventoryKit's catalog and service operations.
///
/// ## CloudKit/CoreData Integration
///
/// Clients can make their CloudKit or CoreData managed objects conform to this protocol:
///
/// ```swift
/// extension CKRecord: InventoryAssetProtocol {
///     public var id: UUID { /* extract from record */ }
///     public var identifiers: [InventoryIdentifier] { /* extract from record */ }
///     // ... implement all protocol requirements
/// }
/// ```
///
/// - SeeAlso: ``InventoryAsset`` for concrete implementation
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryAssetProtocol: Identifiable, Sendable where ID == UUID {
    /// Unique identifier for the asset.
    var id: UUID { get }
    
    /// List of identifiers (UUID, serial number, etc.).
    var identifiers: [InventoryIdentifier] { get }
    
    /// Display name of the asset.
    var name: String { get }
    
    /// Type/category of the asset (e.g., "computer", "peripheral").
    var type: String? { get }
    
    /// Physical or logical location of the asset.
    var location: String? { get }
    
    /// Source information (origin, acquisition date, etc.).
    var source: InventorySource? { get }
    
    /// Lifecycle information (acquisition, ownership, disposal).
    var lifecycle: InventoryLifecycle? { get }
    
    /// Maintenance, Repair, and Operations information.
    var mro: InventoryMROInfo? { get }
    
    /// Health status (physical condition, operational status).
    var health: InventoryHealth? { get }
    
    /// Embedded component links (child assets).
    var components: [InventoryComponentLink] { get }
    
    /// Relationship requirements (what related assets are needed).
    var relationshipRequirements: [InventoryRelationshipRequirement] { get }
    
    /// Linked assets (relationships to other assets).
    var linkedAssets: [InventoryLinkedAsset] { get }
    
    /// Domain-specific tags for categorization and processing.
    var tags: [String] { get }
    
    /// Copyright information (structured copyright data).
    /// Defaults to nil for backward compatibility.
    var copyright: CopyrightInfo? { get }
    
    /// Custom metadata dictionary.
    var metadata: [String: String] { get }
    
    /// Reference to a Product (catalog entry) via UUID.
    /// Assets can reference Products in the catalog via this field.
    var productID: UUID? { get }
}

/// Protocol defining the contract for inventory documents.
///
/// This protocol allows clients to implement their own document models while maintaining
/// compatibility with InventoryKit's storage providers and transformers.
///
/// - SeeAlso: ``InventoryDocument`` for concrete implementation
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryDocumentProtocol: Sendable {
    /// Schema version for compatibility checking.
    var schemaVersion: InventorySchemaVersion { get }
    
    /// Document metadata (title, description, etc.).
    var info: InventoryDocumentInfo? { get }
    
    /// Custom metadata dictionary.
    var metadata: [String: String] { get }
    
    /// Relationship type definitions.
    var relationshipTypes: [InventoryRelationshipType] { get }
    
    /// Collection of assets in the document.
    var assets: [any InventoryAssetProtocol] { get }
    
    /// Validates schema compatibility.
    func ensureCompatibility(expected version: InventorySchemaVersion) throws
}

