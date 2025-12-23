import XCTest
@testable import InventoryCore
import InventoryTypes

final class ReferenceSyncServiceTests: XCTestCase {
    func testReferenceUpdateInfo() {
        let info = ReferenceUpdateInfo(collectionID: UUID(), version: "1.0", sizeBytes: 100, isDelta: true)
        XCTAssertEqual(info.version, "1.0")
        XCTAssertEqual(info.sizeBytes, 100)
    }
    
    func testReferenceSyncStatus() {
        XCTAssertEqual(ReferenceSyncStatus.synced.rawValue, "synced")
        XCTAssertEqual(ReferenceSyncStatus.syncing.rawValue, "syncing")
    }
}
