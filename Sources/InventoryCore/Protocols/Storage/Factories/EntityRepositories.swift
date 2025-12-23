import Foundation
import InventoryTypes

// MARK: - Asset Repository

/// Repository responsible for managing user assets.
public protocol AssetRepository: EntityRepository where Entity == any InventoryAsset {
    /// Creates a concrete asset instance.
    func createAsset(id: UUID, name: String, provenance: String?, tags: [String], metadata: [String: String]) throws -> any InventoryAsset
}

// MARK: - Reference Product Repository

/// Repository responsible for managing reference products.
public protocol ReferenceProductRepository: EntityRepository where Entity == any ReferenceProduct {
}

// MARK: - Reference Manufacturer Repository

/// Repository responsible for managing reference manufacturers.
public protocol ReferenceManufacturerRepository: EntityRepository where Entity == any ReferenceManufacturer {
}

// MARK: - Reference Collection Repository

/// Repository responsible for managing reference collections.
public protocol ReferenceCollectionRepository: EntityRepository where Entity == any ReferenceCollection {
}

// MARK: - Contact Repository

/// Repository responsible for managing contacts.
public protocol ContactRepository: EntityRepository where Entity == any Contact {
}

// MARK: - Address Repository

/// Repository responsible for managing addresses.
public protocol AddressRepository: EntityRepository where Entity == any Address {
}

// MARK: - Space Repository

/// Repository responsible for managing inventory spaces.
public protocol SpaceRepository: EntityRepository where Entity == any Space {
    func createBuilding(id: UUID, name: String) throws -> any Building
    func createRoom(id: UUID, name: String, building: any Building) throws -> any Room
    func createDigitalVolume(id: UUID, name: String, uri: URL) throws -> any DigitalVolume
}

// MARK: - Vendor Repository

/// Repository responsible for managing vendors.
public protocol VendorRepository: EntityRepository where Entity == any Vendor {
}
