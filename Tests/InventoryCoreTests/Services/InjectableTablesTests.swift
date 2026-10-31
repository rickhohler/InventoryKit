import XCTest
import InventoryCore
import InventoryTypes

/// Name tables, manufacturer lists and the date floor can be supplied by the client.
final class InjectableTablesTests: XCTestCase {

    func testNameCorrectionWithClientTable() {
        let strategy = InventoryFormattingStrategies.NameCorrectionStrategy(corrections: ["  ACME Corp ": "Acme Corporation"])
        XCTAssertEqual(strategy.format("acme corp"), "Acme Corporation")
        XCTAssertEqual(strategy.format("broderbund"), "broderbund", "the built-in table is not used")
        // 3.0: no built-in table.
        XCTAssertEqual(InventoryFormattingStrategies.NameCorrectionStrategy().format("broderbund"), "broderbund")
    }

    func testManufacturerLookupWithClientList() async {
        let strategy = ReferenceManufacturerLookupStrategy(knownManufacturers: ["Acme Corporation"])
        let suggestions = await strategy.suggest(for: "acme")
        XCTAssertEqual(suggestions.map(\.suggestedValue), ["Acme Corporation"])
        let empty = await ReferenceManufacturerLookupStrategy(knownManufacturers: []).suggest(for: "apple")
        XCTAssertTrue(empty.isEmpty)
    }

    func testNeutralDefaults() async {
        let context = MockContext()
        var contact = MockContact(name: "broderbund")
        FormattingService(context: context).formatContact(&contact)
        XCTAssertEqual(contact.name, "broderbund", "the default strategy only cleans up")
        let suggestions = await SuggestionService(context: context).suggestManufacturers(for: "apple")
        XCTAssertTrue(suggestions.isEmpty)
    }

    func testDateValidatorFloor() {
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1925, month: 6, day: 1))!
        let defaultValidator = InventoryAppLogicValidators.DateValidator()
        XCTAssertEqual(defaultValidator.earliestPlausibleYear, 1950)
        if case .valid = defaultValidator.validate(date) { XCTFail("1925 is before 1950") }
        if case .valid = InventoryAppLogicValidators.DateValidator(earliestPlausibleYear: 1900).validate(date) {} else {
            XCTFail("1925 is after 1900")
        }
    }
}
