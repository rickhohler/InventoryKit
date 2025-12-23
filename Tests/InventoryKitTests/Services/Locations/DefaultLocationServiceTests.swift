import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class DefaultLocationServiceTests: XCTestCase {
    
    // MARK: - Local Mocks
    
    struct MockBuilding: Building {
        var id: UUID = UUID()
        var name: String
        var address: String?
        var geoLocation: InventoryGeoLocation?
    }
    
    struct MockRoom: Room {
        var id: UUID = UUID()
        var name: String
        var level: Int = 0
        var building: any Building
        var geoLocation: InventoryGeoLocation?
    }
    
    struct MockDigitalVolume: DigitalVolume {
        var id: UUID = UUID()
        var name: String
        var uri: URL
        var geoLocation: InventoryGeoLocation?
    }
    
    struct MockContainer: ItemContainer {
        var id: UUID = UUID()
        var name: String
        var type: ItemContainerType = .physical
        var location: ItemLocationType
        var typeIdentifier: String = "container.box"
        var sizeOrWeight: Int64? = nil
        var accessionNumber: String? = nil
        var fileHashes: [String : String]? = nil
        var serialNumber: String? = nil
        var typeClassifier: ItemClassifierType = .physicalItem 
        var mediaFormat: MediaFormatType? = nil
        var identifiers: [any InventoryIdentifier] = []
        var productID: UUID? = nil
        var sourceCode: (any InventorySourceCode)? = nil
        var container: (any ItemContainer)? = nil
    }
    
    class MockSpaceRepo: SpaceRepository, @unchecked Sendable {
        typealias Entity = any Space
        var spaces: [UUID: any Space] = [:]
        
        func retrieve(id: UUID) async throws -> Entity? {
            return spaces[id]
        }
        
        // Unused
        func create() async throws -> Entity { fatalError() }
        func createBuilding(id: UUID, name: String) throws -> any Building { fatalError() }
        func createRoom(id: UUID, name: String, building: any Building) throws -> any Room { fatalError() }
        func createDigitalVolume(id: UUID, name: String, uri: URL) throws -> any DigitalVolume { fatalError() }
        func save(_ entity: Entity) async throws {}
        func update(_ entity: Entity) async throws {}
        func delete(id: UUID) async throws {}
        func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    }
    
    class MockAssetRepo: AssetRepository, @unchecked Sendable {
        typealias Entity = any InventoryAsset
        
        func createAsset(id: UUID, name: String, provenance: String?, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
            fatalError("Not implemented")
        }
        
        func fetch(matching query: StorageQuery) async throws -> [Entity] {
            return []
        }
        
        // Unused
        func create() async throws -> Entity { fatalError() }
        func save(_ entity: Entity) async throws {}
        func update(_ entity: Entity) async throws {}
        func delete(id: UUID) async throws {}
        func retrieve(id: UUID) async throws -> Entity? { nil }
    }
    
    struct MockStorage: StorageProvider {
        let spaceRepo = MockSpaceRepo()
        let assetRepo = MockAssetRepo()
        
        var spaceRepository: any SpaceRepository { spaceRepo }
        var assetRepository: any AssetRepository { assetRepo }
        
        // Unused
        var userMetadata: any UserMetadataStore { fatalError() }
        var referenceMetadata: any ReferenceMetadataStore { fatalError() }
        var userData: any UserDataStore { fatalError() }
        var referenceData: any ReferenceDataStore { fatalError() }
        var referenceProductRepository: any ReferenceProductRepository { fatalError() }
        var referenceManufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
        var referenceCollectionRepository: any ReferenceCollectionRepository { fatalError() }
        var contactRepository: any ContactRepository { fatalError() }
        var addressRepository: any AddressRepository { fatalError() }
        var vendorRepository: any VendorRepository { fatalError() }
        
        func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
            fatalError() 
        }
    }

    // MARK: - Tests
    
    func testResolveGeoLocation() async {
        let storage = MockStorage()
        let service = DefaultLocationService(storage: storage)
        
        // 1. Direct Geo
        let geo = InventoryGeoLocation(latitude: 10, longitude: 20)
        let building = MockBuilding(id: UUID(), name: "Building A", geoLocation: geo)
        
        // 2. Room without Direct Geo
        let room = MockRoom(id: UUID(), name: "Room 101", building: building, geoLocation: nil)
        
        // Test Space with Geo
        let resolvedBuilding = await service.resolveGeoLocation(for: building)
        XCTAssertEqual(resolvedBuilding?.latitude, 10)
        
        // Test Hierarchy (Room -> Building)
        let resolvedRoom = await service.resolveGeoLocation(for: room)
        XCTAssertEqual(resolvedRoom?.latitude, 10)
        
        // Test Space without Geo and no hierarchy
        let vol = MockDigitalVolume(name: "Cloud", uri: URL(string: "http://cloud")!)
        let resolvedVol = await service.resolveGeoLocation(for: vol)
        XCTAssertNil(resolvedVol)
    }
    
    func testReconcileLocation() async throws {
        let storage = MockStorage()
        let service = DefaultLocationService(storage: storage)
        
        let room1ID = UUID()
        let room2ID = UUID()
        
        // Setup room in repo so it can be retrieved
        let room2 = MockRoom(id: room2ID, name: "Room 2", building: MockBuilding(name: "One"), geoLocation: nil)
        storage.spaceRepo.spaces[room2ID] = room2
        
        // Target Container currently in Room 1
        let target = MockContainer(name: "Moving Box", location: .physical(roomID: room1ID, exactLocation: nil, geoLocation: nil))
        
        // Nearby Containers: Mostly in Room 2
        let c1 = MockContainer(name: "C1", location: .physical(roomID: room2ID, exactLocation: nil, geoLocation: nil))
        let c2 = MockContainer(name: "C2", location: .physical(roomID: room2ID, exactLocation: nil, geoLocation: nil))
        let c3 = MockContainer(name: "C3", location: .physical(roomID: room1ID, exactLocation: nil, geoLocation: nil))
        
        // Case A: Majority in Room 2 (2 vs 1)
        // Service finds Room 2 in repo
        let result = try await service.reconcileLocation(container: target, nearbyContainers: [c1, c2, c3], scanDate: Date())
        
        switch result {
        case .potentialMove(let toSpace, _):
            XCTAssertEqual(toSpace.id, room2ID)
        default:
            XCTFail("Should be a move to Room 2")
        }
        
        // Case B: No Majority (Empty)
        let resultEmpty = try await service.reconcileLocation(container: target, nearbyContainers: [], scanDate: Date())
        if case .noChange = resultEmpty {
            XCTAssertTrue(true)
        } else { XCTFail() }
    }
    
    func testGetItemsStub() async throws {
        let storage = MockStorage()
        let service = DefaultLocationService(storage: storage)
        let room = MockRoom(id: UUID(), name: "Room", building: MockBuilding(name: "B"), geoLocation: nil)
        
        // Default mock fetch returns []
        let items = try await service.getItems(in: room)
        XCTAssertTrue(items.isEmpty)
    }
}
