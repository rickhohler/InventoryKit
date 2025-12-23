import Foundation
import InventoryTypes

/// A configurator responsible for populating instances of InventoryKit protocols.
///
/// This follows the Configurator pattern to support dependency injection and population
/// of existing instances (e.g. SwiftData models, Core Data managed objects).
///
/// Use `configure(_:...)` to populate the properties of an object.
public protocol Configurator: Sendable {
    
    // MARK: - Systems & Logic
    
    /// Configures a system requirements object with the provided values.
    func configure<T: InventorySystemRequirements>(
        _ instance: inout T,
        minMemory: Int64?,
        recommendedMemory: Int64?,
        cpuFamily: String?,
        minCpuSpeedMHz: Double?,
        video: String?,
        audio: String?,
        osName: String?,
        minOsVersion: String?
    )
    
    // MARK: - Metadata & People
    
    /// Configures an address object.
    func configure<T: Address>(
        _ instance: inout T,
        id: UUID?,
        label: String?,
        address: String,
        address2: String?,
        city: String,
        region: String?, // State/Province
        postalCode: String,
        country: String,
        notes: String?,
        imageIDs: [UUID]
    )
    
    /// Configures a contact object.
    func configure<T: Contact>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        title: String?,
        email: String?,
        notes: String?,
        socialMedia: SocialMedia
    )
    
    // MARK: - Assets & Source
    
    /// Configures a source code reference object.
    func configure<T: InventorySourceCode>(
        _ instance: inout T,
        url: URL,
        notes: String?
    )
    // MARK: - Core Entities
    
    /// Configures a manufacturer object.
    func configure<T: Manufacturer>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        slug: String,
        description: String?,
        metadata: [String: String],
        aliases: [String]
    )
    
    /// Configures a product object.
    func configure<T: Product>(
        _ instance: inout T,
        id: UUID?,
        title: String,
        description: String?,
        sku: String?,
        productType: String?,
        classification: String?,
        genre: String?,
        releaseDate: Date?,
        platform: String?
    )

    
    /// Configures an asset object.
    func configure<T: InventoryAsset>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        type: String?,
        location: String?,
        acquisitionSource: String?,
        acquisitionDate: Date?,
        condition: String?,
        tags: [String],
        metadata: [String: String]
    )
    // MARK: - Spaces & Vendors
    
    /// Configures a space object.
    func configure<T: Space>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        geoLocation: InventoryGeoLocation?
    )
    
    /// Configures a vendor object.
    func configure<T: Vendor>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        address: (any Address)?,
        inceptionDate: Date?,
        websites: [URL],
        contactEmail: String?,
        contactPhone: String?,
        metadata: [String: String]
    )
}
