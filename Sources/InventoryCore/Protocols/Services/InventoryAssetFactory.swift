import Foundation

/// Factory protocol for creating concrete assets (implemented by Client).
public protocol InventoryAssetFactory: Sendable {
    func createAsset(id: UUID, name: String, provenance: String, tags: [String]) throws -> any InventoryAsset
}
