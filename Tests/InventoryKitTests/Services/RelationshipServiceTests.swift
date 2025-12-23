import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class RelationshipServiceTests: XCTestCase {
    
    // MARK: - Mocks
    
    struct MockRequirement: InventoryRelationshipRequirement {
        var name: String
        var typeID: String
        var required: Bool
        var compatibleAssetIDs: [UUID] = []
        var requiredTags: [String] = []
        var complianceNotes: String? = nil
    }
    
    final class MockAsset: InventoryAsset, @unchecked Sendable {
        var id: UUID = UUID()
        var name: String = "Test Asset"
        var type: String? = "Hardware"
        var typeIdentifier: String { type ?? "unknown" }
        var tags: [String] = []
        
        // Relationship Properties
        var relationshipRequirements: [any InventoryRelationshipRequirement] = []
        var linkedAssets: [any InventoryLinkedAsset] = []
        
        // Protocol conformances (Minimal)
        var identifiers: [any InventoryIdentifier] = []
        var accessionNumber: String?
        var productID: UUID?
        var custodyLocation: String?
        var acquisitionSource: String?
        var provenance: String?
        var acquisitionDate: Date?
        var condition: String?
        var forensicClassification: String?
        var relationshipType: AssetRelationshipType?
        var metadata: [String : String] = [:]
        
        // InventoryItem Conformance
        var sizeOrWeight: Int64?
        var fileHashes: [String : String]?
        var serialNumber: String?
        var typeClassifier: ItemClassifierType { .physicalItem }
        var mediaFormat: MediaFormatType?
        var container: (any ItemContainer)?
        var location: ItemLocationType?
        var sourceCode: (any InventorySourceCode)?
        
        var title: String = ""
        var description: String?
        var releaseDate: Date?
        var dataSource: (any DataSource)?
        var children: [any InventoryItem] = []
        var images: [any InventoryItem] = []
        
        var source: (any InventorySource)? { nil }
        var lifecycle: (any InventoryLifecycle)? { nil }
        var health: (any InventoryHealth)? { nil }
        var mro: (any InventoryMROInfo)? { nil }
        var copyright: (any CopyrightInfo)? { nil }
        var components: [any InventoryComponentLink] { [] }
        var manufacturer: (any Manufacturer)? = nil
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: MockAsset, rhs: MockAsset) -> Bool { lhs.id == rhs.id }
    }
    
    final class MockStorage: StorageProvider, @unchecked Sendable {
        // Simple In-Memory Store
        var assets: [UUID: MockAsset] = [:]
        
        func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
            // Create a mock transaction wrapper
            let tx = MockTx(storage: self)
            let result = try await block(tx)
            return result
        }
        
        // Unused properties
        var userMetadata: any UserMetadataStore { fatalError() }
        var referenceMetadata: any ReferenceMetadataStore { fatalError() }
        var userData: any UserDataStore { fatalError() }
        var referenceData: any ReferenceDataStore { fatalError() }
        
        var assetRepository: any AssetRepository { fatalError() }
        var referenceProductRepository: any ReferenceProductRepository { fatalError() }
        var referenceManufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
        var referenceCollectionRepository: any ReferenceCollectionRepository { fatalError() }
        var contactRepository: any ContactRepository { fatalError() }
        var addressRepository: any AddressRepository { fatalError() }
        var spaceRepository: any SpaceRepository { fatalError() }
        var vendorRepository: any VendorRepository { fatalError() }
    }
    
    final class MockTx: Transaction, @unchecked Sendable {
        unowned let storage: MockStorage
        
        init(storage: MockStorage) { self.storage = storage }
        
        func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)? {
            return storage.assets[id]
        }
        
        func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset] {
            return Array(storage.assets.values)
        }
        
        // Minimal implementation required
        func createAsset() async throws -> any InventoryAsset { fatalError() }
        func createReferenceManufacturer() async throws -> any ReferenceManufacturer { fatalError() }
        func createReferenceProduct() async throws -> any ReferenceProduct { fatalError() }
        func createReferenceCollection() async throws -> any ReferenceCollection { fatalError() }
        func createContact() async throws -> any Contact { fatalError() }
        func createAddress() async throws -> any Address { fatalError() }
        func createSpace() async throws -> any Space { fatalError() }
        func createVendor() async throws -> any Vendor { fatalError() }
        func fetchReferenceManufacturers(matching query: StorageQuery) async throws -> [any ReferenceManufacturer] { [] }
        func retrieveReferenceManufacturer(id: UUID) async throws -> (any ReferenceManufacturer)? { nil }
        func fetchReferenceProducts(matching query: StorageQuery) async throws -> [any ReferenceProduct] { [] }
        func retrieveReferenceProduct(id: UUID) async throws -> (any ReferenceProduct)? { nil }
        func fetchReferenceCollections(matching query: StorageQuery) async throws -> [any ReferenceCollection] { [] }
        func retrieveReferenceCollection(id: UUID) async throws -> (any ReferenceCollection)? { nil }
        func fetchContacts(matching query: StorageQuery) async throws -> [any Contact] { [] }
        func retrieveContact(id: UUID) async throws -> (any Contact)? { nil }
        func fetchSpaces(matching query: StorageQuery) async throws -> [any Space] { [] }
        func retrieveSpace(id: UUID) async throws -> (any Space)? { nil }
        func fetchVendors(matching query: StorageQuery) async throws -> [any Vendor] { [] }
        func retrieveVendor(id: UUID) async throws -> (any Vendor)? { nil }
        func delete(_ object: any PersistentModel) async throws {}
        func save() async throws {}
    }
    
    // MARK: - Configurator (Unused for Relationships but required for types)
    final class MockConfig: Configurator, @unchecked Sendable {
         func configure<T>(_ instance: inout T, id: UUID?, name: String, type: String?, location: String?, acquisitionSource: String?, acquisitionDate: Date?, condition: String?, tags: [String], metadata: [String : String]) where T : InventoryAsset {}
         func configure<T>(_ instance: inout T, id: UUID?, name: String, slug: String, description: String?, metadata: [String : String], aliases: [String]) where T : Manufacturer {}
         func configure<T>(_ instance: inout T, id: UUID?, title: String, description: String?, sku: String?, productType: String?, classification: String?, genre: String?, releaseDate: Date?, platform: String?) where T : Product {}
         func configure<T>(_ instance: inout T, id: UUID?, name: String, geoLocation: InventoryGeoLocation?) where T : Space {}
         func configure<T>(_ instance: inout T, id: UUID?, name: String, address: (any Address)?, inceptionDate: Date?, websites: [URL], contactEmail: String?, contactPhone: String?, metadata: [String : String]) where T : Vendor {}
         func configure<T>(_ instance: inout T, id: UUID?, label: String?, address: String, address2: String?, city: String, region: String?, postalCode: String, country: String, notes: String?, imageIDs: [UUID]) where T : Address {}
         func configure<T>(_ instance: inout T, id: UUID?, name: String, title: String?, email: String?, notes: String?, socialMedia: SocialMedia) where T : Contact {}
         func configure<T>(_ instance: inout T, url: URL, notes: String?) where T : InventorySourceCode {}
         func configure<T>(_ instance: inout T, minMemory: Int64?, recommendedMemory: Int64?, cpuFamily: String?, minCpuSpeedMHz: Double?, video: String?, audio: String?, osName: String?, minOsVersion: String?) where T : InventorySystemRequirements {}
    }
    
    // MARK: - Tests
    
    func testEvaluate_MissingRequired() async throws {
        let storage = MockStorage()
        let asset = MockAsset()
        asset.relationshipRequirements = [
            MockRequirement(name: "Monitor", typeID: "display", required: true)
        ]
        storage.assets[asset.id] = asset
        
        let service = InventoryRelationshipService(storage: storage)
        let results = try await service.evaluateCompliance(for: asset)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.status, .missingRequired)
    }
    
    func testEvaluate_MissingOptional() async throws {
        let storage = MockStorage()
        let asset = MockAsset()
        asset.relationshipRequirements = [
            MockRequirement(name: "Joystick", typeID: "controller", required: false)
        ]
        storage.assets[asset.id] = asset
        
        let service = InventoryRelationshipService(storage: storage)
        let results = try await service.evaluateCompliance(for: asset)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.status, .missingOptional)
    }
    
    func testEvaluate_Satisfied_Simple() async throws {
        let storage = MockStorage()
        
        // Target Link
        let monitor = MockAsset()
        monitor.name = "CRT"
        storage.assets[monitor.id] = monitor
        
        // Source
        let computer = MockAsset()
        computer.relationshipRequirements = [
             MockRequirement(name: "Monitor", typeID: "display", required: true)
        ]
        // Link it
        computer.linkedAssets = [LinkedAsset(assetID: monitor.id, typeID: "display")]
        storage.assets[computer.id] = computer
        
        let service = InventoryRelationshipService(storage: storage)
        let results = try await service.evaluateCompliance(for: computer)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.status, .satisfied)
    }
    
    func testEvaluate_NonCompliantTags() async throws {
        let storage = MockStorage()
        
        // Target Link (Missing 'Color' tag)
        let monitor = MockAsset()
        monitor.name = "Mono CRT"
        monitor.tags = ["Monochrome"]
        storage.assets[monitor.id] = monitor
        
        // Source
        let computer = MockAsset()
        computer.relationshipRequirements = [
             MockRequirement(name: "Color Monitor", typeID: "display", required: true, requiredTags: ["Color"])
        ]
        // Link it
        computer.linkedAssets = [LinkedAsset(assetID: monitor.id, typeID: "display")]
        storage.assets[computer.id] = computer
        
        let service = InventoryRelationshipService(storage: storage)
        let results = try await service.evaluateCompliance(for: computer)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.status, .nonCompliantTags)
        print("Message: \(results.first?.message ?? "")")
    }
    
    func testLinkAndUnlink() async throws {
        let storage = MockStorage()
        let source = MockAsset()
        let target = MockAsset()
        storage.assets[source.id] = source
        storage.assets[target.id] = target
        
        let service = InventoryRelationshipService(storage: storage)
        
        // Link
        try await service.link(sourceID: source.id, targetID: target.id, typeID: "peripheral", note: "Test")
        
        // Verify
        XCTAssertEqual(source.linkedAssets.count, 1) // Using Class Ref so local update reflects? 
        // Note: In real storage, we'd fetch again.
        // MockStorage stores the object reference, so modifying it in transact block DOES modify the one in `storage.assets`.
        
        XCTAssertEqual(source.linkedAssets.first?.assetID, target.id)
        XCTAssertEqual(source.linkedAssets.first?.note, "Test")
        
        // Unlink
        try await service.unlink(sourceID: source.id, targetID: target.id)
        XCTAssertEqual(source.linkedAssets.count, 0)
    }
    
    func testFindCandidates() async throws {
        let storage = MockStorage()
        let a1 = MockAsset(); a1.tags = ["Red", "Big"]
        let a2 = MockAsset(); a2.tags = ["Blue", "Big"]
        storage.assets[a1.id] = a1
        storage.assets[a2.id] = a2
        
        let service = InventoryRelationshipService(storage: storage)
        let req = MockRequirement(name: "Red Thing", typeID: "thing", required: true, requiredTags: ["Red"])
        
        let candidates = try await service.findCandidates(for: req)
        XCTAssertEqual(candidates.count, 1)
        XCTAssertEqual(candidates.first?.id, a1.id)
    }
}
