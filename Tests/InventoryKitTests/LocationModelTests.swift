import XCTest
@testable import InventoryKit
@testable import InventoryTypes

final class LocationModelTests: XCTestCase {
    
    // MARK: - InventoryBuilding
    func testInventoryBuilding_Initialization() {
        let id = UUID()
        let building = InventoryBuilding(id: id, name: "Headquarters", address: "123 Retro Way")
        
        XCTAssertEqual(building.id, id)
        XCTAssertEqual(building.name, "Headquarters")
        XCTAssertEqual(building.address, "123 Retro Way")
        XCTAssertNil(building.geoLocation)
    }
    
    func testInventoryBuilding_Codable() throws {
        let building = InventoryBuilding(name: "Warehouse")
        let data = try JSONEncoder().encode(building)
        let decoded = try JSONDecoder().decode(InventoryBuilding.self, from: data)
        
        XCTAssertEqual(decoded.name, "Warehouse")
        XCTAssertEqual(decoded.id, building.id)
    }
    
    // MARK: - InventoryRoom
    func testInventoryRoom_Initialization() {
        let building = InventoryBuilding(name: "Home")
        let id = UUID()
        let room = InventoryRoom(id: id, name: "Lab", level: 1, building: building)
        
        XCTAssertEqual(room.id, id)
        XCTAssertEqual(room.name, "Lab")
        XCTAssertEqual(room.level, 1)
        XCTAssertEqual((room.building as? InventoryBuilding)?.name, "Home")
    }
    
    func testInventoryRoom_Setter() {
        var buildingA = InventoryBuilding(name: "A")
        let buildingB = InventoryBuilding(name: "B")
        var room = InventoryRoom(name: "Test", building: buildingA)
        
        XCTAssertEqual((room.building as? InventoryBuilding)?.name, "A")
        
        room.building = buildingB
        XCTAssertEqual((room.building as? InventoryBuilding)?.name, "B")
    }
    
    func testInventoryRoom_Codable() throws {
        let building = InventoryBuilding(name: "Office")
        let room = InventoryRoom(name: "Meeting Room", building: building)
        
        let data = try JSONEncoder().encode(room)
        let decoded = try JSONDecoder().decode(InventoryRoom.self, from: data)
        
        XCTAssertEqual(decoded.name, "Meeting Room")
        XCTAssertEqual((decoded.building as? InventoryBuilding)?.name, "Office")
    }
    
    // MARK: - InventoryDigitalVolume
    func testInventoryDigitalVolume_Initialization() {
        let id = UUID()
        let url = URL(string: "file:///Volumes/MacHD")!
        let vol = InventoryDigitalVolume(id: id, name: "MacHD", uri: url)
        
        XCTAssertEqual(vol.id, id)
        XCTAssertEqual(vol.name, "MacHD")
        XCTAssertEqual(vol.uri, url)
        XCTAssertNil(vol.geoLocation)
    }
    
    func testInventoryDigitalVolume_Codable() throws {
        let url = URL(string: "file:///Volumes/Backup")!
        let vol = InventoryDigitalVolume(name: "Backup", uri: url)
        
        let data = try JSONEncoder().encode(vol)
        let decoded = try JSONDecoder().decode(InventoryDigitalVolume.self, from: data)
        
        XCTAssertEqual(decoded.name, "Backup")
        XCTAssertEqual(decoded.uri, url)
    }
    
    // MARK: - Containers
    func testItemContainerPhysical_Initialization() {
        let id = UUID()
        let roomID = UUID()
        let location = ItemLocationType.physical(roomID: roomID, exactLocation: nil, geoLocation: nil)
        let container = ItemContainerPhysical(id: id, name: "Box 1", location: location)
        
        XCTAssertEqual(container.id, id)
        XCTAssertEqual(container.name, "Box 1")
    }
    
    func testItemContainerDigital_Initialization() {
        let id = UUID()
        let volID = UUID()
        let url = URL(string: "file:///tmp")!
        let location = ItemLocationType.digital(url: url, volumeID: volID)
        let container = ItemContainerDigital(id: id, name: "Misc Folder", location: location)
        
        XCTAssertEqual(container.id, id)
        XCTAssertEqual(container.name, "Misc Folder")
    }
    
    // MARK: - IdentifierModel
    func testIdentifierModel() throws {
        let model = IdentifierModel(type: .barcode, value: "1234567890")
        XCTAssertEqual(model.type, .barcode)
        XCTAssertEqual(model.value, "1234567890")
        
        let data = try JSONEncoder().encode(model)
        let decoded = try JSONDecoder().decode(IdentifierModel.self, from: data)
        XCTAssertEqual(decoded.value, "1234567890")
    }
}
