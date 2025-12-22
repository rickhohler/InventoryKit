import Foundation
import InventoryCore

/// A mock configurator for use in unit tests.
public struct MockInventoryConfigurator: InventoryConfigurator {
    
    public init() {}
    
    // MARK: - Systems & Logic
    
    public func configure<T: InventorySystemRequirements>(
        _ instance: inout T,
        minMemory: Int64?,
        recommendedMemory: Int64?,
        cpuFamily: String?,
        minCpuSpeedMHz: Double?,
        video: String?,
        audio: String?,
        osName: String?,
        minOsVersion: String?
    ) {
        if let minMemory { instance.minMemory = minMemory }
        if let recommendedMemory { instance.recommendedMemory = recommendedMemory }
        if let cpuFamily { instance.cpuFamily = cpuFamily }
        if let minCpuSpeedMHz { instance.minCpuSpeedMHz = minCpuSpeedMHz }
        if let video { instance.video = video }
        if let audio { instance.audio = audio }
        if let osName { instance.osName = osName }
        if let minOsVersion { instance.minOsVersion = minOsVersion }
    }
    
    // MARK: - Metadata & People
    
    public func configure<T: InventoryAddress>(
        _ instance: inout T,
        id: UUID?,
        label: String?,
        address: String,
        address2: String?,
        city: String,
        region: String?,
        postalCode: String,
        country: String,
        notes: String?,
        imageIDs: [UUID]
    ) {
        if let id { instance.id = id }
        if let label { instance.label = label }
        instance.address = address
        if let address2 { instance.address2 = address2 }
        instance.city = city
        if let region { instance.region = region }
        instance.postalCode = postalCode
        instance.country = country
        if let notes { instance.notes = notes }
    }
    
    public func configure<T: InventoryContact>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        title: String?,
        email: String?,
        notes: String?,
        socialMedia: SocialMedia
    ) {
        if let id { instance.id = id }
        instance.name = name
        if let title { instance.title = title }
        if let email { instance.email = email }
        if let notes { instance.notes = notes }
        instance.socialMedia = socialMedia
    }
    
    // MARK: - Assets & Source
    
    public func configure<T: InventorySourceCode>(
        _ instance: inout T,
        url: URL,
        notes: String?
    ) {
        instance.url = url
        if let notes { instance.notes = notes }
    }
    
    // MARK: - Core Entities
    
    public func configure<T: InventoryManufacturer>(
        _ instance: inout T,
        id: UUID?,
        name: String,
        slug: String,
        description: String?,
        metadata: [String: String],
        aliases: [String]
    ) {
        if let id { instance.id = id }
        instance.name = name
        instance.slug = slug
        if let description { instance.description = description }
        instance.metadata = metadata
        instance.aliases = aliases
    }
    
    public func configure<T: InventoryProduct>(
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
    ) {
        if let id { instance.id = id }
        instance.title = title
        if let description { instance.description = description }
        if let sku { instance.sku = sku }
        if let productType { instance.productType = productType }
        if let classification { instance.classification = classification }
        if let genre { instance.genre = genre }
        if let releaseDate { instance.releaseDate = releaseDate }
        if let platform { instance.platform = platform }
    }
}
