import Foundation

/// The Top-Level Storage Provider Interface.
/// This acts as the factory or container that provides access to the specialized
/// storage subsystems (Private/Public, Metadata/Binary).
///
/// Inject this into `InventoryService` to provide full persistence capabilities.
public protocol StorageProvider: Sendable {
    
    // MARK: - Metadata Objects (Database)
    
    /// Access to the User's Private Metadata Store (Assets, Personal Collections).
    /// Typically backed by CloudKit Private Database or SwiftData.
    var userMetadata: any UserMetadataStore { get }
    
    /// Access to the Public Domain Metadata Store (Products, Shared Collections).
    /// Typically backed by CloudKit Public Database or a read-only SQLite cache.
    var domainMetadata: any DomainMetadataStore { get }
    
    // MARK: - Binary Data (Files)
    
    /// Access to the User's Private File Store (User Data Store).
    /// Typically backed by the local file system (Simulated CAS) or iCloud Drive.
    var userData: any UserDataStore { get }
    
    /// Access to the Public Domain File Cache (Domain Data Store).
    /// Typically backed by a local cache directory that mirrors the Source of Truth.
    var domainData: any DomainDataStore { get }
}
