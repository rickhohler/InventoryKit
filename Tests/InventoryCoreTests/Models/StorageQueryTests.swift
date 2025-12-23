import XCTest
import InventoryCore
import InventoryTypes

final class StorageQueryTests: XCTestCase {
    
    func testQueryStructure() {
        let filter = StorageFilter.id(UUID())
        let sort = StorageSortDescriptor(key: "title", ascending: true)
        let query = StorageQuery(filter: filter, sort: [sort], limit: 10)
        
        XCTAssertNotNil(query.filter)
        XCTAssertEqual(query.sort.count, 1)
        XCTAssertEqual(query.sort.first?.key, "title")
        XCTAssertEqual(query.sort.first?.ascending, true)
        XCTAssertEqual(query.limit, 10)
    }
    
    func testFilters() {
        let f1 = StorageFilter.all
        let f2 = StorageFilter.field(key: "name", op: .equals, value: "test")
        let f3 = StorageFilter.and([f1, f2])
        _ = StorageFilter.or([f1, f2])
        _ = StorageFilter.field(key: "age", op: .greaterThan, value: "10")
        
        // Just verifying initialization and enum cases
        if case .all = f1 { XCTAssertTrue(true) } else { XCTFail() }
        if case .and = f3 { XCTAssertTrue(true) } else { XCTFail() }
    }
    
    func testConvenienceMethods() {
        let mfg = StorageQuery.manufacturer(name: "Apple")
        XCTAssertEqual(mfg.limit, 1)
        if case .field(let k, let o, let v) = mfg.filter {
            XCTAssertEqual(k, "name")
            XCTAssertEqual(o, .equals)
            XCTAssertEqual(v, "Apple")
        } else { XCTFail() }
        
        let slug = StorageQuery.manufacturer(slug: "apple")
        XCTAssertEqual(slug.limit, 1)
        
        let product = StorageQuery.product(title: "Doom")
        if case .field(let k, _, _) = product.filter {
            XCTAssertEqual(k, "title")
        } else { XCTFail() }
        
        let asset = StorageQuery.asset(name: "My Mac")
        if case .field(let k, _, _) = asset.filter {
            XCTAssertEqual(k, "name")
        } else { XCTFail() }
    }
}
