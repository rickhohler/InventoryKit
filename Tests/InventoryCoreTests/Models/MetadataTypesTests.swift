import XCTest
import InventoryCore

final class MetadataTypesTests: XCTestCase {

    // MARK: - SourceCode
    
    func testSourceCode() throws {
        let url = URL(string: "https://github.com/example/repo")!
        let sc = SourceCode(url: url, notes: "v1.0")
        
        XCTAssertEqual(sc.url, url)
        XCTAssertEqual(sc.notes, "v1.0")
        
        // Codable
        let data = try JSONEncoder().encode(sc)
        let decoded = try JSONDecoder().decode(SourceCode.self, from: data)
        
        XCTAssertEqual(decoded.url, url)
        XCTAssertEqual(decoded.notes, "v1.0")
    }
    
    // MARK: - Address
    
    func testAddress() throws {
        let addr = Address(
            address: "123 Retro Way",
            city: "Silicon Valley",
            region: "CA",
            postalCode: "94000",
            country: "USA",
            imageIDs: [UUID()]
        )
        
        XCTAssertEqual(addr.address, "123 Retro Way")
        XCTAssertEqual(addr.city, "Silicon Valley")
        XCTAssertEqual(addr.imageIDs.count, 1)
        
        // Codable
        let data = try JSONEncoder().encode(addr)
        let decoded = try JSONDecoder().decode(Address.self, from: data)
        XCTAssertEqual(decoded.postalCode, "94000")
        XCTAssertEqual(decoded.imageIDs, addr.imageIDs)
    }
    
    // MARK: - Contact
    
    func testContact() throws {
        let contact = Contact(
            name: "Jane Doe",
            title: "Developer",
            email: "jane@example.com",
            socialMedia: SocialMedia(xAccount: "jane")
        )
        
        XCTAssertEqual(contact.name, "Jane Doe")
        XCTAssertEqual(contact.title, "Developer")
        XCTAssertEqual(contact.socialMedia.xAccount, "jane")
        
        // Codable
        let data = try JSONEncoder().encode(contact)
        let decoded = try JSONDecoder().decode(Contact.self, from: data)
        XCTAssertEqual(decoded.email, "jane@example.com")
    }
    
    // MARK: - ReferenceManufacturer (New Fields)
    
    func testManufacturerWithAddresses() {
        // Mock doesn't fully implement addresses yet in a way that we can easily test default storage 
        // unless we updated MockReferenceManufacturer to conform to strict new protocol requirements?
        // Wait, MockReferenceManufacturer (Step 9515) has:
        // aliases, description, metadata, images.
        // It does NOT have addresses, email, contacts explicitly stored yet?
        // If InventoryManufacturer+Defaults.swift supplies them, they return defaults (empty).
        
        // Let's verify defaults work.
        let m = MockReferenceManufacturer(slug: "test", name: "Test Corp")
        XCTAssertTrue(m.addresses.isEmpty)
        XCTAssertTrue(m.associatedPeople.isEmpty)
        XCTAssertNil(m.email)
        XCTAssertTrue(m.images.isEmpty)
    }
}
