import XCTest
@testable import InventoryCore

final class InventoryRealWorldLocationTests: XCTestCase {
    
    /// Scenario: Setting up a complete home inventory with multiple rooms and containers.
    func testCompleteHomeInventorySetup() {
        // 1. Define the Property
        let homeGeo = InventoryGeoLocation(latitude: 34.0522, longitude: -118.2437)
        let mainHouse = InventoryBuilding(
            id: UUID(),
            name: "The Retro Ranch",
            address: "1984 Atari Lane",
            geoLocation: homeGeo
        )
        
        // 2. Define Rooms
        let livingRoom = InventoryRoom(
            name: "Living Room",
            level: 1, // Ground floor
            building: mainHouse
        )
        
        let basementLab = InventoryRoom(
            name: "Retro Lab",
            level: -1, // Basement
            building: mainHouse
        )
        
        // 3. Define Containers
        // Box A: In the Lab, contains Software
        let boxA = ItemContainerPhysical(
            id: UUID(),
            name: "Apple II Software - Box A",
            location: .physical(room: basementLab, exactLocation: "North Shelf, Top", geoLocation: nil),
            identifiers: [] // In real app, would have NFC/Barcode wrappers here
        )
        
        // Box B: In the Garage (Wait, we didn't make a garage, let's put it in Living Room)
        let boxB = ItemContainerPhysical(
            id: UUID(),
            name: "Joystick Collection",
            location: .physical(room: livingRoom, exactLocation: "TV Stand", geoLocation: nil)
        )
        
        // 4. Verification
        
        // Check Box A Location
        if case .physical(let room, let exact, _) = boxA.location {
            XCTAssertEqual(room.name, "Retro Lab")
            XCTAssertEqual(room.building.name, "The Retro Ranch")
            XCTAssertEqual(room.level, -1)
            XCTAssertEqual(exact, "North Shelf, Top")
            
            // Verify structural integrity (back-reference to building works)
            XCTAssertEqual(room.building.address, "1984 Atari Lane")
        } else {
            XCTFail("Box A should be physical")
        }
        
        // Check Box B Location
        if case .physical(let room, _, _) = boxB.location {
            XCTAssertEqual(room.name, "Living Room")
            XCTAssertEqual(room.building.id, mainHouse.id)
        }
    }
    
    /// Scenario: Tracking a Digital Archive on a NAS
    func testDigitalLibrarySetup() {
        // 1. Define Volume
        let nasVolume = InventoryVolume(
            name: "Synology NAS",
            uri: URL(string: "smb://192.168.1.100/RetroData")!
        )
        
        // 2. Define Folders (Containers)
        let apple2Games = ItemContainerDigital(
            name: "Apple II Games (WOZ)",
            location: .digital(
                url: nasVolume.uri.appendingPathComponent("AppleII/Games/WOZ"),
                volume: nasVolume.name
            )
        )
        
        let romsFolder = ItemContainerDigital(
            name: "MAME ROMs",
            location: .digital(
                url: nasVolume.uri.appendingPathComponent("Arcade/MAME"),
                volume: nasVolume.name
            )
        )
        
        // 3. Verification
        
        // functional check of URL construction
        if case .digital(let url, let volName) = apple2Games.location {
            XCTAssertEqual(url.absoluteString, "smb://192.168.1.100/RetroData/AppleII/Games/WOZ")
            XCTAssertEqual(volName, "Synology NAS")
        }
        
        if case .digital(let url, _) = romsFolder.location {
            XCTAssertEqual(url.lastPathComponent, "MAME")
        }
    }
    
    /// Scenario: Geolocation Inference simulation
    /// (Testing that we *can* store specific coords on an item even if the room has general coords)
    func testGrainularGeolocation() {
        let buildingGeo = InventoryGeoLocation(latitude: 40.0, longitude: -70.0)
        let warehouse = InventoryBuilding(name: "Warehouse 13", geoLocation: buildingGeo)
        let vault = InventoryRoom(name: "Artifact Vault", building: warehouse)
        
        // The Ark has a specific tracker with different coords than the building center
        let specificItemGeo = InventoryGeoLocation(latitude: 40.0001, longitude: -70.0001)
        
        let arkCrate = ItemContainerPhysical(
            name: "Ark Crate",
            location: .physical(
                room: vault,
                exactLocation: "Center Plinth",
                geoLocation: specificItemGeo
            )
        )
        
        if case .physical(let room, _, let itemGeo) = arkCrate.location {
            XCTAssertEqual(room.building.geoLocation?.latitude, 40.0)
            XCTAssertEqual(itemGeo?.latitude, 40.0001)
            XCTAssertNotEqual(room.building.geoLocation, itemGeo)
        }
    }
}
