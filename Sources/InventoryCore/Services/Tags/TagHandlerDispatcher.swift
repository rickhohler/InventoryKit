import Foundation

/// Runs handlers registered per tag for a subject (for example an asset) that carries tags.
///
/// Tags are normalized (trimmed, lowercased). Registering a value handler also registers the
/// tag in the `InventoryTagRegistry` under a domain; when the registry has its own handler for a
/// tag's domain, its result is used as well.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public actor TagHandlerDispatcher<Subject: Sendable> {
    /// Produces a value for a tag on a subject, or nil.
    public typealias ValueHandler = @Sendable (_ tag: String, _ subject: Subject) async throws -> String?
    /// Called when a tag is added to (`true`) or removed from (`false`) a subject.
    public typealias ChangeHandler = @Sendable (_ tag: String, _ subject: Subject, _ isAdded: Bool) async throws -> Void

    private let tagRegistry: any InventoryTagRegistry
    /// Domain used when a handler is registered without one.
    public let defaultDomain: String
    private var valueHandlers: [String: ValueHandler] = [:]
    private var changeHandlers: [String: ChangeHandler] = [:]

    public init(tagRegistry: any InventoryTagRegistry, defaultDomain: String) {
        self.tagRegistry = tagRegistry
        self.defaultDomain = defaultDomain
    }

    /// Normalized form of a tag: trimmed and lowercased.
    public static func normalize(_ tag: String) -> String {
        tag.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: Registration

    /// Registers a value handler for `tag` and records the tag in the registry under `domain`
    /// (default `defaultDomain`).
    public func registerHandler(tag: String, domain: String? = nil, handler: @escaping ValueHandler) async throws {
        let normalized = Self.normalize(tag)
        guard !normalized.isEmpty else { throw TagHandlerError.invalidTagName(tag) }
        try await tagRegistry.register(tag: normalized, domain: domain ?? defaultDomain, handler: nil)
        valueHandlers[normalized] = handler
    }

    public func registerChangeHandler(tag: String, handler: @escaping ChangeHandler) throws {
        let normalized = Self.normalize(tag)
        guard !normalized.isEmpty else { throw TagHandlerError.invalidTagName(tag) }
        changeHandlers[normalized] = handler
    }

    public func unregisterHandler(tag: String) {
        let normalized = Self.normalize(tag)
        valueHandlers.removeValue(forKey: normalized)
        changeHandlers.removeValue(forKey: normalized)
    }

    public func registeredTags() -> Set<String> {
        Set(valueHandlers.keys)
    }

    public func hasHandler(tag: String) -> Bool {
        let normalized = Self.normalize(tag)
        return valueHandlers[normalized] != nil || changeHandlers[normalized] != nil
    }

    // MARK: Execution

    /// Results of the handlers for each of `tags` on `subject`, keyed by normalized tag. A
    /// registry handler's result for the tag's domain replaces the value handler's result.
    public func executeHandlers(for subject: Subject, tags: [String]) async throws -> [String: String] {
        var results: [String: String] = [:]
        for tag in tags {
            let normalized = Self.normalize(tag)
            if let handler = valueHandlers[normalized], let result = try await handler(normalized, subject) {
                results[normalized] = result
            }
            if let domain = try await tagRegistry.domain(for: normalized),
               let registryResult = try await tagRegistry.execute(tag: normalized, domain: domain) {
                results[normalized] = registryResult
            }
        }
        return results
    }

    /// The value handler's result for `tag`, else the registry handler's, else nil.
    public func executeHandler(tag: String, for subject: Subject) async throws -> String? {
        let normalized = Self.normalize(tag)
        if let handler = valueHandlers[normalized] {
            return try await handler(normalized, subject)
        }
        if let domain = try await tagRegistry.domain(for: normalized) {
            return try await tagRegistry.execute(tag: normalized, domain: domain)
        }
        return nil
    }

    public func notifyTagChange(tag: String, subject: Subject, isAdded: Bool) async throws {
        let normalized = Self.normalize(tag)
        if let handler = changeHandlers[normalized] {
            try await handler(normalized, subject, isAdded)
        }
    }
}

/// Errors from `TagHandlerDispatcher`.
public enum TagHandlerError: LocalizedError {
    case invalidTagName(String)
    case handlerExecutionFailed(String, Error)

    public var errorDescription: String? {
        switch self {
        case .invalidTagName(let name):
            return "Invalid tag name for handler: '\(name)'"
        case .handlerExecutionFailed(let tag, let error):
            return "Handler execution failed for tag '\(tag)': \(error.localizedDescription)"
        }
    }
}
