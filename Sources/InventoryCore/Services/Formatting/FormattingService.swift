import Foundation
import InventoryTypes

/// Service responsible for data hygiene and formatting.
///
/// The `FormattingService` adheres to the **Single Responsibility Principle**:
/// It cleans and normalizes data (e.g., stripping whitespace, correcting capitalization)
/// but does not validate correctness or fetch missing data.
///
/// ## Usage
/// ```swift
/// let service = FormattingService(context: context)
/// service.formatContact(&contact)
/// ```
public struct FormattingService: Sendable {
    
    private let context: Context
    private let nameStrategy: any FormattingStrategy
    
    /// Creates a new formatting service.
    /// - Parameters:
    ///   - context: The shared `Context` containing dependencies.
    ///   - nameStrategy: The strategy to use for name cleaning. Defaults to `NameCorrectionStrategy`.
    public init(
        context: Context,
        nameStrategy: any FormattingStrategy = InventoryFormattingStrategies.NameCorrectionStrategy()
    ) {
        self.context = context
        self.nameStrategy = nameStrategy
    }
    
    // MARK: - Formatters
    
    /// Formats and corrects a Manufacturer's data.
    /// - Parameter manufacturer: The manufacturer instance to format (inout).
    public func format<T: Manufacturer>(_ manufacturer: inout T) {
        // 1. Get current values
        let rawName = manufacturer.name
        
        // 2. Apply Strategies
        let cleanedName = nameStrategy.format(rawName)
        
        // 3. Write back using Configurator (if changed)
        if rawName != cleanedName {
            context.configurator.configure(
                &manufacturer,
                id: nil, // Keep existing
                name: cleanedName, // Update
                slug: manufacturer.slug, // Keep existing (or regenerate?)
                description: manufacturer.description,
                metadata: manufacturer.metadata,
                aliases: manufacturer.aliases
            )
        }
    }
    
    /// Formats a Contact (Person/Company).
    /// - Parameter contact: The contact instance to format (inout).
    public func formatContact<T: Contact>(_ contact: inout T) {
        let rawName = contact.name
        let cleanedName = nameStrategy.format(rawName)
        
        if rawName != cleanedName {
            context.configurator.configure(
                &contact,
                id: nil, // Keep existing
                name: cleanedName, // Update
                title: nil,
                email: nil,
                notes: nil,
                socialMedia: contact.socialMedia // Keep existing
            )
        }
    }
}
