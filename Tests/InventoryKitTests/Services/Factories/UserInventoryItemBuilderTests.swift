import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class UserInventoryItemBuilderTests: XCTestCase {
    
    // MARK: - Mocks
    
    struct MockStrategies {
        struct AlwaysValid: InventoryValidationStrategy {
            func validate(_ asset: any InventoryAsset) throws { }
        }
        
        struct AlwaysInvalid: InventoryValidationStrategy {
            func validate(_ asset: any InventoryAsset) throws {
                throw InventoryValidationError.businessRuleViolation(rule: "Always Invalid")
            }
        }
    }
    
    struct MockQuestionnaire: InventoryQuestionnaire {
        var id: UUID = UUID()
        var title: String = "Asset Q"
        var description: String?
        
        // Protocol Reqs
        var targetClassifier: ItemClassifierType = .software
        var localizedQuestions: [String: String] = [:]
        
        func generateAttributes() -> [String : String] {
            return ["q_attr": "q_val"]
        }
        
        func generateTags() -> [String] {
            return ["q_tag"]
        }
        
        func validate() -> [InventoryValidationError] { [] }
    }
    
    struct MockManufacturer: Manufacturer {
        var id: UUID = UUID()
        var name: String = "Asset Mfg"
        var slug: String = "asset-mfg"
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
    
    struct MockItem: InventoryItem {
        var id: UUID = UUID()
        var name: String = "Child Item"
        
        // Missing Requirements
        var custodyLocation: String?
        var acquisitionSource: String?
        var provenance: String?
        var acquisitionDate: Date?
        var condition: String?
        var tags: [String] = []
        var metadata: [String : String] = [:]
        var children: [any InventoryItem] = []
        
        var sizeOrWeight: Int64?
        var typeIdentifier: String = "item"
        var accessionNumber: String?
        var fileHashes: [String : String]?
        var serialNumber: String?
        var typeClassifier: ItemClassifierType = .physicalItem
        var mediaFormat: MediaFormatType?
        var identifiers: [any InventoryIdentifier] = []
        var productID: UUID?
    var sourceCode: (any InventorySourceCode)?
        var container: (any ItemContainer)? = nil
        var location: ItemLocationType? = nil

    }

    // MARK: - Tests
    
    func testBuild_FullCheck_Success() throws {
        let builder = UserInventoryItemBuilder(name: "My Asset")
        let uuid = UUID()
        let date = Date()
        let mfg = MockManufacturer()
        let child = MockItem()
        
        let asset = try builder
            .setID(uuid)
            .setType("Hardware")
            .setLocation("Shelf B")
            .setAcquisition(source: "eBay", date: date)
            .setCondition("Mint")
            .setProvenance("Original Owner")
            .setManufacturer(mfg)
            .addChild(child)
            .addTag("Retro")
            .addMetadata("Serial", "123")
            .build()
        
        XCTAssertEqual(asset.id, uuid)
        XCTAssertEqual(asset.name, "My Asset")
        XCTAssertEqual(asset.title, "My Asset") // Computed property check
        
        // Protocol Accessors
        // Protocol Accessors
        let idProtocol = asset as InventoryAssetIdentificationProtocol
        XCTAssertEqual(idProtocol.type, "Hardware")

        let locProtocol = asset as InventoryAssetLocationProtocol
        XCTAssertEqual(locProtocol.custodyLocation, "Shelf B")
        XCTAssertEqual(locProtocol.acquisitionSource, "eBay")
        XCTAssertEqual(locProtocol.provenance, "Original Owner")

        let lifeProtocol = asset as InventoryAssetLifecycleProtocol
        XCTAssertEqual(lifeProtocol.acquisitionDate, date)
        XCTAssertEqual(lifeProtocol.condition, "Mint")
        
        XCTAssertEqual(asset.manufacturer?.name, "Asset Mfg")
        XCTAssertEqual(asset.children.count, 1)
        XCTAssertEqual(asset.tags.contains("Retro"), true)
        XCTAssertEqual(asset.metadata["Serial"], "123")
    }
    
    func testBuild_EmptyName_Throws() {
        let builder = UserInventoryItemBuilder(name: "   ")
        
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .missingRequiredField(let field, _) = validationError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(field, "name")
        }
    }
    
    func testWithValidator_Success() throws {
        let builder = UserInventoryItemBuilder(name: "Valid Asset")
        
        let asset = try builder
            .withValidator(MockStrategies.AlwaysValid())
            .build()
        
        XCTAssertEqual(asset.name, "Valid Asset")
    }
    
    func testWithValidator_Failure() {
        let builder = UserInventoryItemBuilder(name: "Invalid Asset")
        
        _ = builder.withValidator(MockStrategies.AlwaysInvalid())
        
        XCTAssertThrowsError(try builder.build()) { error in
            guard let validationError = error as? InventoryValidationError,
                  case .businessRuleViolation(let rule) = validationError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(rule, "Always Invalid")
        }
    }
    
    func testApplyQuestionnaire() throws {
        let builder = UserInventoryItemBuilder(name: "Q Asset")
        let q = MockQuestionnaire()
        
        let asset = try builder
            .applyQuestionnaire(q)
            .build()
        
        XCTAssertTrue(asset.tags.contains("q_tag"))
        XCTAssertEqual(asset.metadata["q_attr"], "q_val")
    }
    
    func testComputedProperties() throws {
        let builder = UserInventoryItemBuilder(name: "Computed")
        var asset = try builder.build()
        
        XCTAssertEqual(asset.title, "Computed")
        asset.title = "New Title"
        XCTAssertEqual(asset.name, "New Title") // Ensure setter updates name
    }
}
