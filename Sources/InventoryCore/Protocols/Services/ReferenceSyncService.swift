import Foundation
import InventoryTypes

/// Service responsible for synchronizing Reference Library data.
public protocol ReferenceSyncService: Sendable {
    
    /// Subscribe to a Public Collection.
    /// This triggers the download of the initial Collection Bundle.
    /// - Parameter collectionID: The UUID of the Public Collection (or its IRN).
    func subscribe(to collectionID: UUID) async throws
    
    /// Unsubscribe from a collection, optionally removing cached data.
    func unsubscribe(from collectionID: UUID, removeData: Bool) async throws
    
    /// Check for updates (Deltas) for all subscribed collections.
    /// - Returns: A list of available updates.
    func checkForUpdates() async throws -> [ReferenceUpdateInfo]
    
    /// Apply pending updates.
    /// - Parameter updates: The updates to apply.
    func apply(updates: [ReferenceUpdateInfo]) async throws
    
    /// Get the sync status of a collection.
    func status(for collectionID: UUID) async throws -> ReferenceSyncStatus
}

/// Information about a pending update.
public struct ReferenceUpdateInfo: Sendable {
    public let collectionID: UUID
    public let version: String
    public let sizeBytes: Int64
    public let isDelta: Bool
    
    public init(collectionID: UUID, version: String, sizeBytes: Int64, isDelta: Bool) {
        self.collectionID = collectionID
        self.version = version
        self.sizeBytes = sizeBytes
        self.isDelta = isDelta
    }
}

/// Sync status enum.
public enum ReferenceSyncStatus: String, Sendable {
    case synced
    case outOfDate
    case syncing
    case error
    case notSubscribed
}
