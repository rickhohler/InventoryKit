import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class ReferenceProductBuilderTests: XCTestCase {
    
    // MARK: - Mocks
    
    struct MockManufacturer: Manufacturer {
        var id: UUID = UUID()
        var name: String = "Test Mfg"
        var slug: String = "test-mfg"
        var aliases: [String] = []
        var alsoKnownAs: [String] = []
        var alternativeSpellings: [String] = []
        var commonMisspellings: [String] = []
        var addresses: [any Address] = []
        var email: String?
        var associatedPeople: [any Contact] = []
        var developers: [any Contact] = []
        var description: String?
        var metadata: [String : String] = [:]
    }
    
    struct MockQuestionnaire: InventoryQuestionnaire {
        var id: UUID = UUID()
        var title: String = "Test Q"
        var description: String?
        
        // Protocol Reqs
        var targetClassifier: ItemClassifierType = .software
        var localizedQuestions: [String: String] = [:]
        
        func generateAttributes() -> [String : String] {
            return ["q_key": "q_value"]
        }
        
        func generateTags() -> [String] { [] }
        
        func validate() -> [InventoryValidationError] { [] }
    }
    
    // MARK: - Tests
    
    func testBuild_Success() throws {
        let builder = ReferenceProductBuilder(title: "Karateka")
        
        let product = try builder
            .setPlatform("Apple II")
            .setPublisher("Broderbund")
            .setManufacturer(MockManufacturer())
            .addMetadata("Genre", "Action")
            .build()
        
        XCTAssertEqual(product.title, "Karateka")
        XCTAssertEqual(product.platform, "Apple II")
        XCTAssertEqual(product.publisher, "Broderbund")
        XCTAssertEqual(product.manufacturer?.name, "Test Mfg")
        XCTAssertEqual(product.metadata["Genre"], "Action")
    }
    
    func testBuild_EmptyTitle_Throws() {
        let builder = ReferenceProductBuilder(title: "   ")
        
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .missingRequiredField(let field, _) = validationError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(field, "title")
        }
    }
    
    func testSetSourceCode() throws {
        let builder = ReferenceProductBuilder(title: "Source App")
        let url = URL(string: "https://github.com/source")!
        
        let product = try builder
            .setSourceCode(url: url, notes: "Open Source")
            .build()
        
        XCTAssertNotNil(product.sourceCode)
        XCTAssertEqual(product.sourceCode?.url, url)
        XCTAssertEqual(product.sourceCode?.notes, "Open Source")
    }
    
    func testApplyQuestionnaire() throws {
        let builder = ReferenceProductBuilder(title: "Questions")
        let q = MockQuestionnaire()
        
        let product = try builder
            .applyQuestionnaire(q)
            .build()
        
        XCTAssertEqual(product.metadata["q_key"], "q_value")
    }
    
    func testAddIdentifier() throws {
        let builder = ReferenceProductBuilder(title: "ID App")
        
        let product = try builder
            .addIdentifier(type: .serialNumber, value: "12345")
            .build()
        
        XCTAssertEqual(product.identifiers.count, 1)
        XCTAssertEqual(product.identifiers.first?.value, "12345")
        XCTAssertEqual(product.identifiers.first?.type, .serialNumber)
    }
    
    func testSetID() throws {
        let builder = ReferenceProductBuilder(title: "ID Check")
        let uuid = UUID()
        
        let product = try builder
            .setID(uuid)
            .build()
        
        XCTAssertEqual(product.id, uuid)
    }
    
    func testSetReleaseDate() throws {
        let builder = ReferenceProductBuilder(title: "Date Check")
        let date = Date()
        
        let product = try builder
            .setReleaseDate(date)
            .build()
        
        XCTAssertEqual(product.releaseDate, date)
    }
}
