import Foundation
import InventoryTypes
import InventoryCore

/// Default implementation of the InventoryLocationService.
/// Default implementation of the InventoryLocationService.
public final class DefaultLocationService: InventoryLocationService {
    
    private let storage: any StorageProvider
    
    public init(storage: any StorageProvider) {
        self.storage = storage
    }
    
    public func getItems(in space: any Space) async throws -> [any InventoryItem] {
        // Query Assets
        // Assuming "location" field stores the ID of the container/room/volume matches space.id
        // Filter logic relies on storage provider capability to query complex enums or flattened fields.
        // We use a simplified assumption that 'locationID' is a searchable index.
        let filter = StorageFilter.field(key: "locationID", op: .equals, value: space.id.uuidString)
        let query = StorageQuery(filter: filter)
        
        let assets = try await storage.assetRepository.fetch(matching: query)
        return assets.map { $0 as any InventoryItem }
    }
    
    public func getContainers(in space: any Space) async throws -> [any ItemContainer] {
        // Feature: Container Repository access expected here.
        // Currently StorageProvider does not expose a generic ItemContainerRepository.
        // We return empty until Container logic is formalized in Storage.
        return []
    }
    
    public func getContainers(near container: any ItemContainer) async throws -> [any ItemContainer] {
        // Find containers in the same location (Same parent)
        // Check container.location
        switch container.location {
        case .physical(_, _, _):
            // Return containers in the same room is a reasonable "near" definition.
            // But we can't query containers yet.
            return []
        case .digital(_, _):
            // Same folder?
            return []
        }
    }
    
    public func resolveGeoLocation(for space: any Space) async -> InventoryGeoLocation? {
        // 1. Check space itself
        if let directGeo = space.geoLocation {
            return directGeo
        }
        
        // 2. Check hierarchy (Room -> Building)
        // 2. Check hierarchy (Room -> Building)
        if let room = space as? any Room {
             return await resolveGeoLocation(for: room.building)
        }
        
        // 3. DigitalVolumes (Volume -> ??)
        // Currently no parent for Volume defined.
        
        return nil
    }
    
    public func resolveGeoLocation(for building: any Building) -> InventoryGeoLocation? {
        // Helper specifically for building to avoid cast overhead if needed, 
        // but Protocol 'Space' covers it.
        return building.geoLocation
    }
    
    public func reconcileLocation(container: any ItemContainer, nearbyContainers: [any ItemContainer], scanDate: Date) async throws -> LocationReconciliationResult {
        // Smart Move Logic:
        // Check majority location of nearby containers.
        guard !nearbyContainers.isEmpty else { return .noChange }
        
        var locationCounts: [UUID: Int] = [:] // RoomID -> Count
        
        for nearby in nearbyContainers {
            if case .physical(let roomID, _, _) = nearby.location {
                locationCounts[roomID, default: 0] += 1
            }
        }
        
        // Find majority
        let threshold = nearbyContainers.count / 2 + 1
        // Retrieve max count
        if let (majorityRoomID, count) = locationCounts.max(by: { $0.value < $1.value }), count >= threshold {
            
            // Check if current container is already there
            if case .physical(let currentRoomID, _, _) = container.location, currentRoomID == majorityRoomID {
                return .noChange
            } else {
                // It seems to have moved to majorityRoomID
                // Fetch the room logic via SpaceRepository
                // spaceRepository returns 'any Space', we cast to Room or generic Space.
                if let space = try await storage.spaceRepository.retrieve(id: majorityRoomID),
                   let _ = space as? any Room { // Verify it's a room?
                    return .potentialMove(to: space, confidence: 0.9)
                } else {
                    return .ambiguous(reasons: ["Inferred move to unknown room ID: \(majorityRoomID)"])
                }
            }
        }
        
        return .ambiguous(reasons: ["No clear majority location in nearby items"])
    }
    
    public func updateDigitalLocation(item: any InventoryItem, newUri: URL) async throws {
        // Logic to update storage
        // Retrieve asset -> modify -> save
        // We must ensure the item is a valid InventoryAsset to have an ID and be retrievable.
        guard let validAsset = item as? any InventoryAsset else {
             throw InventoryError.storageError("Item provided is not a valid InventoryAsset and cannot be updated directly.")
        }
        
        guard var asset = try await storage.assetRepository.retrieve(id: validAsset.id) else {
            throw InventoryError.storageError("Item not found with id: \(validAsset.id)")
        }
        
        // Update location
        // Find Volume? Or just update URL?
        // Assume digital location simple update
        asset.location = ItemLocationType.digital(url: newUri, volumeID: nil) // Volume ID lookup skipped for now
        
        try await storage.assetRepository.save(asset)
    }
}
