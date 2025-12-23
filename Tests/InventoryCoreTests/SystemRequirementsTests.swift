import XCTest
import InventoryCore
import InventoryTypes

final class SystemRequirementsTests: XCTestCase {
    
    func testInitialization() {
        let reqs = MockSystemRequirements(
            minMemory: 640_000,
            recommendedMemory: 1_024_000,
            cpuFamily: "x86",
            minCpuSpeedMHz: 4.77,
            video: "CGA",
            audio: "PC Speaker",
            osName: "MS-DOS",
            minOsVersion: "2.0"
        )
        
        XCTAssertEqual(reqs.minMemory, 640_000)
        XCTAssertEqual(reqs.osName, "MS-DOS")
    }
    
    func testCodable() throws {
        let reqs = MockSystemRequirements(
            minMemory: 256,
            cpuFamily: "6502",
            osName: "Apple DOS"
        )
        
        let data = try JSONEncoder().encode(reqs)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(MockSystemRequirements.self, from: data)
        
        XCTAssertEqual(reqs.minMemory, decoded.minMemory)
        XCTAssertEqual(reqs.cpuFamily, decoded.cpuFamily)
        XCTAssertEqual(reqs.osName, decoded.osName)
        XCTAssertNil(decoded.minCpuSpeedMHz)
    }
}
