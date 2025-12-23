import XCTest
import InventoryCore
import InventoryTypes

final class RetroSoftwareTests: XCTestCase {

    var configurator: Configurator!
    
    override func setUp() {
        super.setUp()
        configurator = MockConfigurator()
    }
    
    func testKaratekaModel() {
        // Data from RetroData/titles.json (Karateka)
        // ...
        
        // 1. Setup Manufacturer (Publisher)
        var broderbund = MockReferenceManufacturer(slug: "", name: "") // Minimal Init
        
        configurator.configure(
            &broderbund,
            id: UUID(), // In real app, uuidv5 from "broderbund"
            name: "Broderbund",
            slug: "broderbund",
            description: nil,
            metadata: [:],
            aliases: []
        )
        
        // 2. Setup Product
        var karateka = MockReferenceProduct(title: "") // Minimal Init
        
        configurator.configure(
            &karateka,
            id: UUID(uuidString: "F1ABD7C5-1613-4855-8798-D112EA7A679D"),
            title: "Karateka",
            description: "Karate (空手), also karate-do...",
            sku: nil,
            productType: "Software",
            classification: "Game",
            genre: "Fighting",
            releaseDate: Date(timeIntervalSince1970: 441763200), // ~1984
            platform: "Apple II, C64, DOS, NES, Atari 8-bit" // PlatformType is string in protocol, array in ReferenceProduct specific?
            // Protocol has 'platform: String?'. ReferenceProduct also has 'platforms: [String]?'.
            // Configurator only supports generic 'platform: String?'.
            // If ReferenceProduct has `platforms` [String], we might need specific handling or just stick to generic protocol config.
            // MockReferenceProduct.platform is String?. MockReferenceProduct.platforms is [String]?.
            // We'll configure the generic 'platform' string for now.
        )
        
        // Manually set manufacturer since it's a relationship, not a simple property in Configurator yet?
        // Or Configurator could support relationships?
        // Protocol 'Product' has 'manufacturer: (any Manufacturer)? { get }' which implies we can't set it unless we use 'mutating func setManufacturer' or cast to concrete type.
        // MockReferenceProduct properties are vars now. So we can set it manually *after* configuration.
        // This is acceptable for unit tests.
        karateka.manufacturer = broderbund
        
        // 3. Verification
        XCTAssertEqual(karateka.title, "Karateka")
        XCTAssertEqual(karateka.manufacturer?.name, "Broderbund")
        // XCTAssertEqual(karateka.platforms?.count, 5) // platforms is [String]?, configured via platform String?
        // Since we only configured 'platform' (String), 'platforms' (Array) is likely nil unless Configurator logic splits it.
        // MockConfigurator logic: `if let platform { instance.platform = platform }`.
        // So 'platform' string is set.
        XCTAssertEqual(karateka.platform, "Apple II, C64, DOS, NES, Atari 8-bit")
        XCTAssertEqual(karateka.id.uuidString, "F1ABD7C5-1613-4855-8798-D112EA7A679D")
        
        // 4. Verify Protocol Conformance
        XCTAssertEqual(karateka.title, "Karateka")
    }
}
