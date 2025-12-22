import XCTest
import InventoryCore

final class InventorySystemRequirementsTests: XCTestCase {
    
    func testInitialization() {
        let reqs = InventorySystemRequirements(
            minMemory: 640_000,
            recommendedMemory: 1_024_000,
            cpuFamily: "x86",
            minCpuSpeedMHz: 33.0,
            video: "VGA",
            audio: "Sound Blaster",
            osName: "MS-DOS",
            minOsVersion: "5.0"
        )
        
        XCTAssertEqual(reqs.minMemory, 640_000)
        XCTAssertEqual(reqs.recommendedMemory, 1_024_000)
        XCTAssertEqual(reqs.cpuFamily, "x86")
        XCTAssertEqual(reqs.minCpuSpeedMHz, 33.0)
        XCTAssertEqual(reqs.video, "VGA")
        XCTAssertEqual(reqs.audio, "Sound Blaster")
        XCTAssertEqual(reqs.osName, "MS-DOS")
        XCTAssertEqual(reqs.minOsVersion, "5.0")
    }
    
    func testCodable() throws {
        let reqs = InventorySystemRequirements(
            minMemory: 256,
            cpuFamily: "6502",
            osName: "Apple DOS"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(reqs)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(InventorySystemRequirements.self, from: data)
        
        XCTAssertEqual(reqs.minMemory, decoded.minMemory)
        XCTAssertEqual(reqs.cpuFamily, decoded.cpuFamily)
        XCTAssertEqual(reqs.osName, decoded.osName)
        XCTAssertNil(decoded.minCpuSpeedMHz)
    }
}
