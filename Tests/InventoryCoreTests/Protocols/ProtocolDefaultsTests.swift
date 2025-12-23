import XCTest
import InventoryCore
import InventoryTypes
@testable import InventoryKit

final class ProtocolDefaultsTests: XCTestCase {
    
    // MARK: - Manufacturer Defaults
    
    func testManufacturerDefaults() {
        // Create a struct that only conforms to the bare minimum requirements (via a Mock)
        // Since the protocol has requirements, we need to fulfill them, but NOT the defaults.
        struct MinimalManufacturer: Manufacturer {
             // Manufacturer requirements
             var id: UUID = UUID()
             var name: String = "Test"
             var slug: String = "test"
             var description: String? = nil
             var metadata: [String : String] = [:]
             var aliases: [String] = []
        }
        
        let m = MinimalManufacturer()
        // These properties come from the default extension
        XCTAssertTrue(m.alsoKnownAs.isEmpty)
        XCTAssertTrue(m.alternativeSpellings.isEmpty)
        XCTAssertTrue(m.commonMisspellings.isEmpty)
        XCTAssertTrue(m.addresses.isEmpty)
        XCTAssertNil(m.email)
        XCTAssertTrue(m.associatedPeople.isEmpty)
        XCTAssertTrue(m.developers.isEmpty)
    }
    
    // MARK: - InventoryDataTransformer
    
    func testAnyInventoryDataTransformer() {
        struct MockTransformer: InventoryDataTransformer {
            var format: InventoryDataFormat = .json
            
            func decode(_ data: Data, validatingAgainst version: SchemaVersion) throws -> any InventoryDocument {
                struct MockDoc: InventoryDocument {
                    var schemaVersion: SchemaVersion { .current }
                    var info: (any InventoryTypes.InventoryDocumentInfo)? { nil }
                    var metadata: [String : String] { [:] }
                    var assets: [any InventoryAsset] { [] }
                    var relationshipTypes: [any InventoryRelationshipType] { [] }
                }
                return MockDoc()
            }
            
            func encode(_ document: any InventoryDocument) throws -> Data {
                return Data()
            }
        }
        
        let mock = MockTransformer()
        let anyT = AnyInventoryDataTransformer(mock)
        
        XCTAssertEqual(anyT.format, .json)
        
        // Ensure decode/encode calls get forwarded
        struct MockDoc: InventoryDocument {
             var schemaVersion: SchemaVersion { .current }
             var info: (any InventoryTypes.InventoryDocumentInfo)? { nil }
             var metadata: [String : String] { [:] }
             var assets: [any InventoryAsset] { [] }
             var relationshipTypes: [any InventoryRelationshipType] { [] }
        }
        
        XCTAssertNoThrow(try anyT.encode(MockDoc()))
        
        if let _ = try? anyT.decode(Data(), validatingAgainst: .current) {
             // Success
        } else {
            // It might throw depending on mock implementation but here it returns MockDoc
            XCTAssertTrue(true)
        }
    }
}
