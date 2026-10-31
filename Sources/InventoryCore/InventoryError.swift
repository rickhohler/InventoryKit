import Foundation
import InventoryTypes

/// Errors emitted by InventoryKit APIs.
public enum InventoryError: Error, Equatable, CustomStringConvertible, Sendable {
    case unreadableFile(URL)
    case unsupportedDataEncoding
    case schemaIncompatible(expected: SchemaVersion, actual: SchemaVersion)
    case storageError(String)
    case vendorOperationNotSupported(String)
    case notImplemented(String)

    public var description: String {
        switch self {
        case let .unreadableFile(url):
            return "Unable to read inventory data at \(url.path)."
        case .unsupportedDataEncoding:
            return "Inventory data must be UTF-8 encoded."
        case let .schemaIncompatible(expected, actual):
            return "Schema \(actual) is not compatible with expected major version \(expected.major)."
        case let .storageError(message):
            return "Storage error: \(message)"
        case let .vendorOperationNotSupported(message):
            return "Vendor operation not supported: \(message)"
        case let .notImplemented(message):
            return "Not implemented: \(message)"
        }
    }
}
