//
//  InMemoryTagRegistry.swift
//  InventoryCore
//
//  Default InventoryTagRegistry implementation (successor of 1.x DefaultTagRegistry).
//

import Foundation

/// Thread-safe, in-memory tag registry. Tags and domains are case-insensitive.
public actor InMemoryTagRegistry: InventoryTagRegistry {
    public typealias TagHandler = @Sendable (String) async throws -> String

    private var handlers: [String: [String: TagHandler]] = [:]
    private var registeredTags: [String: Set<String>] = [:]
    private var tagToDomain: [String: String] = [:]

    public init() {}

    public func register(tag: String, domain: String, handler: TagHandler?) async throws {
        let normalizedTag = tag.lowercased()
        let normalizedDomain = domain.lowercased()
        if let handler {
            handlers[normalizedDomain, default: [:]][normalizedTag] = handler
        }
        registeredTags[normalizedDomain, default: []].insert(normalizedTag)
        tagToDomain[normalizedTag] = normalizedDomain
    }

    public func isRegistered(tag: String, domain: String) async throws -> Bool {
        registeredTags[domain.lowercased()]?.contains(tag.lowercased()) ?? false
    }

    public func execute(tag: String, domain: String) async throws -> String? {
        let normalizedTag = tag.lowercased()
        let normalizedDomain = domain.lowercased()
        guard try await isRegistered(tag: normalizedTag, domain: normalizedDomain),
              let handler = handlers[normalizedDomain]?[normalizedTag] else {
            return nil
        }
        return try await handler(normalizedTag)
    }

    public func tags(for domain: String) async throws -> Set<String> {
        registeredTags[domain.lowercased()] ?? []
    }

    public func domain(for tag: String) async throws -> String? {
        tagToDomain[tag.lowercased()]
    }
}
