import Foundation
import InventoryTypes
import InventoryCore

/// Default implementation of the InventoryLocationService.
public final class DefaultLocationService: InventoryLocationService {
    
    private let storage: any StorageProvider
    
    public init(storage: any StorageProvider) {
        self.storage = storage
    }
    
    public func getItems(in space: any Space) async throws -> [any InventoryItem] {
        // Query Assets
        // Assuming "location" field stores the ID of the container/room.
        // This is a simplification. Real query might check for ItemLocationType enum cases.
        // Or we might need a specific filter like .custom("locationID", space.id)
        
        let filter = StorageFilter.field(key: "location", op: .equals, value: space.id.uuidString)
        let query = StorageQuery(filter: filter)
        
        // Fetch assets
        let assets = try await storage.assetRepository.fetch(matching: query)
        
        // Also fetch containers?
        // Method signature returns [any InventoryItem].
        // Are containers considered InventoryItems?
        // No, ItemContainer is separate.
        // But getContainers(in:) is a separate method.
        
        return assets.map { $0 as any InventoryItem }
    }
    
    public func getContainers(in space: any Space) async throws -> [any ItemContainer] {
        // Query logic for containers
        // Not implemented fully in repositories yet.
        return []
    }
    
    public func getContainers(near container: any ItemContainer) async throws -> [any ItemContainer] {
        // Find containers in the same location (Same parent)
        // If container.location is .physical(roomID), fetch all containers in that room.
        
        switch container.location {
        case .physical(_, _, _):
            // We need to fetch containers in roomID
            // But we don't have a ContainerRepository exposed easily.
            // Assuming simplified empty return for now.
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
        
        // 2. Check hierarchy
        if let room = space as? any Room {
            // Room -> Building
            // Building acts as the root in this simplified model.
            return room.building.geoLocation
        }
        
        // 3. DigitalVolumes?
        // DigitalVolume has geoLocation. If nil, maybe server location?
        
        return nil
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
        if let (majorityRoomID, count) = locationCounts.max(by: { $0.value < $1.value }), count >= threshold {
            
            // Check if current container is already there
            if case .physical(let currentRoomID, _, _) = container.location, currentRoomID == majorityRoomID {
                return .noChange
            } else {
                // It seems to have moved to majorityRoomID
                // Fetch the room logic
                if let newRoom = try await storage.spaceRepository.retrieve(id: majorityRoomID) {
                    return .potentialMove(to: newRoom, confidence: 0.9)
                } else {
                    return .ambiguous(reasons: ["Inferred move to unknown room ID: \(majorityRoomID)"])
                }
            }
        }
        
        return .ambiguous(reasons: ["No clear majority location in nearby items"])
    }
    public func updateDigitalLocation(item: any InventoryItem, newUri: URL) async throws {
        // Logic to update storage
        // For now, stub.
    }
}
