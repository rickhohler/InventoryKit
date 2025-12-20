import Foundation

/// Protocol defining the structure of an Inventory Document.
///
/// An inventory document represents a serialization of inventory state, including schema version,
/// metadata, and a collection of assets.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryDocumentProtocol: Sendable {
    /// The schema version of the document.
    var schemaVersion: InventorySchemaVersion { get }
    
    /// Optional metadata info about the document export/creation.
    var info: InventoryDocumentInfo? { get }
    
    /// The list of assets contained in the document.
    /// Uses `any InventoryAssetProtocol` to allow mixed asset types.
    var assets: [any InventoryAssetProtocol] { get }
}
