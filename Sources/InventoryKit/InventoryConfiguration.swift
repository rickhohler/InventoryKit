import Foundation

/// Logging verbosity for InventoryKit services.
public enum InventoryLogLevel: Int, Sendable {
    case error = 0
    case warning = 1
    case info = 2
    case debug = 3

    func allows(_ level: InventoryLogLevel) -> Bool {
        level.rawValue <= rawValue
    }

    var label: String {
        switch self {
        case .error: return "ERROR"
        case .warning: return "WARN"
        case .info: return "INFO"
        case .debug: return "DEBUG"
        }
    }
}

/// Shared configuration used to bootstrap InventoryKit services.
public struct InventoryConfiguration: Sendable {
    public var provider: InventoryStorageProvider
    public var schemaVersion: InventorySchemaVersion
    public var logLevel: InventoryLogLevel

    public init(
        provider: InventoryStorageProvider,
        schemaVersion: InventorySchemaVersion = .current,
        logLevel: InventoryLogLevel = .warning
    ) {
        self.provider = provider
        self.schemaVersion = schemaVersion
        self.logLevel = logLevel
    }
}
