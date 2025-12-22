import XCTest
import InventoryCore

final class DomainSyncServiceTests: XCTestCase {
    func testDomainUpdateInfo() {
        let info = DomainUpdateInfo(collectionID: UUID(), version: "1.0", sizeBytes: 100, isDelta: true)
        XCTAssertEqual(info.version, "1.0")
        XCTAssertEqual(info.sizeBytes, 100)
    }
}
