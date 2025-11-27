import XCTest
@testable import InventoryKit

final class DefaultTagRegistryTests: XCTestCase {
    var registry: DefaultTagRegistry!
    
    override func setUp() {
        super.setUp()
        registry = DefaultTagRegistry()
    }
    
    override func tearDown() {
        registry = nil
        super.tearDown()
    }
    
    // MARK: - Tag Registration Tests
    
    func testRegisterTagWithHandler() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
            return "AppleDiskImage"
        }
        
        let isRegistered = try await registry.isRegistered(tag: "dsk", domain: "retroboxfs")
        XCTAssertTrue(isRegistered, "Tag should be registered")
    }
    
    func testRegisterTagWithoutHandler() async throws {
        try await registry.register(tag: "woz", domain: "retroboxfs", handler: nil)
        
        let isRegistered = try await registry.isRegistered(tag: "woz", domain: "retroboxfs")
        XCTAssertTrue(isRegistered, "Tag should be registered even without handler")
    }
    
    func testRegisterMultipleTagsForDomain() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "AppleDiskImage" }
        try await registry.register(tag: "woz", domain: "retroboxfs") { _ in "WozDiskImage" }
        try await registry.register(tag: "a2r", domain: "retroboxfs") { _ in "A2RDiskImage" }
        
        let tags = try await registry.tags(for: "retroboxfs")
        XCTAssertEqual(tags.count, 3, "Should have 3 tags registered")
        XCTAssertTrue(tags.contains("dsk"))
        XCTAssertTrue(tags.contains("woz"))
        XCTAssertTrue(tags.contains("a2r"))
    }
    
    func testRegisterTagsForMultipleDomains() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "AppleDiskImage" }
        try await registry.register(tag: "server", domain: "infrastructure") { _ in "ServerAsset" }
        
        let retroboxfsTags = try await registry.tags(for: "retroboxfs")
        let infrastructureTags = try await registry.tags(for: "infrastructure")
        
        XCTAssertEqual(retroboxfsTags.count, 1)
        XCTAssertEqual(infrastructureTags.count, 1)
        XCTAssertTrue(retroboxfsTags.contains("dsk"))
        XCTAssertTrue(infrastructureTags.contains("server"))
    }
    
    // MARK: - Tag Execution Tests
    
    func testExecuteHandler() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
            return "AppleDiskImage"
        }
        
        let result = try await registry.execute(tag: "dsk", domain: "retroboxfs")
        XCTAssertEqual(result, "AppleDiskImage", "Handler should return correct result")
    }
    
    func testExecuteHandlerWithTagParameter() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
            return "TypeFor\(tag)"
        }
        
        let result = try await registry.execute(tag: "dsk", domain: "retroboxfs")
        XCTAssertEqual(result, "TypeFordsk", "Handler should receive tag as parameter")
    }
    
    func testExecuteNonExistentTag() async throws {
        let result = try await registry.execute(tag: "nonexistent", domain: "retroboxfs")
        XCTAssertNil(result, "Should return nil for non-existent tag")
    }
    
    func testExecuteTagWithoutHandler() async throws {
        try await registry.register(tag: "woz", domain: "retroboxfs", handler: nil)
        
        let result = try await registry.execute(tag: "woz", domain: "retroboxfs")
        XCTAssertNil(result, "Should return nil when tag has no handler")
    }
    
    func testExecuteHandlerThrowsError() async throws {
        try await registry.register(tag: "error", domain: "test") { _ in
            throw NSError(domain: "TestError", code: 1)
        }
        
        do {
            _ = try await registry.execute(tag: "error", domain: "test")
            XCTFail("Should throw error when handler throws")
        } catch {
            // Expected
        }
    }
    
    // MARK: - Tag Query Tests
    
    func testIsRegistered() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "AppleDiskImage" }
        
        let isRegistered = try await registry.isRegistered(tag: "dsk", domain: "retroboxfs")
        XCTAssertTrue(isRegistered)
        
        let notRegistered = try await registry.isRegistered(tag: "nonexistent", domain: "retroboxfs")
        XCTAssertFalse(notRegistered)
    }
    
    func testIsRegisteredCaseInsensitive() async throws {
        try await registry.register(tag: "DSK", domain: "RetroboxFS") { _ in "AppleDiskImage" }
        
        let isRegistered = try await registry.isRegistered(tag: "dsk", domain: "retroboxfs")
        XCTAssertTrue(isRegistered, "Tag lookup should be case-insensitive")
    }
    
    func testTagsForDomain() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "AppleDiskImage" }
        try await registry.register(tag: "woz", domain: "retroboxfs") { _ in "WozDiskImage" }
        try await registry.register(tag: "server", domain: "infrastructure") { _ in "ServerAsset" }
        
        let retroboxfsTags = try await registry.tags(for: "retroboxfs")
        XCTAssertEqual(retroboxfsTags.count, 2)
        XCTAssertTrue(retroboxfsTags.contains("dsk"))
        XCTAssertTrue(retroboxfsTags.contains("woz"))
        
        let infrastructureTags = try await registry.tags(for: "infrastructure")
        XCTAssertEqual(infrastructureTags.count, 1)
        XCTAssertTrue(infrastructureTags.contains("server"))
    }
    
    func testTagsForNonExistentDomain() async throws {
        let tags = try await registry.tags(for: "nonexistent")
        XCTAssertTrue(tags.isEmpty, "Should return empty set for non-existent domain")
    }
    
    func testDomainForTag() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "AppleDiskImage" }
        
        let domain = try await registry.domain(for: "dsk")
        XCTAssertEqual(domain, "retroboxfs", "Should return correct domain for tag")
    }
    
    func testDomainForNonExistentTag() async throws {
        let domain = try await registry.domain(for: "nonexistent")
        XCTAssertNil(domain, "Should return nil for non-existent tag")
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentRegistration() async throws {
        let registry = DefaultTagRegistry()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<100 {
                group.addTask {
                    try? await registry.register(tag: "tag\(i)", domain: "test") { _ in
                        return "Type\(i)"
                    }
                }
            }
        }
        
        let tags = try await registry.tags(for: "test")
        XCTAssertEqual(tags.count, 100, "Should register all tags concurrently")
    }
    
    func testConcurrentExecution() async throws {
        let registry = DefaultTagRegistry()
        try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
            return "AppleDiskImage"
        }
        
        await withTaskGroup(of: String?.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    try? await registry.execute(tag: "dsk", domain: "retroboxfs")
                }
            }
            
            var results: [String?] = []
            for await result in group {
                results.append(result)
            }
            
            XCTAssertEqual(results.count, 100)
            XCTAssertTrue(results.allSatisfy { $0 == "AppleDiskImage" })
        }
    }
    
    // MARK: - Edge Cases
    
    func testEmptyTag() async throws {
        try await registry.register(tag: "", domain: "test") { _ in "EmptyTag" }
        
        let isRegistered = try await registry.isRegistered(tag: "", domain: "test")
        XCTAssertTrue(isRegistered)
    }
    
    func testEmptyDomain() async throws {
        try await registry.register(tag: "test", domain: "") { _ in "EmptyDomain" }
        
        let isRegistered = try await registry.isRegistered(tag: "test", domain: "")
        XCTAssertTrue(isRegistered)
    }
    
    func testUpdateHandler() async throws {
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "OldType" }
        
        var result = try await registry.execute(tag: "dsk", domain: "retroboxfs")
        XCTAssertEqual(result, "OldType")
        
        try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "NewType" }
        
        result = try await registry.execute(tag: "dsk", domain: "retroboxfs")
        XCTAssertEqual(result, "NewType", "Handler should be updated")
    }
}

