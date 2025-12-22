import XCTest
@testable import InventoryCore

final class InventoryLocationTests: XCTestCase {
    
    func testHierarchyModels() {
        let geo = InventoryGeoLocation(latitude: 37.7749, longitude: -122.4194)
        let building = InventoryBuilding(name: "Home", address: "123 Apple St", geoLocation: geo)
        
        XCTAssertEqual(building.name, "Home")
        XCTAssertEqual(building.geoLocation?.latitude, 37.7749)
        
        let room = InventoryRoom(name: "Lab", level: -1, building: building)
        XCTAssertEqual(room.building.name, "Home")
        XCTAssertEqual(room.level, -1)
        
        let volume = InventoryVolume(name: "NAS", uri: URL(fileURLWithPath: "/Volumes/NAS"))
        XCTAssertEqual(volume.name, "NAS")
    }
    
    func testPhysicalContainer() {
        let building = InventoryBuilding(name: "Warehouse")
        let room = InventoryRoom(name: "Storage A", building: building)
        let location = ItemLocation.physical(room: room, exactLocation: "Row 1", geoLocation: nil)
        
        let container = ItemContainerPhysical(name: "Box 1", location: location)
        
        XCTAssertEqual(container.name, "Box 1")
        XCTAssertEqual(container.type, .physical)
        
        if case .physical(let r, let exact, _) = container.location {
            XCTAssertEqual(r.name, "Storage A")
            XCTAssertEqual(exact, "Row 1")
        } else {
            XCTFail("Location should be physical")
        }
    }
    
    func testDigitalContainer() {
        let location = ItemLocation.digital(url: URL(string: "file:///Games/RPG")!, volume: "Main")
        let container = ItemContainerDigital(name: "RPG Folder", location: location)
        
        XCTAssertEqual(container.name, "RPG Folder")
        XCTAssertEqual(container.type, .digital)
        
        if case .digital(let url, let vol) = container.location {
            XCTAssertEqual(url.absoluteString, "file:///Games/RPG")
            XCTAssertEqual(vol, "Main")
        } else {
            XCTFail("Location should be digital")
        }
    }
    
    func testInventoryItemContainerExtension() {
        struct TestItem: InventoryItem {
            var name: String = "Test"
            var sizeOrWeight: Int64? = nil
            var typeIdentifier: String = "public.data"
            var accessionNumber: String? = nil
            var fileHashes: [String : String]? = nil
            var serialNumber: String? = nil
            var typeClassifier: InventoryItemClassifier = .other
            var mediaFormat: InventoryMediaFormat? = nil
            var identifiers: [any InventoryIdentifier] = []
        }
        
        let item = TestItem()
        XCTAssertNil(item.container)
    }
    
    // MARK: - Equality & Codable Tests
    
    func testGeoLocationEquality() {
        let geo1 = InventoryGeoLocation(latitude: 10.0, longitude: 20.0)
        let geo2 = InventoryGeoLocation(latitude: 10.0, longitude: 20.0)
        let geo3 = InventoryGeoLocation(latitude: 10.0, longitude: 21.0)
        
        XCTAssertEqual(geo1, geo2)
        XCTAssertNotEqual(geo1, geo3)
    }
    
    func testItemLocationEquality() {
        let building = InventoryBuilding(name: "B1")
        let room = InventoryRoom(name: "R1", building: building)
        
        let loc1 = ItemLocation.physical(room: room, exactLocation: "Self", geoLocation: nil)
        let loc2 = ItemLocation.physical(room: room, exactLocation: "Self", geoLocation: nil)
        let loc3 = ItemLocation.physical(room: room, exactLocation: "Other", geoLocation: nil)
        
        XCTAssertEqual(loc1, loc2)
        XCTAssertNotEqual(loc1, loc3)
    }
    
    func testCodable() throws {
        // Prepare Physical Container
        let building = InventoryBuilding(id: UUID(), name: "Warehouse", address: nil, geoLocation: nil)
        let room = InventoryRoom(id: UUID(), name: "Room A", level: 1, building: building, geoLocation: nil)
        let loc = ItemLocation.physical(room: room, exactLocation: "Shelf 1", geoLocation: nil)
        let container = ItemContainerPhysical(id: UUID(), name: "TestBox", location: loc)
        
        // Encode
        let encoder = JSONEncoder()
        let data = try encoder.encode(container)
        
        // Decode
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ItemContainerPhysical.self, from: data)
        
        XCTAssertEqual(decoded.id, container.id)
        XCTAssertEqual(decoded.name, "TestBox")
        
        if case .physical(let r, let exact, _) = decoded.location {
            XCTAssertEqual(r.id, room.id)
            XCTAssertEqual(exact, "Shelf 1")
        } else {
            XCTFail("Decoded location mismatch")
        }
    }
    
    func testDigitalCodable() throws {
        let location = ItemLocation.digital(url: URL(string: "file:///Games")!, volume: "Data")
        let container = ItemContainerDigital(id: UUID(), name: "DigitalBox", location: location)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(container)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ItemContainerDigital.self, from: data)
        
        XCTAssertEqual(decoded.id, container.id)
        XCTAssertEqual(decoded.name, "DigitalBox")
        XCTAssertEqual(decoded.type, .digital)
        
        if case .digital(let url, let vol) = decoded.location {
            XCTAssertEqual(url.absoluteString, "file:///Games")
            XCTAssertEqual(vol, "Data")
        } else {
            XCTFail("Location should be digital")
        }
    }
}
