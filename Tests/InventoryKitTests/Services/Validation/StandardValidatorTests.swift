import XCTest
import InventoryCore
@testable import InventoryKit
import InventoryTypes

final class StandardValidatorTests: XCTestCase {
    
    // MARK: - Mocks
    
    struct MockAsset: InventoryAsset {
        var id: UUID = UUID()
        var title: String = "" // Computed from Name usually, but protocol allows var? Re-check.
        // Wait, protocol has `var title: String { get set }`?
        // Let's use name since that's what we usually validat.
        var name: String = "Test Asset"
        var type: String?
        var manufacturer: (any Manufacturer)?
        
        // Protocol stubs
        var typeIdentifier: String = "item"
        var accessionNumber: String?
        var fileHashes: [String : String]?
        var serialNumber: String?
        var typeClassifier: ItemClassifierType = .physicalItem 
        var mediaFormat: MediaFormatType?
        var identifiers: [any InventoryIdentifier] = []
        var productID: UUID?
        var sourceCode: (any InventorySourceCode)?
        var custodyLocation: String?
        var acquisitionSource: String?
        var provenance: String?
        var acquisitionDate: Date?
        var condition: String?
        var tags: [String] = []

        var metadata: [String : String] = [:]
        var children: [any InventoryItem] = []
        
        // Compound Base
        var description: String?
        var releaseDate: Date?
        var dataSource: (any DataSource)?
        var images: [any InventoryItem] = []
        
        // Missing Conformance
        var source: (any InventorySource)?
        var lifecycle: (any InventoryLifecycle)?
        var health: (any InventoryHealth)?
        var mro: (any InventoryMROInfo)?
        var copyright: (any CopyrightInfo)?
        var components: [any InventoryComponentLink] = []
        var relationshipRequirements: [any InventoryRelationshipRequirement] = []
        var linkedAssets: [any InventoryLinkedAsset] = []
        var relationshipType: AssetRelationshipType?
        var forensicClassification: String?
        
        // InventoryItem Conformance
        var location: ItemLocationType? = nil
        var container: (any ItemContainer)? = nil
        var sizeOrWeight: Int64?
    }
    
    struct MockMfg: Manufacturer {
        var id: UUID = UUID()
        var name: String = "Mfg"
        var slug: String = "mfg"
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

    // MARK: - Software Validator
    
    func testSoftwareValidator_Success() throws {
        var asset = MockAsset()
        asset.type = "software"
        try SoftwareValidator().validate(asset)
        
        asset.type = "GAME" // Case insensitive
        try SoftwareValidator().validate(asset)
    }
    
    func testSoftwareValidator_Failure() {
        var asset = MockAsset()
        asset.type = "toaster"
        
        XCTAssertThrowsError(try SoftwareValidator().validate(asset)) { error in
            guard case .businessRuleViolation = (error as? InventoryValidationError) else {
                XCTFail("Expected businessRuleViolation")
                return
            }
        }
    }
    
    // MARK: - Hardware Validator
    
    func testHardwareValidator_Success() throws {
        var asset = MockAsset()
        asset.type = "hardware"
        asset.manufacturer = MockMfg()
        try HardwareValidator().validate(asset)
    }
    
    func testHardwareValidator_TypeFailure() {
        var asset = MockAsset()
        asset.type = "software" // Should fail hardware check
        // Even if it has mfg
        asset.manufacturer = MockMfg()
        
        XCTAssertThrowsError(try HardwareValidator().validate(asset)) { error in
             XCTAssertTrue(error is InventoryValidationError)
        }
    }
    
    func testHardwareValidator_MissingMfgFailure() {
        var asset = MockAsset()
        asset.type = "hardware"
        asset.manufacturer = nil
        
        XCTAssertThrowsError(try HardwareValidator().validate(asset)) { error in
            guard case .missingRequiredField(let field, _) = (error as? InventoryValidationError) else {
                XCTFail("Expected missingRequiredField")
                return
            }
            XCTAssertEqual(field, "manufacturer")
        }
    }
    
    // MARK: - Household Validator
    
    func testHouseholdValidator_Success() throws {
        var asset = MockAsset()
        asset.name = "Chair"
        try HouseholdValidator().validate(asset)
    }
    
    func testHouseholdValidator_Failure() {
        var asset = MockAsset()
        asset.name = ""
        
        XCTAssertThrowsError(try HouseholdValidator().validate(asset)) { error in
             guard case .missingRequiredField(let field, _) = (error as? InventoryValidationError) else {
                XCTFail("Expected missingRequiredField")
                return
            }
            XCTAssertEqual(field, "name")
        }
    }
}
