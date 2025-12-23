import Foundation
import InventoryTypes

/// Service responsible for querying and managing item locations.
public protocol InventoryLocationService: Sendable {
    /// Returns all items directly in a given space (Room/Building/DigitalVolume).
    func getItems(in space: any Space) async throws -> [any InventoryItem]
    
    /// Returns all containers in a given space.
    func getContainers(in space: any Space) async throws -> [any ItemContainer]
    
    /// Returns containers that are physically or digitally "near" the target.
    func getContainers(near container: any ItemContainer) async throws -> [any ItemContainer]
    
    /// Attempts to resolve the absolute geolocation of a space by checking its peers or parent.
    func resolveGeoLocation(for space: any Space) async -> InventoryGeoLocation?
    
    /// Analyzes a scan of an item alongside nearby items to detect if it has moved.
    func reconcileLocation(container: any ItemContainer, nearbyContainers: [any ItemContainer], scanDate: Date) async throws -> LocationReconciliationResult
    
    /// Updates the location of a digital item.
    func updateDigitalLocation(item: any InventoryItem, newUri: URL) async throws
}
