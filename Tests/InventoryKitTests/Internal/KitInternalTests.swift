import XCTest
@testable import InventoryKit
import InventoryTypes

final class KitInternalTests: XCTestCase {
    
    func testInventoryDocumentInfo() {
        // Internal struct test
        let now = Date()
        let info = InventoryDocumentInfo(generatedAt: now, source: "Test", summary: "Summary")
        
        XCTAssertEqual(info.source, "Test")
        XCTAssertEqual(info.summary, "Summary")
        XCTAssertEqual(info.generatedAt, now)
    }
    
    func testInventoryDocumentInfoCodable() throws {
        let info = InventoryDocumentInfo(source: "S", summary: "M")
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(InventoryDocumentInfo.self, from: data)
        XCTAssertEqual(info, decoded)
    }
    
    func testInventoryPage() {
        let items = ["A", "B", "C"]
        let page = InventoryPage(items: items, nextOffset: 10, total: 100)
        
        XCTAssertEqual(page.items, items)
        XCTAssertEqual(page.nextOffset, 10)
        XCTAssertEqual(page.total, 100)
        
        let request = InventoryPageRequest(offset: 5, limit: 20)
        XCTAssertEqual(request.offset, 5)
        XCTAssertEqual(request.limit, 20)
        
        // Test clamping
        let invalidRequest = InventoryPageRequest(offset: -1, limit: 0)
        XCTAssertEqual(invalidRequest.offset, 0)
        XCTAssertEqual(invalidRequest.limit, 1)
    }
}
