import XCTest
import InventoryCore
@testable import InventoryKit // Component under test

final class UserAssetCompositionServiceTests: XCTestCase {
    
    func testComposeAsset() async throws {
        // Given
        let storage = MockStorageProvider()
        let context = MockContext(storage: storage)
        let service = UserAssetCompositionService(context: context)
        
        // Use a temp file for source
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_import.dsk")
        try "dummy data".write(to: tempURL, atomically: true, encoding: .utf8)
        
        let request = UserAssetCompositionService.CompositionRequest(
            name: "Lode Runner",
            sourceURL: tempURL,
            provenance: "My Floppy Box",
            tags: ["Game", "Apple II"]
        )
        
        // When
        let assetID = try await service.compose(request: request)
        
        // Then
        
        // 1. Verify Asset Metadata Saved
        let metadataStore = storage.userMetadata as! MockUserMetadataStore
        let savedAsset = try await metadataStore.retrieveAsset(id: assetID)
        XCTAssertNotNil(savedAsset)
        XCTAssertEqual(savedAsset?.name, "Lode Runner")
        XCTAssertEqual(savedAsset?.provenance, "My Floppy Box")
        XCTAssertEqual(savedAsset?.tags, ["Game", "Apple II"])
        
        // 2. Verify Data Saved
        let dataStore = storage.userData as! MockUserDataStore
        let exists = await dataStore.fileExists(for: assetID)
        XCTAssertTrue(exists)
        
        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
}
