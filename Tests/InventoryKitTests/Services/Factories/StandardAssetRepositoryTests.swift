import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class StandardAssetRepositoryTests: XCTestCase {
    
    func testCreateAsset_Success() throws {
        let factory = StandardAssetRepository()
        let id = UUID()
        let name = "Factory Asset"
        let provenance = "Unit Test"
        let tags = ["Tag1"]
        
        // Act
        let asset = try factory.createAsset(id: id, name: name, provenance: provenance, tags: tags, metadata: [:])
        
        // Assert
        XCTAssertEqual(asset.id, id)
        XCTAssertEqual(asset.name, name)
        XCTAssertEqual(asset.provenance, provenance)
        XCTAssertTrue(asset.tags.contains("Tag1"))
        XCTAssertTrue(asset.tags.contains("Created via Repository"))
    }
    
    func testCreateAsset_WithValidator_Failure() {
        // Setup a validator that always fails or has strict rules
        struct FailValidator: InventoryValidationStrategy {
            func validate(_ asset: any InventoryAsset) throws {
                throw InventoryValidationError.businessRuleViolation(rule: "Fail Always")
            }
        }
        
        let factory = StandardAssetRepository(validator: FailValidator())
        let id = UUID()
        
        // Act & Assert
        XCTAssertThrowsError(try factory.createAsset(id: id, name: "Test", provenance: "Test", tags: [], metadata: [:])) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .businessRuleViolation(let rule) = validationError else {
                XCTFail("Wrong error type")
                return
            }
            XCTAssertEqual(rule, "Fail Always")
            XCTAssertEqual(rule, "Fail Always")
        }
    }
    
    func testDefaultCreate() async throws {
        let factory = StandardAssetRepository()
        let asset = try await factory.create()
        XCTAssertEqual(asset.name, "New Asset")
        XCTAssertNotNil(asset.id)
    }
    
    func testPersistenceMethodStubs() async throws {
        let factory = StandardAssetRepository()
        let asset = try await factory.create()
        
        // Ensure these don't throw or crash
        try await factory.save(asset)
        try await factory.update(asset)
        try await factory.delete(id: asset.id)
        
        let fetched = try await factory.fetch(matching: StorageQuery(filter: .all))
        XCTAssertTrue(fetched.isEmpty)
        
        let retrieved = try await factory.retrieve(id: asset.id)
        XCTAssertNil(retrieved)
    }
}
