import XCTest
@testable import InventoryCore
@testable import InventoryKit
@testable import InventoryTypes

final class MiscCoverageTests: XCTestCase {
    
    // MARK: - Bundle Extension
    
    func testBundleExtension() {
        let bundle = Bundle.inventoryKit
        XCTAssertNotNil(bundle)
        // Bundle ID might vary in test environment vs app, just ensuring it doesn't crash
    }
    
    // MARK: - System Singleton
    
    func testSystemConfiguration() {
        let system = System.shared
        XCTAssertNotNil(system)
        
        struct MockStorageProvider: StorageProvider {
            var assetRepository: any AssetRepository { fatalError() }
            var productRepository: any ReferenceProductRepository { fatalError() }
            var manufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
            var referenceProductRepository: any ReferenceProductRepository { fatalError() }
            var referenceManufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
            var referenceCollectionRepository: any ReferenceCollectionRepository { fatalError() }
            var collectionRepository: any ReferenceCollectionRepository { fatalError() }
            var spaceRepository: any SpaceRepository { fatalError() }
            var vendorRepository: any VendorRepository { fatalError() }
            var contactRepository: any ContactRepository { fatalError() }
            var addressRepository: any AddressRepository { fatalError() }
            
            var userMetadata: any UserMetadataStore { fatalError() }
            var referenceMetadata: any ReferenceMetadataStore { fatalError() }
            var userData: any UserDataStore { fatalError() }
            var referenceData: any ReferenceDataStore { fatalError() }
            
            func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
                fatalError()
            }
        }
        
        let mock = MockStorageProvider()
        system.configure(with: mock)
        
        XCTAssertNotNil(system.storageConfigurator)
    }
    
    // MARK: - InventoryKit Initialization
    
    func testInventoryKitInit() {
        struct MockStorage: StorageProvider {
            var assetRepository: any AssetRepository { fatalError() }
            var productRepository: any ReferenceProductRepository { fatalError() }
            var manufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
            var referenceProductRepository: any ReferenceProductRepository { fatalError() }
            var referenceManufacturerRepository: any ReferenceManufacturerRepository { fatalError() }
            var referenceCollectionRepository: any ReferenceCollectionRepository { fatalError() }
            var collectionRepository: any ReferenceCollectionRepository { fatalError() }
            var spaceRepository: any SpaceRepository { fatalError() }
            var vendorRepository: any VendorRepository { fatalError() }
            var contactRepository: any ContactRepository { fatalError() }
            var addressRepository: any AddressRepository { fatalError() }
            
            var userMetadata: any UserMetadataStore { fatalError() }
            var referenceMetadata: any ReferenceMetadataStore { fatalError() }
            var userData: any UserDataStore { fatalError() }
            var referenceData: any ReferenceDataStore { fatalError() }
            
            func performTransaction<R>(_ block: @escaping @Sendable (any Transaction) async throws -> R) async throws -> R {
                 fatalError()
            }
        }
        
        final class MockConfig: Configurator, @unchecked Sendable {
              func configure<T>(
                _ instance: inout T,
                minMemory: Int64?,
                recommendedMemory: Int64?,
                cpuFamily: String?,
                minCpuSpeedMHz: Double?,
                video: String?,
                audio: String?,
                osName: String?,
                minOsVersion: String?
            ) where T : InventorySystemRequirements {} 
            
            func configure<T>(_ instance: inout T, id: UUID?, label: String?, address: String, address2: String?, city: String, region: String?, postalCode: String, country: String, notes: String?, imageIDs: [UUID]) where T : Address {}
            func configure<T>(_ instance: inout T, id: UUID?, name: String, title: String?, email: String?, notes: String?, socialMedia: SocialMedia) where T : Contact {}
            func configure<T>(_ instance: inout T, url: URL, notes: String?) where T : InventorySourceCode {}
            func configure<T>(_ instance: inout T, id: UUID?, name: String, slug: String, description: String?, metadata: [String : String], aliases: [String]) where T : Manufacturer {}
            func configure<T>(_ instance: inout T, id: UUID?, title: String, description: String?, sku: String?, productType: String?, classification: String?, genre: String?, releaseDate: Date?, platform: String?) where T : Product {}
            func configure<T>(_ instance: inout T, id: UUID?, name: String, geoLocation: InventoryGeoLocation?) where T : Space {}
            func configure<T>(_ instance: inout T, id: UUID?, name: String, address: (any Address)?, inceptionDate: Date?, websites: [URL], contactEmail: String?, contactPhone: String?, metadata: [String : String]) where T : Vendor {}
            func configure<T>(_ instance: inout T, id: UUID?, name: String, type: String?, location: String?, acquisitionSource: String?, acquisitionDate: Date?, condition: String?, tags: [String], metadata: [String : String]) where T : InventoryAsset {}
        }

        // InventoryKit.swift needs StorageProvider and Configurator
        let kit = InventoryKit(storage: MockStorage(), configurator: MockConfig())
        XCTAssertNotNil(kit.context)
        XCTAssertNotNil(kit.storage)
        XCTAssertNotNil(kit.configurator)
    }
    
    // MARK: - InventoryValidationError Description
    
    func testValidationErrorDescriptions() {
        let err1 = InventoryValidationError.missingRequiredField(field: "name", reason: "empty")
        XCTAssertEqual(err1.description, "Missing required field 'name': empty")
        
        let err2 = InventoryValidationError.invalidFormat(field: "email", reason: "bad")
        XCTAssertEqual(err2.description, "Invalid format for 'email': bad")
        
        let err3 = InventoryValidationError.businessRuleViolation(rule: "rule1")
        XCTAssertEqual(err3.description, "Business rule violation: rule1")
        
        let err4 = InventoryValidationError.validationFailed(errors: ["e1", "e2"])
        XCTAssertEqual(err4.description, "Validation failed with errors: e1, e2")
    }
}
