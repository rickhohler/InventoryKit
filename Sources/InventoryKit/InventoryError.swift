import Foundation

/// Errors emitted by InventoryKit APIs.
public enum InventoryError: Error, Equatable, CustomStringConvertible, Sendable {
    case unreadableFile(URL)
    case unsupportedDataEncoding
    case schemaIncompatible(expected: InventorySchemaVersion, actual: InventorySchemaVersion)
    case yamlDecodingFailed(String)
    case yamlEncodingFailed(String)

    public var description: String {
        switch self {
        case let .unreadableFile(url):
            return "Unable to read inventory YAML at \(url.path)."
        case .unsupportedDataEncoding:
            return "Inventory data must be UTF-8 encoded."
        case let .schemaIncompatible(expected, actual):
            return "Schema \(actual) is not compatible with expected major version \(expected.major)."
        case let .yamlDecodingFailed(message):
            return "Failed to decode inventory YAML: \(message)"
        case let .yamlEncodingFailed(message):
            return "Failed to encode inventory YAML: \(message)"
        }
    }
}
