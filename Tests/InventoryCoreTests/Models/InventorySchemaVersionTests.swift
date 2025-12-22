import XCTest
import InventoryCore

final class InventorySchemaVersionTests: XCTestCase {
    func testSchemaComparison() throws {
        let v1 = InventorySchemaVersion(major: 1, minor: 0, patch: 0)
        let v2 = InventorySchemaVersion(major: 1, minor: 1, patch: 0)
        let v3 = InventorySchemaVersion(major: 2, minor: 0, patch: 0)
        let v1_patch = InventorySchemaVersion(major: 1, minor: 0, patch: 1)
        
        XCTAssertTrue(v1 < v2)
        XCTAssertTrue(v2 < v3)
        XCTAssertTrue(v1 < v1_patch)
        XCTAssertTrue(v1_patch < v2)
        XCTAssertFalse(v2 < v1)
        
        // Prerelease comparisons
        let alpha = InventorySchemaVersion(major: 1, minor: 0, patch: 0, prerelease: "alpha")
        let beta = InventorySchemaVersion(major: 1, minor: 0, patch: 0, prerelease: "beta")
        
        // 1.0.0-alpha < 1.0.0 is False? Or 1.0.0-alpha comes BEFORE 1.0.0?
        // SemVer: 1.0.0-alpha < 1.0.0.
        // Let's check implementation:
        // switch (lhs.prerelease, rhs.prerelease)
        // (.some, .none) -> true (wait, if lhs has pre and rhs none, lhs < rhs? Yes, pre-release < release)
        
        XCTAssertTrue(alpha < v1) 
        XCTAssertTrue(alpha < beta)
        
        XCTAssertEqual(v1.description, "1.0.0")
        XCTAssertEqual(v1_patch.description, "1.0.1")
        XCTAssertEqual(alpha.description, "1.0.0-alpha")
    }
    
    func testStringInit() throws {
        // Valid
        let v1 = try InventorySchemaVersion("1.0.0")
        XCTAssertEqual(v1.major, 1)
        XCTAssertEqual(v1.minor, 0)
        XCTAssertEqual(v1.patch, 0)
        
        let vComplex = try InventorySchemaVersion("2.3.4-alpha+build.123")
        XCTAssertEqual(vComplex.major, 2)
        XCTAssertEqual(vComplex.minor, 3)
        XCTAssertEqual(vComplex.patch, 4)
        XCTAssertEqual(vComplex.prerelease, "alpha")
        XCTAssertEqual(vComplex.buildMetadata, "build.123")
        
        // Invalid
        XCTAssertThrowsError(try InventorySchemaVersion("invalid")) { error in
             XCTAssertEqual(error as? InventorySchemaVersionError, .invalidFormat("invalid"))
        }
        XCTAssertThrowsError(try InventorySchemaVersion("1.2")) // Missing patch
    }
    
    func testCompatibility() {
        let v1 = InventorySchemaVersion(major: 1, minor: 0, patch: 0)
        let v1_1 = InventorySchemaVersion(major: 1, minor: 1, patch: 0)
        let v2 = InventorySchemaVersion(major: 2, minor: 0, patch: 0)
        
        XCTAssertTrue(v1.isCompatible(with: v1_1))
        XCTAssertFalse(v1.isCompatible(with: v2))
    }
    
    func testCodable() throws {
        let v = InventorySchemaVersion(major: 2, minor: 0, patch: 5)
        let data = try JSONEncoder().encode(v)
        let decoded = try JSONDecoder().decode(InventorySchemaVersion.self, from: data)
        XCTAssertEqual(v, decoded)
    }
}
