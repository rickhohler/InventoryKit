import Foundation
import InventoryTypes

/// Protocol for the Reference Library File Store (Reference Data).
/// Manages cached binary data for Public Reference artifacts (e.g. Reference Disk Images).
public protocol ReferenceDataStore: Sendable {
    
    /// Checks if a file is cached for the given Resource ID.
    func isCached(for resourceID: String) async -> Bool
    
    /// Retrieves the local URL for a resource.
    /// This may trigger a download if not currently cached (depending on implementation policy).
    func fileURL(for resourceID: String) async throws -> URL
    
    /// Downloads/Caches a resource from a remote URL.
    func cache(resourceID: String, from remoteURL: URL) async throws
    
    /// Removes a resource from the cache.
    func purge(resourceID: String) async throws
    
    /// Calculates the size of the cached file.
    func size(of resourceID: String) async throws -> Int64?
}
