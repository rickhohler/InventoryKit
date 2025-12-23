import Foundation
import InventoryTypes
import InventoryCore
import DesignAlgorithmsKit

/// Public facade for accessing InventoryKit services.
/// Provides a unified entry point for Transactions, Locations, and Validation.
public protocol InventoryServices: Facade, Sendable {
    /// Service for data ingestion and modification transactions.
    var transactions: any TransactionService { get }
    
    /// Service for querying and managing physical/digital locations.
    var locations: any InventoryLocationService { get }
    
    /// Service for validating business rules.
    var validation: InventoryValidationService { get }
    
    /// Service for managing asset relationships.
    var relationships: any RelationshipService { get }
}

/// Concrete implementation of the InventoryKit services facade.
public final class InventoryServiceFacade: InventoryServices {
    
    public let facadeID = "InventoryKit.Services"
    
    // Internal Service Storage
    private let _transactions: InventoryTransactionService
    private let _locations: DefaultLocationService
    private let _validation: InventoryValidationService
    private let _relationships: InventoryRelationshipService
    
    // MARK: - Initialization
    
    internal init(storage: any StorageProvider, configurator: any Configurator, context: any Context) {
        self._transactions = InventoryTransactionService(storage: storage, configurator: configurator)
        self._locations = DefaultLocationService(storage: storage)
        self._validation = InventoryValidationService(context: context)
        self._relationships = InventoryRelationshipService(storage: storage)
    }
    
    // MARK: - Public API
    
    public var transactions: any TransactionService { _transactions }
    public var locations: any InventoryLocationService { _locations }
    public var validation: InventoryValidationService { _validation }
    public var relationships: any RelationshipService { _relationships }
}
