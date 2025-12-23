import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class InventoryStorageProviderDefaultsTests: XCTestCase {
    
    // Minimal concrete implementation using defaults
    struct MinimalStorage: InventoryStorageProvider {
        var identifier: String = "Minimal"
        var transformer: AnyInventoryDataTransformer = AnyInventoryDataTransformer(MockTransformer())
        
        func loadInventory(validatingAgainst version: SchemaVersion) async throws -> any InventoryDocument {
            fatalError("Stub")
        }
        func saveInventory(_ document: any InventoryDocument) async throws {}
    }
    
    struct LocalMockVendor: Vendor {
        var id: UUID = UUID()
        var name: String = "Mock"
        var address: (any Address)? = nil
        var inceptionDate: Date? = nil
        var websites: [URL] = []
        var contactEmail: String? = nil
        var contactPhone: String? = nil
        var metadata: [String : String] = [:]
    }
    
    struct MockTransformer: InventoryDataTransformer {
        var format: InventoryDataFormat = .json
        func decode(_ data: Data, validatingAgainst version: SchemaVersion) throws -> any InventoryDocument { fatalError() }
        func encode(_ document: any InventoryDocument) throws -> Data { Data() }
    }
    
    struct MockDoc: InventoryDocument {
        var schemaVersion: SchemaVersion { .current }
        var info: (any InventoryTypes.InventoryDocumentInfo)? { nil }
        var metadata: [String : String] { [:] }
        var assets: [any InventoryAsset] { [] }
        var relationshipTypes: [any InventoryRelationshipType] { [] }
        var people: [any Contact] { [] }
        // var resources: [any InventoryResource] { [] } // Removed/Renamed
        var products: [any Product] { [] }
        var manufacturers: [any Manufacturer] { [] }
        var collections: [any Collection] { [] }
        var locationSpaces: [any Space] { [] }
        var vendors: [any Vendor] { [] }
    }
    
    func testDefaultVendorOperations() async {
        let storage = MinimalStorage()
        
        // 1. Check default 'vendor' property is nil
        XCTAssertNil(storage.vendor)
        
        // 2. Check vendor operations throw 'vendorOperationNotSupported'
        let v = LocalMockVendor()
        
        do {
            try await storage.createVendor(v)
            XCTFail("Should throw error")
        } catch let e as InventoryCore.InventoryError {
            if case .vendorOperationNotSupported = e {
                // Success
            } else {
                XCTFail("Wrong error type: \(e)")
            }
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
        
        do {
            try await storage.saveVendor(v)
            XCTFail("Should throw error")
        } catch let e as InventoryCore.InventoryError {
            if case .vendorOperationNotSupported = e {} else { XCTFail() }
        } catch { XCTFail() }
        
        do {
            try await storage.deleteVendor(id: UUID())
            XCTFail("Should throw error")
        } catch let e as InventoryCore.InventoryError {
            if case .vendorOperationNotSupported = e {} else { XCTFail() }
        } catch { XCTFail() }
        
        // 3. Readers return empty/nil by default
        let loaded = try? await storage.loadVendor(id: UUID())
        XCTAssertNil(loaded)
        
        let all = try? await storage.fetchVendors()
        XCTAssertEqual(all?.count, 0)
    }
    
    func testDefaultReplaceInventory() async throws {
        let storage = MinimalStorage()
        let doc = MockDoc()
        
        // Should succeed by calling saveInventory (which is empty in MinimalStorage)
        try await storage.replaceInventory(with: doc)
    }
}
