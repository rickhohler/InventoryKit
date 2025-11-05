import Foundation

/// Represents the semantic version of the inventory schema stored in YAML files.
public struct InventorySchemaVersion: Codable, Equatable, Comparable, CustomStringConvertible, Sendable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let prerelease: String?
    public let buildMetadata: String?

    public static let current = InventorySchemaVersion(major: 1, minor: 0, patch: 0)

    public init(major: Int, minor: Int, patch: Int, prerelease: String? = nil, buildMetadata: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease?.isEmpty == true ? nil : prerelease
        self.buildMetadata = buildMetadata?.isEmpty == true ? nil : buildMetadata
    }

    public init(_ version: String) throws {
        let pattern = #"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-([0-9A-Za-z\-\.]+))?(?:\+([0-9A-Za-z\-\.]+))?$"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            throw InventorySchemaVersionError.internalError("Failed to compile regex.")
        }

        let range = NSRange(location: 0, length: version.utf16.count)
        guard let match = regex.firstMatch(in: version, options: [], range: range) else {
            throw InventorySchemaVersionError.invalidFormat(version)
        }

        let captures = (1...5).map { index -> String? in
            guard let range = Range(match.range(at: index), in: version) else { return nil }
            return String(version[range])
        }

        guard let majorString = captures[0], let minorString = captures[1], let patchString = captures[2],
              let major = Int(majorString), let minor = Int(minorString), let patch = Int(patchString)
        else {
            throw InventorySchemaVersionError.invalidFormat(version)
        }

        self.init(
            major: major,
            minor: minor,
            patch: patch,
            prerelease: captures[3],
            buildMetadata: captures[4]
        )
    }

    public var description: String {
        var base = "\(major).\(minor).\(patch)"
        if let prerelease { base += "-\(prerelease)" }
        if let buildMetadata { base += "+\(buildMetadata)" }
        return base
    }

    public func isCompatible(with version: InventorySchemaVersion) -> Bool {
        major == version.major
    }

    public static func < (lhs: InventorySchemaVersion, rhs: InventorySchemaVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }

        switch (lhs.prerelease, rhs.prerelease) {
        case (.none, .some):
            return false
        case (.some, .none):
            return true
        case let (.some(a), .some(b)):
            return a < b
        default:
            return false
        }
    }
}

extension InventorySchemaVersion {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        try self.init(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

public enum InventorySchemaVersionError: Error, Equatable {
    case invalidFormat(String)
    case internalError(String)
}
