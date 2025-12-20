import Foundation
import InventoryCore

// MARK: - Mock User Data Store
public actor MockUserDataStore: UserDataStoreProtocol {
    private var files: [UUID: Data] = [:]
    
    public init() {}
    
    public func fileExists(for assetID: UUID) async -> Bool {
        files[assetID] != nil
    }
    
    public func fileURL(for assetID: UUID) async throws -> URL {
        // Return a dummy URL, but if asserting file existence via API, fileExists is key.
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

// MARK: - Mock Domain Data Store
public actor MockDomainDataStore: DomainDataStoreProtocol {
    public init() {}
    
    public func isCached(for resourceID: String) async -> Bool { false }
    public func fileURL(for resourceID: String) async throws -> URL { URL(fileURLWithPath: "/dev/null") }
    public func cache(resourceID: String, from remoteURL: URL) async throws {}
    public func purge(resourceID: String) async throws {}
    public func size(of resourceID: String) async throws -> Int64? { nil }
}

// MARK: - Mock User Metadata Store
public actor MockUserMetadataStore: UserMetadataStoreProtocol {
    private var assets: [UUID: any InventoryAssetProtocol] = [:]
    
    public init() {}
    
    public func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAssetProtocol] {
        Array(assets.values)
    }
    
    public func retrieveAsset(id: UUID) async throws -> (any InventoryAssetProtocol)? {
        assets[id]
    }
    
    public func saveAsset(_ asset: any InventoryAssetProtocol) async throws {
        assets[asset.id] = asset
    }
    
    public func deleteAsset(id: UUID) async throws {
        assets.removeValue(forKey: id)
    }
    
    public func fetchPersonalCollections(matching query: StorageQuery) async throws -> [any InventoryCollectionProtocol] { [] }
    public func saveCollection(_ collection: any InventoryCollectionProtocol) async throws {}
    public func deleteCollection(id: UUID) async throws {}
    
    public func performBatch(operations: @escaping () async throws -> Void) async throws {
        try await operations()
    }
}

// MARK: - Mock Domain Metadata Store
public actor MockDomainMetadataStore: DomainMetadataStoreProtocol {
    public init() {}
    
    public func fetchProducts(matching query: StorageQuery) async throws -> [any InventoryProductProtocol] { [] }
    public func retrieveProduct(id: UUID) async throws -> (any InventoryProductProtocol)? { nil }
    public func saveProduct(_ product: any InventoryProductProtocol) async throws {}
    
    public func fetchPublicCollections(matching query: StorageQuery) async throws -> [any InventoryCollectionProtocol] { [] }
    public func saveCollection(_ collection: any InventoryCollectionProtocol) async throws {}
}

// MARK: - Mock Storage Provider
public struct MockStorageProvider: StorageProviderProtocol {
    public var userMetadata: any UserMetadataStoreProtocol
    public var domainMetadata: any DomainMetadataStoreProtocol
    public var userData: any UserDataStoreProtocol
    public var domainData: any DomainDataStoreProtocol
    
    public init(
        userMetadata: any UserMetadataStoreProtocol = MockUserMetadataStore(),
        domainMetadata: any DomainMetadataStoreProtocol = MockDomainMetadataStore(),
        userData: any UserDataStoreProtocol = MockUserDataStore(),
        domainData: any DomainDataStoreProtocol = MockDomainDataStore()
    ) {
        self.userMetadata = userMetadata
        self.domainMetadata = domainMetadata
        self.userData = userData
        self.domainData = domainData
    }
}
