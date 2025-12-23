import Foundation
import InventoryCore
import InventoryTypes

public struct MockReferenceManufacturer: ReferenceManufacturer, Sendable {
    public var id: UUID
    public var slug: String
    public var name: String
    public var aliases: [String] = []
    public var description: String? = nil
    public var metadata: [String: String] = [:]
    
    public init(id: UUID = UUID(), slug: String, name: String, aliases: [String] = [], description: String? = nil, metadata: [String: String] = [:], images: [ReferenceItem] = []) {
        self.id = id
        self.slug = slug
        self.name = name
        self.aliases = aliases
        self.description = description
        self.metadata = metadata
        self.images = []
    }
    
    public var images: [ReferenceItem] = []
}

public struct MockReferenceLibrary: ReferenceLibrary, Sendable {
    public var id: UUID
    public var name: String
    public var url: URL?
    public var transport: String?
    public var adapter: String?
    public var type: DataSourceType
    public var isVerified: Bool
    
    public init(id: UUID = UUID(), name: String, url: URL? = nil, transport: String? = nil, adapter: String? = nil, type: DataSourceType = .archive, isVerified: Bool = true) {
        self.id = id
        self.name = name
        self.url = url
        self.transport = transport
        self.adapter = adapter
        self.type = type
        self.isVerified = isVerified
    }
}

public struct MockReferenceProduct: ReferenceProduct, Sendable {
    // InventoryCompoundBase
    public var id: UUID
    public var title: String
    public var description: String?
    public var manufacturer: (any Manufacturer)?
    public var releaseDate: Date?
    public var dataSource: (any DataSource)?
    public var children: [any InventoryItem]
    public var images: [any InventoryItem]
    
    // Product
    public var sku: String?
    public var productType: String?
    public var classification: String?
    public var genre: String?
    public var publisher: String?
    public var developer: String?
    public var creator: String?
    public var productionDate: Date?
    public var platform: String?
    public var systemRequirements: (any InventorySystemRequirements)?
    public var version: String?
    public var identifiers: [any InventoryIdentifier]
    public var instanceIDs: [UUID]
    public var artworkIDs: [UUID]
    public var screenshotIDs: [UUID]
    public var instructionIDs: [UUID]
    public var collectionIDs: [UUID]
    public var references: [String: String]
    public var metadata: [String: String]
    
    // ReferenceProduct Specifics
    public var wikipediaUrl: URL?
    public var purchaseUrl: URL?
    public var originCountry: String?
    public var discontinuedYear: Int?
    public var platforms: [String]?
    public var copyrightRegistration: String?
    public var manualUrls: [URL]?
    
    
    // Protocol requirement for foreign key
    public var referenceProductID: InventoryIdentifier? = nil

    public var sourceCode: (any InventorySourceCode)?

    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        manufacturer: (any Manufacturer)? = nil,
        releaseDate: Date? = nil,
        dataSource: (any DataSource)? = nil,
        children: [any InventoryItem] = [],
        images: [any InventoryItem] = [],
        
        sku: String? = nil,
        productType: String? = "Software",
        classification: String? = nil,
        genre: String? = nil,
        publisher: String? = nil,
        developer: String? = nil,
        creator: String? = nil,
        productionDate: Date? = nil,
        platform: String? = nil,
        systemRequirements: (any InventorySystemRequirements)? = nil,
        version: String? = nil,
        identifiers: [any InventoryIdentifier] = [],
        
        wikipediaUrl: URL? = nil,
        purchaseUrl: URL? = nil,
        originCountry: String? = nil,
        discontinuedYear: Int? = nil,
        platforms: [String]? = nil,
        copyrightRegistration: String? = nil,
        manualUrls: [URL]? = nil,
        sourceCode: (any InventorySourceCode)? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.manufacturer = manufacturer
        self.releaseDate = releaseDate
        self.dataSource = dataSource
        self.children = children
        self.images = images
        
        self.sku = sku
        self.productType = productType
        self.classification = classification
        self.genre = genre
        self.publisher = publisher
        self.developer = developer
        self.creator = creator
        self.productionDate = productionDate
        self.platform = platform
        self.systemRequirements = systemRequirements
        self.version = version
        self.identifiers = identifiers
        
        self.instanceIDs = []
        self.artworkIDs = []
        self.screenshotIDs = []
        self.instructionIDs = []
        self.collectionIDs = []
        self.references = [:]
        self.metadata = [:]
        
        self.wikipediaUrl = wikipediaUrl
        self.purchaseUrl = purchaseUrl
        self.originCountry = originCountry
        self.discontinuedYear = discontinuedYear
        self.platforms = platforms
        self.copyrightRegistration = copyrightRegistration
        self.manualUrls = manualUrls
        self.sourceCode = sourceCode
    }
    
    // Missing Protocol Stubs
    // referenceProductID already declared at line 90
}

public struct MockSystemRequirements: InventorySystemRequirements, Codable, Sendable {
    public var minMemory: Int64?
    public var recommendedMemory: Int64?
    public var cpuFamily: String?
    public var minCpuSpeedMHz: Double?
    public var video: String?
    public var audio: String?
    public var osName: String?
    public var minOsVersion: String?
    
    public init(minMemory: Int64? = nil,
                recommendedMemory: Int64? = nil,
                cpuFamily: String? = nil,
                minCpuSpeedMHz: Double? = nil,
                video: String? = nil,
                audio: String? = nil,
                osName: String? = nil,
                minOsVersion: String? = nil) {
        self.minMemory = minMemory
        self.recommendedMemory = recommendedMemory
        self.cpuFamily = cpuFamily
        self.minCpuSpeedMHz = minCpuSpeedMHz
        self.video = video
        self.audio = audio
        self.osName = osName
        self.minOsVersion = minOsVersion
    }
}

public struct MockReferenceCollection: ReferenceCollection, Sendable {
    public var id: UUID
    public var title: String
    public var description: String?
    public var dataSourceID: UUID?
    public var type: CollectionType
    public var visibility: CollectionVisibility
    public var category: CollectionCategoryType
    public var items: [InventoryResourceName]
    public var infoUrl: URL?
    public var metadata: [String: String]
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        dataSourceID: UUID? = nil,
        type: CollectionType = .public,
        visibility: CollectionVisibility = .shared,
        category: CollectionCategoryType = .unknown,
        items: [InventoryResourceName] = [],
        infoUrl: URL? = nil,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dataSourceID = dataSourceID
        self.type = type
        self.visibility = visibility
        self.category = category
        self.items = items
        self.infoUrl = infoUrl
        self.metadata = metadata
    }
}

public struct MockSourceCode: InventorySourceCode, Codable, Sendable, Hashable {
    public var url: URL
    public var notes: String?
    public var dateOpened: Date?
    public var license: String?
    
    public init(url: URL, 
                notes: String? = nil, 
                dateOpened: Date? = nil, 
                license: String? = nil) {
        self.url = url
        self.notes = notes
        self.dateOpened = dateOpened
        self.license = license
    }
}

public struct MockAddress: Address, Codable, Sendable {
    public var id: UUID
    public var label: String?
    public var address: String
    public var address2: String?
    public var city: String?
    public var region: String? // State/Province
    public var postalCode: String?
    public var country: String?
    public var notes: String?
    public var imageIDs: [UUID] = []
    
    public init(id: UUID = UUID(), label: String? = nil, address: String, address2: String? = nil, city: String? = nil, region: String? = nil, postalCode: String? = nil, country: String? = nil, notes: String? = nil, imageIDs: [UUID] = []) {
        self.id = id
        self.label = label
        self.address = address
        self.address2 = address2
        self.city = city
        self.region = region
        self.postalCode = postalCode
        self.country = country
        self.notes = notes
        self.imageIDs = imageIDs
    }
}

public struct MockContact: Contact, Codable, Sendable {
    public var id: UUID
    public var name: String
    public var title: String?
    public var email: String?
    public var phone: String?
    public var notes: String?
    public var socialMedia: SocialMedia
    public var imageIDs: [UUID] = []
    
    public init(id: UUID = UUID(), name: String, title: String? = nil, email: String? = nil, phone: String? = nil, notes: String? = nil, socialMedia: SocialMedia = SocialMedia(), imageIDs: [UUID] = []) {
        self.id = id
        self.name = name
        self.title = title
        self.email = email
        self.phone = phone
        self.notes = notes
        self.socialMedia = socialMedia
        self.imageIDs = imageIDs
    }
}
