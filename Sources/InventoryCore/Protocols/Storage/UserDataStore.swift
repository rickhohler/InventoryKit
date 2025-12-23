import Foundation
import InventoryTypes

/// Protocol defining the contract for the "User Data Store" (Private Vault).
/// Handles the actual bytes for user-owned files (Originals, Derived, Modified).
/// Corresponds to the private/user-writable partition.
public protocol UserDataStore: Sendable {
    
    /// Checks if a file exists for the given Asset ID.
    func fileExists(for assetID: UUID) async -> Bool
    
    /// Retrieves the local URL for an Asset's file.
    func fileURL(for assetID: UUID) async throws -> URL
    
    /// Writes data to the store for a specific Asset.
    /// This is typically used when creating a new Derived/Modified asset.
    func write(data: Data, for assetID: UUID) async throws
    
    /// Writes a file from a temporary URL to the store.
    func write(from url: URL, for assetID: UUID) async throws
    
    /// Deletes the asset's file.
    func delete(assetID: UUID) async throws
    
    /// Calculates the size of the file.
    func size(of assetID: UUID) async throws -> Int64
    
    /// Calculates the checksum.
    func checksum(of assetID: UUID) async throws -> String
}
