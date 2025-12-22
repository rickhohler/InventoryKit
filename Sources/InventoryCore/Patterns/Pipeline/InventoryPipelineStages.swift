import Foundation
import DesignAlgorithmsKit

/// A Stage that runs the Formatting Service.
public struct FormattingStage<T: InventoryContact>: AsyncDataPipelineStage {
    public typealias Input = T
    public typealias Output = T
    
    private let service: FormattingService
    
    public init(service: FormattingService) {
        self.service = service
    }
    
    public func process(_ input: T) async throws -> T {
        var mutableInput = input
        service.formatContact(&mutableInput)
        return mutableInput
    }
}

/// A Stage that runs the Suggestion/Enrichment Service.
public struct EnrichmentStage<T: InventoryContact>: AsyncDataPipelineStage {
    public typealias Input = T
    public typealias Output = T
    
    private let service: SuggestionService
    
    public init(service: SuggestionService) {
        self.service = service
    }
    
    public func process(_ input: T) async throws -> T {
        var mutableInput = input
        await service.enrichContact(&mutableInput)
        return mutableInput
    }
}

/// A Stage that runs the Validation Service.
/// Throws an error if validation fails.
public struct ValidationStage<T: InventorySystemRequirements>: AsyncDataPipelineStage {
    public typealias Input = T
    public typealias Output = T
    
    private let service: InventoryValidationService
    
    public init(service: InventoryValidationService) {
        self.service = service
    }
    
    public func process(_ input: T) async throws -> T {
        let result = service.validate(input)
        
        if result.isValid {
            // Pass through. We could attach warnings to metadata if T supports it?
            // For now, simple pass-through.
            return input
        } else {
            // Throw error
            throw InventoryValidationError.validationFailed(errors: result.errors)
        }
    }
}
