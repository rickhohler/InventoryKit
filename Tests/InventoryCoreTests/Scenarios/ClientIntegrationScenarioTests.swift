import XCTest
import InventoryCore
@testable import InventoryCoreTests

// MARK: - 1. Client Concrete Types (Simulation)
// In a real app, these would be your Core Data entities or SwiftData models.
// They must conform to the InventoryKit protocols and have mutable properties.

typealias ClientAddress = MockAddress
typealias ClientContact = MockContact
typealias ClientSystemRequirements = MockSystemRequirements
typealias ClientSourceCode = MockSourceCode

// MARK: - 2. Client Configurator Implementation
// The client must implement this protocol to bridge InventoryKit logic to their types.

struct ClientConfigurator: InventoryConfigurator {
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
    ) {
        // Map values to your concrete type's properties
        if let minMemory { instance.minMemory = minMemory }
        if let recommendedMemory { instance.recommendedMemory = recommendedMemory }
        if let cpuFamily { instance.cpuFamily = cpuFamily }
        if let minCpuSpeedMHz { instance.minCpuSpeedMHz = minCpuSpeedMHz }
        if let video { instance.video = video }
        if let audio { instance.audio = audio }
        if let osName { instance.osName = osName }
        if let minOsVersion { instance.minOsVersion = minOsVersion }
    }

    func configure<T: InventoryAddress>(
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

    func configure<T: InventoryContact>(
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

    func configure<T: InventorySourceCode>(
        _ instance: inout T,
        url: URL,
        notes: String?
    ) {
        instance.url = url
        if let notes { instance.notes = notes }
    }
    // MARK: - Core Entities
    
    func configure<T: InventoryManufacturer>(
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
    
    func configure<T: InventoryProduct>(
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

// MARK: - 3. Client Integration Scenario

final class ClientIntegrationScenarioTests: XCTestCase {
    
    // The Configurator instance used by the app
    var configurator: InventoryConfigurator!
    
    override func setUp() {
        super.setUp()
        configurator = ClientConfigurator()
    }
    
    func testPopulationPattern_SystemRequirements() {
        // 1. Client creates an instance (e.g. new Core Data object, or empty struct)
        var clientReqs = ClientSystemRequirements()
        
        // 2. InventoryKit Service (simulated) calls the configurator to populate it
        // In a real scenario, this happens inside an EnrichmentService or ImportService
        configurator.configure(
            &clientReqs,
            minMemory: 640_000, // 640KB
            recommendedMemory: nil,
            cpuFamily: "x86",
            minCpuSpeedMHz: 4.77,
            video: "CGA",
            audio: nil,
            osName: "DOS",
            minOsVersion: "2.1"
        )
        
        // 3. Verify the client object is populated
        XCTAssertEqual(clientReqs.minMemory, 640_000)
        XCTAssertEqual(clientReqs.cpuFamily, "x86")
        XCTAssertEqual(clientReqs.video, "CGA")
    }
    
    func testDeterministicIDs_Manufacturer() {
        // 1. We want to import "Apple Computer"
        let name = "Apple Computer"
        
        // 2. Generate a Deterministic ID (UUIDv5) based on the manufacturer namespace
        // This ensures that "Apple Computer" always gets the same UUID in our system,
        // preventing duplicates across different imports.
        let mfgID = InventoryIDGenerator.generate(for: .manufacturer, name: name)
        
        // 3. Create a Client Contact (representing the Manufacturer)
        // We initialize it with blank data, then populate it.
        var clientManufacturer = ClientContact(name: "")
        
        // 4. Populate it via Configurator
        configurator.configure(
            &clientManufacturer,
            id: mfgID, // Pass the deterministic ID
            name: name,
            title: nil,
            email: "contact@apple.com",
            notes: "Cupertino",
            socialMedia: SocialMedia()
        )
        
        // 5. implementation Verification
        XCTAssertEqual(clientManufacturer.name, "Apple Computer")
        // Verify the ID is consistent (re-generating it should match)
        XCTAssertEqual(clientManufacturer.id, InventoryIDGenerator.generate(for: .manufacturer, name: name))
    }
    
    func testPopulationPattern_Address() {
        var clientAddress = ClientAddress(address: "")
        let id = UUID()
        
        configurator.configure(
            &clientAddress,
            id: id,
            label: "HQ",
            address: "1 Infinite Loop",
            address2: nil,
            city: "Cupertino",
            region: "CA",
            postalCode: "95014",
            country: "USA",
            notes: nil,
            imageIDs: []
        )
        
        XCTAssertEqual(clientAddress.city, "Cupertino")
        XCTAssertEqual(clientAddress.postalCode, "95014")
        XCTAssertEqual(clientAddress.id, id)
    }
}
