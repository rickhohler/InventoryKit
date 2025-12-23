import Foundation
import InventoryTypes

/// A generic repository protocol defining standard persistence operations for an entity.
/// Clients must implement this for each supported entity type to bridge InventoryKit with their storage layer.
public protocol EntityRepository: Sendable {
    /// The specific entity type this repository manages.
    associatedtype Entity: Sendable
    
    // MARK: - Lifecycle
    
    /// Creates a new, blank instance of the entity.
    /// The instance is typically not saved until `save(_:)` is called,
    /// unless the underlying storage implies immediate creation (like Core Data contexts).
    func create() async throws -> Entity
    
    // MARK: - Persistence
    
    /// Saves or updates the entity in the storage.
    func save(_ entity: Entity) async throws
    
    /// Updates the entity in the storage (explicit update).
    /// Often redundant with save, but useful for storage engines that distinguish insert vs update.
    func update(_ entity: Entity) async throws
    
    /// Deletes the entity with the specified ID.
    func delete(id: UUID) async throws
    
    // MARK: - Retrieval
    
    /// Fetches entities matching the provided query.
    func fetch(matching query: StorageQuery) async throws -> [Entity]
    
    /// Retrieves a single entity by its ID.
    func retrieve(id: UUID) async throws -> Entity?
}
