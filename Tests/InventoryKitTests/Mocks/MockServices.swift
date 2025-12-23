import Foundation
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class MockInventoryImportService: InventoryImportServiceProtocol, @unchecked Sendable {
    var importedAssets: [AssetImportData] = []
    var importedProducts: [ProductImportData] = []
    
    var nextAssetID: UUID = UUID()
    var nextProductID: UUID = UUID()
    
    func importAsset(_ data: AssetImportData) async throws -> UUID {
        importedAssets.append(data)
        return nextAssetID
    }
    
    func importProduct(_ data: ProductImportData) async throws -> UUID {
        importedProducts.append(data)
        return nextProductID
    }
}
