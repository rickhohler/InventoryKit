import Foundation
import InventoryTypes

/// A configurator that provides access to all entity factories.
/// This type serves as the central registry for the client's storage implementation choices.
public protocol StorageConfigurator: Sendable {
    // MARK: - Entity Repositories
    
    /// Repository for managing Assets.
    var assetRepository: any AssetRepository { get }
    
    /// Repository for managing Reference Products.
    var referenceProductRepository: any ReferenceProductRepository { get }
    
    /// Repository for managing Reference Manufacturers.
    var referenceManufacturerRepository: any ReferenceManufacturerRepository { get }
    
    /// Repository for managing Reference Collections.
    var referenceCollectionRepository: any ReferenceCollectionRepository { get }
    
    /// Repository for managing Contacts.
    var contactRepository: any ContactRepository { get }
    
    /// Repository for managing Addresses.
    var addressRepository: any AddressRepository { get }
    
    /// Repository for managing Spaces.
    var spaceRepository: any SpaceRepository { get }
    
    /// Repository for managing Vendors.
    var vendorRepository: any VendorRepository { get }
}
