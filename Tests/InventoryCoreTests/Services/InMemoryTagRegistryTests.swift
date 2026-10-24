//
//  InMemoryTagRegistryTests.swift
//  InventoryCoreTests
//

import XCTest
import InventoryCore

final class InMemoryTagRegistryTests: XCTestCase {

    func testCaseInsensitiveExecution() async throws {
        let registry = InMemoryTagRegistry()
        try await registry.register(tag: "DSK", domain: "RetroboxFS") { _ in "AppleDiskImage" }
        let result = try await registry.execute(tag: "dsk", domain: "retroboxfs")
        XCTAssertEqual(result, "AppleDiskImage")
    }

    func testTagWithoutHandler() async throws {
        let registry = InMemoryTagRegistry()
        try await registry.register(tag: "woz", domain: "fs", handler: nil)
        let registered = try await registry.isRegistered(tag: "WOZ", domain: "FS")
        let result = try await registry.execute(tag: "woz", domain: "fs")
        XCTAssertTrue(registered)
        XCTAssertNil(result)
    }

    func testUnregisteredTagAndDomainQueries() async throws {
        let registry = InMemoryTagRegistry()
        try await registry.register(tag: "a2r", domain: "Flux", handler: nil)
        try await registry.register(tag: "woz", domain: "flux", handler: nil)
        let unknown = try await registry.execute(tag: "nib", domain: "flux")
        let tags = try await registry.tags(for: "FLUX")
        let domain = try await registry.domain(for: "A2R")
        XCTAssertNil(unknown)
        XCTAssertEqual(tags, ["a2r", "woz"])
        XCTAssertEqual(domain, "flux")
    }

    func testTagMapsToLastDomain() async throws {
        let registry = InMemoryTagRegistry()
        try await registry.register(tag: "dsk", domain: "apple", handler: nil)
        try await registry.register(tag: "dsk", domain: "tandy", handler: nil)
        let domain = try await registry.domain(for: "dsk")
        XCTAssertEqual(domain, "tandy")
    }
}
