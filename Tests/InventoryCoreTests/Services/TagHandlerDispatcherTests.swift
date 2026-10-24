import XCTest
@testable import InventoryCore

final class TagHandlerDispatcherTests: XCTestCase {
    struct Item: Sendable { let name: String }

    func testValueHandlersRunForTheSubjectsTags() async throws {
        let registry = InMemoryTagRegistry()
        let dispatcher = TagHandlerDispatcher<Item>(tagRegistry: registry, defaultDomain: "test")
        try await dispatcher.registerHandler(tag: " Computer ") { tag, item in "\(tag):\(item.name)" }

        let results = try await dispatcher.executeHandlers(for: Item(name: "IIe"), tags: ["COMPUTER", "other"])

        XCTAssertEqual(results, ["computer": "computer:IIe"])
        let domain = try await registry.domain(for: "computer")
        XCTAssertEqual(domain, "test")
        let has = await dispatcher.hasHandler(tag: "computer")
        XCTAssertTrue(has)
    }

    func testChangeHandlersAndInvalidNames() async throws {
        let dispatcher = TagHandlerDispatcher<Item>(tagRegistry: InMemoryTagRegistry(), defaultDomain: "test")
        let seen = Seen()
        try await dispatcher.registerChangeHandler(tag: "favorite") { tag, item, added in await seen.add("\(tag) \(item.name) \(added)") }
        try await dispatcher.notifyTagChange(tag: "Favorite", subject: Item(name: "C64"), isAdded: true)
        let events = await seen.events
        XCTAssertEqual(events, ["favorite C64 true"])

        do {
            try await dispatcher.registerHandler(tag: "   ") { _, _ in nil }
            XCTFail("empty tag accepted")
        } catch TagHandlerError.invalidTagName {}
    }

    actor Seen {
        var events: [String] = []
        func add(_ event: String) { events.append(event) }
    }
}
