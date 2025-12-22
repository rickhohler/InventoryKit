import XCTest
import InventoryCore

private struct MinimalLibraryProvider: InventoryLibraryStorageProvider {
    var identifier: String = "TestLib"
    
    // Implement required methods with no-ops or throws
    func createProduct(_ product: any InventoryProduct) async throws {}
    func getProduct(id: UUID) async throws -> (any InventoryProduct)? { return nil }
    func searchProducts(query: String) async throws -> [any InventoryProduct] { return [] }
    func updateProduct(_ product: any InventoryProduct) async throws {}
    func deleteProduct(id: UUID) async throws {}
}

private struct LocalMockProduct: InventoryProduct {
    var id: UUID = UUID()
    var name: String = "Test"
    var aliases: [String] = []
    var description: String? = nil
    var manufacturer: (any InventoryManufacturer)? = nil
    var releaseDate: Date? = nil
    var metadata: [String : String] = [:]
    
    // Protocol requirements to satisfy InventoryProduct
    var sku: String? = nil
    var title: String { name }
    var productType: String? = nil
    var classification: String? = nil
    var genre: String? = nil
    var publisher: String? = nil
    var developer: String? = nil
    var creator: String? = nil
    var productionDate: Date? = nil
    var platform: String? = nil
    var systemRequirements: String? = nil
    var version: String? = nil
    var identifiers: [any InventoryIdentifier] = []
    
    var instanceIDs: [UUID] = []
    var artworkIDs: [UUID] = []
    var screenshotIDs: [UUID] = []
    var instructionIDs: [UUID] = []
    var collectionIDs: [UUID] = []
    var references: [String: String] = [:]
    var referenceProductID: (any InventoryIdentifier)? = nil
    var sourceCode: SourceCode? = nil
}

final class InventoryLibraryStorageProviderTests: XCTestCase {
    
    func testDefaults() async throws {
        let provider = MinimalLibraryProvider()
        let product = LocalMockProduct()

        
        // Test createProducts (batch) default -> calls createProduct loop
        try await provider.createProducts([product])
        
        // Test updateProducts (batch) default -> calls updateProduct loop
        try await provider.updateProducts([product])
        
        // Test fetchDelta default -> Throws
        do {
            _ = try await provider.fetchDelta(bundleId: "b", bundleVersion: 1, fromDate: Date(), toDate: nil)
            XCTFail("Should throw")
        } catch {
            // Success
        }
    }
}
