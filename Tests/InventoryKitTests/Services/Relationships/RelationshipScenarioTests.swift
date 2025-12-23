import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class RelationshipScenarioTests: XCTestCase {
    
    // MARK: - Mocks
    
    struct MockRequirement: InventoryRelationshipRequirement {
        var name: String
        var typeID: String
        var required: Bool
        var compatibleAssetIDs: [UUID]
        var requiredTags: [String]
        var complianceNotes: String?
    }
    
    class MockScenarioStorage: StorageProvider, @unchecked Sendable {
        var assets: [UUID: any InventoryAsset] = [:]
        
        // Mocks for unused protocol requirements
        var identifier: String = "MockScenario"
        var transformer: AnyInventoryDataTransformer = AnyInventoryDataTransformer(MockTransformer())
        var vendor: (any Vendor)? = nil
        
        var assetRepository: any AssetRepository { fatalError() }
        var spaceRepository: any SpaceRepository { fatalError() }
        var referenceProductRepository: any ReferenceProductRepository { fatalError() }
        var referenceManufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
        var referenceCollectionRepository: any ReferenceCollectionRepository { fatalError() }
        var contactRepository: any ContactRepository { fatalError() }
        var addressRepository: any AddressRepository { fatalError() }
        
        var userMetadata: any UserMetadataStore { fatalError() }
        var referenceMetadata: any ReferenceMetadataStore { fatalError() }
        var userData: any UserDataStore { fatalError() }
        var referenceData: any ReferenceDataStore { fatalError() }
        
        func loadInventory(validatingAgainst version: SchemaVersion) async throws -> any InventoryDocument { fatalError() }
        func saveInventory(_ document: any InventoryDocument) async throws {}
        
        // Unused
        func replaceInventory(with document: any InventoryDocument) async throws {}
        func createVendor(_ vendor: any Vendor) async throws {}
        func saveVendor(_ vendor: any Vendor) async throws {}
        func loadVendor(id: UUID) async throws -> (any Vendor)? { nil }
        func fetchVendors() async throws -> [any Vendor] { [] }
        func deleteVendor(id: UUID) async throws {}
        
        var vendorRepository: any VendorRepository { fatalError() }
        
        func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
            let tx = MockScenarioTx(storage: self)
            return try await block(tx)
        }
    }
    
    class MockScenarioTx: Transaction, @unchecked Sendable {
        let storage: MockScenarioStorage
        
        init(storage: MockScenarioStorage) {
            self.storage = storage
        }
        
        func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)? {
            return storage.assets[id]
        }
        
        // Simple filter logic for tests
        func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset] {
            return Array(storage.assets.values)
        }
        
        // Unused stubs
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
    
    struct MockTransformer: InventoryDataTransformer {
        var format: InventoryDataFormat = .json
        func decode(_ data: Data, validatingAgainst version: SchemaVersion) throws -> any InventoryDocument { fatalError() }
        func encode(_ document: any InventoryDocument) throws -> Data { Data() }
    }
    
    final class MockClassAsset: InventoryAsset, @unchecked Sendable {
        var id: UUID
        var name: String
        // InventoryCompoundBase / InventoryItem / AssetIdentification requirements
        var title: String = ""
        var description: String? = nil
        var releaseDate: Date? = nil
        var dataSource: (any DataSource)? = nil
        var children: [any InventoryItem] = []
        var images: [any InventoryItem] = []
        
        var typeIdentifier: String = "item"
        var location: ItemLocationType? = .digital(url: URL(string: "http://")!, volumeID: UUID())
        var acquisitionSource: String? = nil
        var acquisitionDate: Date? = nil
        var cost: Decimal? = nil
        var condition: String? = nil
        var tags: [String]
        var metadata: [String : String] = [:]
        
        // Missing requirements for InventoryAsset
        var components: [any InventoryComponentLink] = []
        var type: String? = nil
        var custodyLocation: String? = nil
        var forensicClassification: String? = nil
        var relationshipType: AssetRelationshipType? = nil
        
        var source: (any InventorySource)? = nil
        var lifecycle: (any InventoryLifecycle)? = nil
        var health: (any InventoryHealth)? = nil
        var mro: (any InventoryMROInfo)? = nil
        var copyright: (any CopyrightInfo)? = nil
        
        var linkedAssets: [any InventoryLinkedAsset] = []
        var relationshipRequirements: [any InventoryRelationshipRequirement] = []
        
        // Protocol conformances
        var manufacturer: (any Manufacturer)? = nil
        var product: (any Product)? = nil
        var container: (any ItemContainer)? = nil
        var collection: (any Collection)? = nil
        // var resources: [any InventoryResource] = [] // Removed
        var provenance: String? = nil
        var sizeOrWeight: Int64? = nil
        var accessionNumber: String? = nil
        var fileHashes: [String : String]? = nil
        var serialNumber: String? = nil
        var typeClassifier: ItemClassifierType = .physicalItem // Fixed missing
        var mediaFormat: MediaFormatType? = nil // Fixed missing
        var sourceCode: (any InventorySourceCode)? = nil // Fixed missing
        var identifiers: [any InventoryIdentifier] = [] // Fixed missing
        var productID: UUID? = nil
        
        init(id: UUID, name: String, tags: [String]) {
            self.id = id
            self.name = name
            self.tags = tags
        }
    }
    
    // MARK: - Tests
    
    func testComputerWithMonitor() async throws {
        let storage = MockScenarioStorage()
        let service = InventoryRelationshipService(storage: storage)
        
        let c64ID = UUID()
        let monitorID = UUID()
        
        let displayReq = MockRequirement(
            name: "Display",
            typeID: "rel.display",
            required: true,
            compatibleAssetIDs: [],
            requiredTags: ["type:monitor"]
        )
        
        let c64 = MockClassAsset(id: c64ID, name: "Commodore 64", tags: ["type:computer"])
        c64.relationshipRequirements = [displayReq]
        
        let monitor = MockClassAsset(id: monitorID, name: "1702 Monitor", tags: ["type:monitor"])
        
        storage.assets[c64ID] = c64
        storage.assets[monitorID] = monitor
        
        // 1. Fail compliance
        let report1 = try await service.evaluateCompliance(for: c64)
        XCTAssertEqual(report1.first?.status, .missingRequired)
        
        // 2. Link
        try await service.link(sourceID: c64ID, targetID: monitorID, typeID: "rel.display", note: nil)
        
        // Verify Persistence (Since it is a class, the ref in storage should be updated)
        XCTAssertEqual(c64.linkedAssets.count, 1)
        XCTAssertEqual(c64.linkedAssets.first?.assetID, monitorID)
        
        // 3. Pass compliance
        let report2 = try await service.evaluateCompliance(for: c64)
        XCTAssertEqual(report2.first?.status, .satisfied)
        
        // 4. Unlink
        try await service.unlink(sourceID: c64ID, targetID: monitorID)
        XCTAssertEqual(c64.linkedAssets.count, 0)
    }
    
    func testWrongTypeLinked() async throws {
        let storage = MockScenarioStorage()
        let service = InventoryRelationshipService(storage: storage)
        
        let id1 = UUID()
        let id2 = UUID()
        
        let req = MockRequirement(
            name: "Mouse",
            typeID: "rel.mouse",
            required: true,
            compatibleAssetIDs: [],
            requiredTags: ["type:mouse"]
        )
        
        let comp = MockClassAsset(id: id1, name: "Amiga", tags: ["type:computer"])
        comp.relationshipRequirements = [req]
        
        let joystick = MockClassAsset(id: id2, name: "Joystick", tags: ["type:joystick"]) // Not a mouse
        
        storage.assets[id1] = comp
        storage.assets[id2] = joystick
        
        // Link the wrong item
        try await service.link(sourceID: id1, targetID: id2, typeID: "rel.mouse", note: nil)
        
        let report = try await service.evaluateCompliance(for: comp)
        XCTAssertEqual(report.first?.status, .nonCompliantTags)
        XCTAssertTrue(report.first?.message.contains("do not match criteria") ?? false)
    }
    
    func testFindCandidates() async throws {
        let storage = MockScenarioStorage()
        let service = InventoryRelationshipService(storage: storage)
        
        let id1 = UUID()
        let id2 = UUID()
        
        // Candidate 1: Matches
        let c1 = MockClassAsset(id: id1, name: "Good Candidate", tags: ["tag:match"])
        // Candidate 2: No Match
        let c2 = MockClassAsset(id: id2, name: "Bad Candidate", tags: ["tag:other"])
        
        storage.assets[id1] = c1
        storage.assets[id2] = c2
        
        let req = MockRequirement(
            name: "Req",
            typeID: "rel",
            required: false,
            compatibleAssetIDs: [],
            requiredTags: ["tag:match"]
        )
        
        let results = try await service.findCandidates(for: req)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, id1)
    }
}
