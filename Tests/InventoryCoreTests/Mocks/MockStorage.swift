
import Foundation
import InventoryCore
import InventoryTypes

// MARK: - Mock User Data Store
public actor MockUserDataStore: UserDataStore {
    private var files: [UUID: Data] = [:]
    
    public init() {}
    
    public func fileExists(for assetID: UUID) async -> Bool {
        files[assetID] != nil
    }
    
    public func fileURL(for assetID: UUID) async throws -> URL {
        URL(fileURLWithPath: "/tmp/\(assetID.uuidString)")
    }
    
    public func write(data: Data, for assetID: UUID) async throws {
        files[assetID] = data
    }
    
    public func write(from url: URL, for assetID: UUID) async throws {
        let data = try Data(contentsOf: url)
        files[assetID] = data
    }
    
    public func delete(assetID: UUID) async throws {
        files.removeValue(forKey: assetID)
    }
    
    public func size(of assetID: UUID) async throws -> Int64 {
        Int64(files[assetID]?.count ?? 0)
    }
    
    public func checksum(of assetID: UUID) async throws -> String {
        "dummy-checksum"
    }
}

// MARK: - Mock Reference Data Store
public actor MockReferenceDataStore: ReferenceDataStore {
    public init() {}
    
    public func isCached(for resourceID: String) async -> Bool { false }
    public func fileURL(for resourceID: String) async throws -> URL { URL(fileURLWithPath: "/dev/null") }
    public func cache(resourceID: String, from remoteURL: URL) async throws {}
    public func purge(resourceID: String) async throws {}
    public func size(of resourceID: String) async throws -> Int64? { nil }
}

// MARK: - Mock User Metadata Store
public actor MockUserMetadataStore: UserMetadataStore {
    private var assets: [UUID: any InventoryAsset] = [:]
    
    public init() {}
    
    public func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset] {
        Array(assets.values)
    }
    
    public func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)? {
        assets[id]
    }
    
    public func saveAsset(_ asset: any InventoryAsset) async throws {
        assets[asset.id] = asset
    }
    
    public func deleteAsset(id: UUID) async throws {
        assets.removeValue(forKey: id)
    }
    
    public func fetchPersonalCollections(matching query: StorageQuery) async throws -> [any Collection] { [] }
    public func saveCollection(_ collection: any Collection) async throws {}
    public func deleteCollection(id: UUID) async throws {}
    
    public func performBatch(operations: @escaping () async throws -> Void) async throws {
        try await operations()
    }
}

// MARK: - Mock Reference Metadata Store
public actor MockReferenceMetadataStore: ReferenceMetadataStore {
    public init() {}
    
    public func fetchProducts(matching query: StorageQuery) async throws -> [any Product] { [] }
    public func retrieveProduct(id: UUID) async throws -> (any Product)? { nil }
    public func saveProduct(_ product: any Product) async throws {}
    
    public func fetchPublicCollections(matching query: StorageQuery) async throws -> [any Collection] { [] }
    public func saveCollection(_ collection: any Collection) async throws {}
}

// MARK: - Mock Entities
// Mocks removed (Use MockReferenceModels.swift)

public struct MockBuilding: Building {
    public var id: UUID = UUID()
    public var name: String
    public var address: String?
    public var geoLocation: InventoryGeoLocation?
}

public struct MockRoom: Room {
    public var id: UUID = UUID()
    public var name: String
    public var level: Int = 0
    public var building: any Building
    public var geoLocation: InventoryGeoLocation?
}

public struct MockDigitalVolume: DigitalVolume {
    public var id: UUID = UUID()
    public var name: String
    public var uri: URL
    public var geoLocation: InventoryGeoLocation?
}

public struct MockValidationAsset: InventoryAsset {
    public var id: UUID = UUID()
    // Minimal impl
    public var name: String = ""
    // Missing Protocol Requirements
    public var sizeOrWeight: Int64?
    public var typeIdentifier: String = "public.data"
    public var fileHashes: [String : String]?
    public var serialNumber: String?
    public var typeClassifier: ItemClassifierType = .physicalItem
    public var mediaFormat: MediaFormatType?
    public var sourceCode: (any InventorySourceCode)?
    public var container: (any ItemContainer)?

    public var type: String?
    public var identifiers: [any InventoryIdentifier] = []
    public var accessionNumber: String?
    public var productID: UUID?
    public var custodyLocation: String?
    public var acquisitionSource: String?
    public var provenance: String?
    public var acquisitionDate: Date?
    public var condition: String?
    public var forensicClassification: String?
    public var relationshipType: AssetRelationshipType?
    public var linkedAssets: [any InventoryLinkedAsset] = []
    public var tags: [String] = []
    public var metadata: [String : String] = [:]
    public var source: (any InventorySource)?
    public var lifecycle: (any InventoryLifecycle)?
    public var health: (any InventoryHealth)?
    public var mro: (any InventoryMROInfo)?
    public var copyright: (any CopyrightInfo)?
    public var manufacturer: (any Manufacturer)?
    public var components: [any InventoryComponentLink] = []
    public var relationshipRequirements: [any InventoryRelationshipRequirement] = []
    public var title: String = ""
    public var description: String?
    public var releaseDate: Date?
    public var dataSource: (any DataSource)?
    public var children: [any InventoryItem] = []
    public var images: [any InventoryItem] = []
    
    public var location: ItemLocationType?
    
    public init() {}
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    public static func == (lhs: MockValidationAsset, rhs: MockValidationAsset) -> Bool { lhs.id == rhs.id }
}

// MARK: - Mock Repositories
public struct MockReferenceProductRepository: ReferenceProductRepository {
    public typealias Entity = any ReferenceProduct
    public func create() async throws -> Entity { MockReferenceProduct(title: "Mock Product") }
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}

public struct MockReferenceManufacturerRepository: ReferenceManufacturerRepository {
    public typealias Entity = any ReferenceManufacturer
    public func create() async throws -> Entity { MockReferenceManufacturer(slug: "mock", name: "Mock") }
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}

public struct MockReferenceCollectionRepository: ReferenceCollectionRepository {
    public typealias Entity = any ReferenceCollection
    public func create() async throws -> Entity {
        MockReferenceCollection(title: "Mock Collection")
    }
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}

public struct MockContactRepository: ContactRepository {
    public typealias Entity = any Contact
    public func create() async throws -> Entity { MockContact(name: "Mock Contact") }
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}

public struct MockAddressRepository: AddressRepository {
    public typealias Entity = any Address
    public func create() async throws -> Entity { MockAddress(address: "Mock Address") }
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}

public struct MockSpaceRepository: SpaceRepository {
    public typealias Entity = any Space
    public func create() async throws -> Entity {
        // Default impl
        MockDigitalVolume(name: "Mock DigitalVolume", uri: URL(fileURLWithPath: "/"))
    }
    public func createBuilding(id: UUID, name: String) throws -> any Building {
        MockBuilding(id: id, name: name)
    }
    public func createRoom(id: UUID, name: String, building: any Building) throws -> any Room {
        MockRoom(id: id, name: name, building: building)
    }
    public func createDigitalVolume(id: UUID, name: String, uri: URL) throws -> any DigitalVolume {
        MockDigitalVolume(id: id, name: name, uri: uri)
    }
    
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}

public struct MockVendor: Vendor {
    public var id: UUID
    public var name: String
    public var address: (any Address)? = nil
    public var inceptionDate: Date? = nil
    public var websites: [URL] = []
    public var contactEmail: String? = nil
    public var contactPhone: String? = nil
    public var metadata: [String : String] = [:]
    
    public init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

public struct MockVendorRepository: VendorRepository {
    public typealias Entity = any Vendor
    public func create() async throws -> Entity { MockVendor(name: "Mock Vendor") }
    public func save(_ entity: Entity) async throws {}
    public func update(_ entity: Entity) async throws {}
    public func delete(id: UUID) async throws {}
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}



// MARK: - Mock Storage Provider
public struct MockStorageProvider: StorageProvider {
    public var userMetadata: any UserMetadataStore
    public var referenceMetadata: any ReferenceMetadataStore
    public var userData: any UserDataStore
    public var referenceData: any ReferenceDataStore
    
    public var assetRepository: any AssetRepository = MockAssetRepository()
    public var referenceProductRepository: any ReferenceProductRepository = MockReferenceProductRepository()
    public var referenceManufacturerRepository: any ReferenceManufacturerRepository = MockReferenceManufacturerRepository()
    public var referenceCollectionRepository: any ReferenceCollectionRepository = MockReferenceCollectionRepository()
    public var contactRepository: any ContactRepository = MockContactRepository()
    public var addressRepository: any AddressRepository = MockAddressRepository()
    public var spaceRepository: any SpaceRepository = MockSpaceRepository()
    public var vendorRepository: any VendorRepository = MockVendorRepository()
    
    public init(
        userMetadata: any UserMetadataStore = MockUserMetadataStore(),
        referenceMetadata: any ReferenceMetadataStore = MockReferenceMetadataStore(),
        userData: any UserDataStore = MockUserDataStore(),
        referenceData: any ReferenceDataStore = MockReferenceDataStore()
    ) {
        self.userMetadata = userMetadata
        self.referenceMetadata = referenceMetadata
        self.userData = userData
        self.referenceData = referenceData
    }
    
    public func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
        let tx = MockTransaction()
        return try await block(tx)
    }
}

public struct MockTransaction: Transaction {
    public init() {}
    
    // Factory
    public func createAsset() async throws -> any InventoryAsset { MockValidationAsset() }
    public func createReferenceManufacturer() async throws -> any ReferenceManufacturer { MockReferenceManufacturer(slug: "mock", name: "Mock") }
    public func createReferenceProduct() async throws -> any ReferenceProduct { MockReferenceProduct(title: "Mock Product") }
    public func createReferenceCollection() async throws -> any ReferenceCollection { MockReferenceCollection(title: "Mock Collection") }
    public func createContact() async throws -> any Contact { MockContact(name: "Mock Contact") }
    public func createAddress() async throws -> any Address { MockAddress(address: "Mock Address") }
    public func createSpace() async throws -> any Space { MockDigitalVolume(name: "Mock DigitalVolume", uri: URL(fileURLWithPath: "/")) }
    public func createVendor() async throws -> any Vendor { MockVendor(name: "Mock Vendor") }
    
    public func fetchReferenceManufacturers(matching query: StorageQuery) async throws -> [any ReferenceManufacturer] { [] }
    public func retrieveReferenceManufacturer(id: UUID) async throws -> (any ReferenceManufacturer)? { nil }
    
    public func fetchReferenceProducts(matching query: StorageQuery) async throws -> [any ReferenceProduct] { [] }
    public func retrieveReferenceProduct(id: UUID) async throws -> (any ReferenceProduct)? { nil }
    
    public func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset] { [] }
    public func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)? { nil }
    
    public func fetchReferenceCollections(matching query: StorageQuery) async throws -> [any ReferenceCollection] { [] }
    public func retrieveReferenceCollection(id: UUID) async throws -> (any ReferenceCollection)? { nil }
    
    public func fetchContacts(matching query: StorageQuery) async throws -> [any Contact] { [] }
    public func retrieveContact(id: UUID) async throws -> (any Contact)? { nil }
    
    public func fetchSpaces(matching query: StorageQuery) async throws -> [any Space] { [] }
    public func retrieveSpace(id: UUID) async throws -> (any Space)? { nil }
    
    public func fetchVendors(matching query: StorageQuery) async throws -> [any Vendor] { [] }
    public func retrieveVendor(id: UUID) async throws -> (any Vendor)? { nil }
    
    public func delete(_ object: any PersistentModel) async throws {}
    public func save() async throws {}
}
