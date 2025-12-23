import Foundation
import InventoryTypes

/// The Top-Level Storage Provider Interface.
/// A provider that abstracts the underlying storage mechanism (e.g., SwiftData, Core Data, File System).
/// It serves as the bridge between InventoryKit logic and the persistence layer.
///
/// Inject this into `InventoryService` to provide full persistence capabilities.
public protocol StorageProvider: StorageConfigurator, Sendable {
    
    // MARK: - Metadata Objects (Database)
    
    /// Access to the User's Private Metadata Store (Assets, Personal Collections).
    /// Typically backed by CloudKit Private Database or SwiftData.
    var userMetadata: any UserMetadataStore { get }
    
    /// Access to the Reference Library Metadata Store (Products, Shared Collections).
    /// Typically backed by CloudKit Public Database or a read-only SQLite cache.
    var referenceMetadata: any ReferenceMetadataStore { get }
    
    // MARK: - Binary Data (Files)
    
    /// Access to the User's Private File Store (User Data Store).
    /// Typically backed by the local file system (Simulated CAS) or iCloud Drive.
    var userData: any UserDataStore { get }
    
    /// Access to the Reference Library File Cache (Reference Data Store).
    /// Typically backed by a local cache directory that mirrors the Source of Truth.
    var referenceData: any ReferenceDataStore { get }
    
    // MARK: - Transactions
    
    /// Executes a block within a transactional scope.
    /// - Parameter block: A closure that takes an `Transaction`.
    /// - Returns: The result of the block.
    /// - Throws: If the block throws or the transaction fails to commit.
    func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R
}
