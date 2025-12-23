import XCTest
import InventoryCore
import InventoryTypes

final class ConfiguratorTests: XCTestCase {
    
    var configurator: Configurator!
    
    override func setUp() {
        super.setUp()
        configurator = MockConfigurator()
    }
    
    func testConfigureSystemRequirements() {
        var reqs = MockSystemRequirements() // Empty struct
        
        configurator.configure(
            &reqs,
            minMemory: 640_000,
            recommendedMemory: 1024_000,
            cpuFamily: "x86",
            minCpuSpeedMHz: 4.77,
            video: "CGA",
            audio: "PC Speaker",
            osName: "MS-DOS",
            minOsVersion: "2.1"
        )
        
        XCTAssertEqual(reqs.minMemory, 640_000)
        XCTAssertEqual(reqs.cpuFamily, "x86")
        XCTAssertEqual(reqs.video, "CGA")
    }
    
    func testConfigureAddress() {
        var address = MockAddress(
            address: "", postalCode: "", country: "" // Minimal init
        )
        
        let id = UUID()
        configurator.configure(
            &address,
            id: id,
            label: "HQ",
            address: "1 Infinite Loop",
            address2: nil,
            city: "Cupertino",
            region: "CA",
            postalCode: "95014",
            country: "USA",
            notes: "Apple HQ",
            imageIDs: []
        )
        
        XCTAssertEqual(address.id, id)
        XCTAssertEqual(address.address, "1 Infinite Loop")
        XCTAssertEqual(address.city, "Cupertino")
        XCTAssertEqual(address.region, "CA")
    }
    
    func testConfigureContact() {
        var contact = MockContact(name: "") // Minimal init
        let social = SocialMedia(xAccount: "@retro")
        
        configurator.configure(
            &contact,
            id: UUID(),
            name: "Rick",
            title: "Collector",
            email: "rick@retro.com",
            notes: nil,
            socialMedia: social
        )
        
        XCTAssertEqual(contact.name, "Rick")
        XCTAssertEqual(contact.title, "Collector")
        XCTAssertEqual(contact.socialMedia.xAccount, "@retro")
    }
    
    func testConfigureSourceCode() {
        var source = MockSourceCode(url: URL(string: "http://example.com")!) // Minimal init
        let url = URL(string: "https://github.com/retro/data")!
        
        configurator.configure(
            &source,
            url: url,
            notes: "Open Source"
        )
        
        XCTAssertEqual(source.url, url)
        XCTAssertEqual(source.notes, "Open Source")
    }
}
