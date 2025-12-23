import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class InventoryImportServiceTests: XCTestCase {
    
    // Minimal Mock Transaction Service
    actor MockTxService: TransactionService {
        var ingestAssetCalled = false
        var ingestProductCalled = false
        
        func ingestAsset(_ data: AssetImportData) async throws -> UUID {
            ingestAssetCalled = true
            return UUID()
        }
        
        func ingestProduct(_ data: ProductImportData) async throws -> UUID {
            ingestProductCalled = true
            return UUID()
        }
        
        // Unused Stubs
        func begin() async throws -> any Transaction { fatalError() }
    }
    
    func testImportAsset() async throws {
        let mockTx = MockTxService()
        let service = InventoryImportService(transactionService: mockTx)
        
        let data = AssetImportData(name: "Test Asset", manufacturerName: "Test Corp", type: "Item")
        _ = try await service.importAsset(data)
        
        let called = await mockTx.ingestAssetCalled
        XCTAssertTrue(called)
    }
    
    func testImportProduct() async throws {
        let mockTx = MockTxService()
        let service = InventoryImportService(transactionService: mockTx)
        
        let data = ProductImportData(title: "Test Product", manufacturerName: "Test Corp")
        _ = try await service.importProduct(data)
        
        let called = await mockTx.ingestProductCalled
        XCTAssertTrue(called)
    }
}
