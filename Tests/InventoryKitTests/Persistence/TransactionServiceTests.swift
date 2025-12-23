
import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class TransactionServiceTests: XCTestCase {
    
    // MARK: - Mocks
    
    final class MockTx: Transaction, @unchecked Sendable {
        var createdManufacturers: [MockManufacturer] = []
        var createdAssets: [MockAsset] = []
        var createdProducts: [MockProduct] = []
        
        var fetchedManufacturers: [MockManufacturer] = []
        
        // Configuration
        var existingManufacturer: MockManufacturer?
        
        func createReferenceManufacturer() async throws -> any ReferenceManufacturer {
            let m = MockManufacturer()
            createdManufacturers.append(m)
            return m
        }
        
        func createAsset() async throws -> any InventoryAsset {
            let a = MockAsset()
            createdAssets.append(a)
            return a
        }
        
        func createReferenceProduct() async throws -> any ReferenceProduct {
            let p = MockProduct()
            createdProducts.append(p)
            return p
        }
        
        func fetchReferenceManufacturers(matching query: StorageQuery) async throws -> [any ReferenceManufacturer] {
            if let m = existingManufacturer {
                return [m]
            }
            return []
        }
        
        // Unused Requirements
        func createReferenceCollection() async throws -> any ReferenceCollection { fatalError() }
        func createContact() async throws -> any Contact { fatalError() }
        func createAddress() async throws -> any Address { fatalError() }
        func createSpace() async throws -> any Space { fatalError() }
        func createVendor() async throws -> any Vendor { fatalError() }
        
        func retrieveReferenceManufacturer(id: UUID) async throws -> (any ReferenceManufacturer)? { nil }
        func fetchReferenceProducts(matching query: StorageQuery) async throws -> [any ReferenceProduct] { [] }
        func retrieveReferenceProduct(id: UUID) async throws -> (any ReferenceProduct)? { nil }
        func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset] { [] }
        func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)? { nil }
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
    
    final class MockStorage: StorageProvider, @unchecked Sendable {
        let tx = MockTx()
        
        func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
            try await block(tx)
        }
        
        // Unused
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
    
    final class MockConfig: Configurator, @unchecked Sendable {
        var configuredAssets: [UUID: [String: Any]] = [:]
        var configuredManufacturers: [UUID: [String: Any]] = [:]
        var configuredProducts: [UUID: [String: Any]] = [:]
        
        // Generic Implementations
        func configure<T: InventoryAsset>(_ instance: inout T, id: UUID?, name: String, type: String?, location: String?, acquisitionSource: String?, acquisitionDate: Date?, condition: String?, tags: [String], metadata: [String : String]) {
            instance.name = name
            instance.type = type
            instance.custodyLocation = location
            instance.acquisitionSource = acquisitionSource
            instance.acquisitionDate = acquisitionDate
            instance.condition = condition
            instance.tags = tags 
            instance.metadata = metadata
            configuredAssets[instance.id] = ["name": name, "type": type as Any]
        }
        
        func configure<T: Manufacturer>(_ instance: inout T, id: UUID?, name: String, slug: String, description: String?, metadata: [String : String], aliases: [String]) {
            instance.name = name
            instance.slug = slug
            configuredManufacturers[instance.id] = ["name": name]
        }
        
        func configure<T: Product>(_ instance: inout T, id: UUID?, title: String, description: String?, sku: String?, productType: String?, classification: String?, genre: String?, releaseDate: Date?, platform: String?) {
            instance.title = title
            configuredProducts[instance.id] = ["title": title]
        }

        func configure<T: Space>(_ instance: inout T, id: UUID?, name: String, geoLocation: InventoryGeoLocation?) {}
        func configure<T: Vendor>(_ instance: inout T, id: UUID?, name: String, address: (any Address)?, inceptionDate: Date?, websites: [URL], contactEmail: String?, contactPhone: String?, metadata: [String : String]) {}
        func configure<T: Address>(_ instance: inout T, id: UUID?, label: String?, address: String, address2: String?, city: String, region: String?, postalCode: String, country: String, notes: String?, imageIDs: [UUID]) {}
        func configure<T: Contact>(_ instance: inout T, id: UUID?, name: String, title: String?, email: String?, notes: String?, socialMedia: SocialMedia) {}
        func configure<T: InventorySourceCode>(_ instance: inout T, url: URL, notes: String?) {}
        func configure<T: InventorySystemRequirements>(_ instance: inout T, minMemory: Int64?, recommendedMemory: Int64?, cpuFamily: String?, minCpuSpeedMHz: Double?, video: String?, audio: String?, osName: String?, minOsVersion: String?) {}
    }
    
    // Minimal Models
    final class MockManufacturer: ReferenceManufacturer, @unchecked Sendable {
        var id: UUID = UUID()
        var name: String = ""
        var slug: String = ""
        var description: String?
        var metadata: [String : String] = [:]
        var aliases: [String] = []
        var websites: [URL] = []
        
        var alsoKnownAs: [String] = []
        var alternativeSpellings: [String] = []
        var commonMisspellings: [String] = []
        var addresses: [any Address] = []
        var email: String?
        var associatedPeople: [any Contact] = []
        var developers: [any Contact] = []
        
        // ReferenceManufacturer Reqs
        var images: [ReferenceItem] = []
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: MockManufacturer, rhs: MockManufacturer) -> Bool { lhs.id == rhs.id }
    }
    
    final class MockAsset: InventoryAsset, @unchecked Sendable {
        var id: UUID = UUID()
        var name: String = ""
        var manufacturer: (any Manufacturer)?
        
        // Protocol Reqs
        var metadata: [String : String] = [:]
        
        // InventoryAssetIdentificationProtocol
        var type: String?
        var typeIdentifier: String { type ?? "mock" }
        var identifiers: [any InventoryIdentifier] = []
        var accessionNumber: String?
        var productID: UUID?
        
        // InventoryAssetLocationProtocol

        var custodyLocation: String?
        var provenance: String?
        
        // InventoryAssetAcquisitionProtocol
        var acquisitionSource: String?
        var acquisitionDate: Date?
        
        // InventoryAssetTaggingProtocol
        var tags: [String] = []
        var forensicClassification: String?
        var relationshipType: AssetRelationshipType?
        
        var specifications: [String : String] = [:]
        
        // InventoryCompoundBase Reqs
        var title: String = ""
        var description: String?
        var releaseDate: Date?
        var dataSource: (any DataSource)?
        var children: [any InventoryItem] = []
        var images: [any InventoryItem] = []
        
        // InventoryAssetProtocol Extras
        var copyrightRegistration: String?
        var condition: String?
        
        // Rich Data Models (Getters)
        var source: (any InventorySource)? { nil }
        var lifecycle: (any InventoryLifecycle)? { nil }
        var health: (any InventoryHealth)? { nil }
        var mro: (any InventoryMROInfo)? { nil }
        var copyright: (any CopyrightInfo)? { nil }
        
        // Graph
        var components: [any InventoryComponentLink] { [] }
        var relationshipRequirements: [any InventoryRelationshipRequirement] = []
        var linkedAssets: [any InventoryLinkedAsset] = []
        
        // InventoryItem Conformance
        var sizeOrWeight: Int64? = nil
        var fileHashes: [String : String]? = nil
        var serialNumber: String? = nil
        var typeClassifier: ItemClassifierType { .physicalItem }
        var mediaFormat: MediaFormatType? = nil
        var container: (any ItemContainer)? = nil
        var location: ItemLocationType? = nil
        var sourceCode: (any InventorySourceCode)? = nil
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: MockAsset, rhs: MockAsset) -> Bool { lhs.id == rhs.id }
    }
    
    final class MockProduct: ReferenceProduct, @unchecked Sendable {
        var id: UUID = UUID()
        var title: String = ""
        var manufacturer: (any Manufacturer)?
        var platform: String?
        var releaseDate: Date?
        
        var description: String?
        var metadata: [String : String] = [:]
        
        var sku: String?
        var productType: String?
        var classification: String?
        var genre: String?
        
        // ReferenceProduct Reqs
        var referenceProductID: InventoryIdentifier?
        var identifiers: [any InventoryIdentifier] = []
        var sourceCode: (any InventorySourceCode)?
        var publisher: String?
        var developer: String?
        var creator: String?
        var productionDate: Date?
        var systemRequirements: (any InventorySystemRequirements)?
        var version: String?
        
        var instanceIDs: [UUID] = []
        var artworkIDs: [UUID] = []
        var screenshotIDs: [UUID] = []
        var instructionIDs: [UUID] = []
        var collectionIDs: [UUID] = []
        
        var references: [String: String] = [:] 
        var manualUrls: [URL]?
        
        // InventoryCompoundBase Reqs
        var dataSource: (any DataSource)?
        var children: [any InventoryItem] = []
        var images: [any InventoryItem] = []
        
        // ReferenceProduct Specifics
        var wikipediaUrl: URL?
        var purchaseUrl: URL?
        var originCountry: String?
        var discontinuedYear: Int?
        var platforms: [String]?
        var copyrightRegistration: String? 
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: MockProduct, rhs: MockProduct) -> Bool { lhs.id == rhs.id }
    }
    
    // MARK: - Tests
    
    func testIngestAsset_NewManufacturer() async throws {
        let storage = MockStorage()
        let config = MockConfig()
        let service = InventoryTransactionService(storage: storage, configurator: config)
        
        
        let input = AssetImportData(
            name: "My Retro CF",
            manufacturerName: "RetroWidgets",
            type: "Hardware",
            location: "Shelf A",
            acquisitionSource: "Shop",
            acquisitionDate: Date(),
            tags: ["Rare", "Boxed"],
            metadata: ["Color": "Beige"]
        )
        
        
        let assetID = try await service.ingestAsset(input)
        
        // Assert
        XCTAssertEqual(storage.tx.createdAssets.count, 1)
        XCTAssertEqual(storage.tx.createdAssets.first?.id, assetID)
        XCTAssertEqual(storage.tx.createdAssets.first?.name, "My Retro CF")
        XCTAssertEqual(storage.tx.createdManufacturers.first?.name, "RetroWidgets")
    }
    
    func testIngestAsset_ExistingManufacturer() async throws {
        let storage = MockStorage()
        let config = MockConfig()
        let existingMfg = MockManufacturer()
        existingMfg.name = "Commodore"
        storage.tx.existingManufacturer = existingMfg
        
        let service = InventoryTransactionService(storage: storage, configurator: config)
        
        let input = AssetImportData(
            name: "Amiga 500",
            manufacturerName: "Commodore"
        )
        
        _ = try await service.ingestAsset(input)
        
        XCTAssertEqual(storage.tx.createdManufacturers.count, 0, "Should use existing")
        XCTAssertEqual(storage.tx.createdAssets.first?.manufacturer?.id, existingMfg.id)
        XCTAssertNotNil(storage.tx.createdAssets.first?.manufacturer)
    }
    
    // MARK: - Integration Style Tests
    
    // Note: Integration tests requiring persistent state across transactions 
    // are skipped here as MockStorage does not support it.
    // Logic is verified via unit tests above.
    
    // MARK: - Product Tests
    
    func testIngestProduct() async throws {
        let storage = MockStorage()
        let config = MockConfig()
        let service = InventoryTransactionService(storage: storage, configurator: config)
        
        let input = ProductImportData(
            title: "Super Game",
            manufacturerName: "GameCo"
        )
        
        let productID = try await service.ingestProduct(input)
        
        XCTAssertEqual(storage.tx.createdManufacturers.count, 1)
        XCTAssertEqual(storage.tx.createdManufacturers.first?.name, "GameCo")
        XCTAssertEqual(storage.tx.createdProducts.count, 1)
        XCTAssertEqual(storage.tx.createdProducts.first?.id, productID)
        XCTAssertNotNil(storage.tx.createdProducts.first?.manufacturer)
    }
    
    func testIngestProductWithExistingMfg() async throws {
        let storage = MockStorage()
        let config = MockConfig()
        let existingMfg = MockManufacturer()
        existingMfg.name = "Sega"
        storage.tx.existingManufacturer = existingMfg
        
        let service = InventoryTransactionService(storage: storage, configurator: config)
        
        let input = ProductImportData(
            title: "Sonic",
            manufacturerName: "Sega"
        )
        
        _ = try await service.ingestProduct(input)
        
        XCTAssertEqual(storage.tx.createdManufacturers.count, 0)
        XCTAssertEqual(storage.tx.createdProducts.first?.manufacturer?.id, existingMfg.id)
    }
}
