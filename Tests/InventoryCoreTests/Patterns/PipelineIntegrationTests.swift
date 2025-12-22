import XCTest
import InventoryCore
import DesignAlgorithmsKit
@testable import InventoryCoreTests

final class PipelineIntegrationTests: XCTestCase {
    
    func testFullPipeline_Apple() async throws {
        // Setup
        let context = MockContext()
        let formattingService = FormattingService(context: context)
        let suggestionService = SuggestionService(context: context)
        
        // Build Pipeline: Format -> Enrich
        let pipeline = AsyncDataPipeline<MockContact, MockContact> { input in
            return input // Start with identity
        }
        .appending(FormattingStage(service: formattingService))
        .appending(EnrichmentStage(service: suggestionService))
        
        // Input: "apple " (lowercase + whitespace)
        let input = MockContact(name: "apple ")
        
        // Execute
        let result = try await pipeline.execute(input)
        
        // Verify
        // 1. Formatting fixed whitespace/case (apple -> Apple)
        // 2. Enrichment found "Apple Computer, Inc."
        XCTAssertEqual(result.name, "Apple Computer, Inc.")
    }
    
    func testFullPipeline_Broderbund() async throws {
        let context = MockContext()
        let formattingService = FormattingService(context: context)
        let suggestionService = SuggestionService(context: context)
        
        let pipeline = AsyncDataPipeline<MockContact, MockContact> { $0 }
            .appending(FormattingStage(service: formattingService))
            .appending(EnrichmentStage(service: suggestionService))
        
        // Input: "broderbund" (wrong char)
        let input = MockContact(name: "broderbund")
        
        // Execute
        let result = try await pipeline.execute(input)
        
        // Verify
        // 1. Formatting fixed "broderbund" -> "Brøderbund"
        // 2. Enrichment verified "Brøderbund Software, Inc." in DB and updated it.
        XCTAssertEqual(result.name, "Brøderbund Software, Inc.")
    }
    func testValidationPipeline() async throws {
        let context = MockContext()
        let validationService = InventoryValidationService(context: context)
        
        // Build Pipeline: Validate
        let pipeline = AsyncDataPipeline<MockSystemRequirements, MockSystemRequirements> { $0 }
            .appending(ValidationStage(service: validationService))
        
        // 1. Test Valid Input
        let validInput = MockSystemRequirements(minMemory: 640_000, cpuFamily: "x86")
        let result = try await pipeline.execute(validInput)
        XCTAssertEqual(result.minMemory, 640_000)
        
        // 2. Test Invalid Input (Negative Memory)
        let invalidInput = MockSystemRequirements(minMemory: -100)
        
        do {
            _ = try await pipeline.execute(invalidInput)
            XCTFail("Expected validation error")
        } catch let error as InventoryValidationError {
            if case .validationFailed(let errors) = error {
                XCTAssertTrue(errors.count > 0)
                XCTAssertTrue(errors[0].contains("must be positive"))
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
