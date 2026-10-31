import XCTest
import InventoryTypes

/// Labels resolved through `InventoryLocalizedString` have their keys in every bundled table.
final class LocalizationKeyTests: XCTestCase {

    private func table(_ language: String) throws -> [String: String] {
        let url = try XCTUnwrap(Bundle.inventoryKit.url(forResource: "Localizable", withExtension: "strings",
                                                        subdirectory: nil, localization: language))
        return try XCTUnwrap(NSDictionary(contentsOf: url) as? [String: String])
    }

    func testMediaFormatAndGenericQuestionKeys() throws {
        for language in ["en", "es", "fr"] {
            let strings = try table(language)
            for format in MediaFormatType.allCases {
                XCTAssertNotNil(strings["media_format.\(format.rawValue)"], "\(language): media_format.\(format.rawValue)")
            }
            XCTAssertNotNil(strings["question.genericNotes"], language)
            XCTAssertNotNil(strings["question.manualTags"], language)
            XCTAssertNotNil(strings["condition.needsRecap"], language)
        }
    }

    func testMediaFormatLabelUsesTheTable() throws {
        // English labels come from the table entry for the raw value.
        XCTAssertEqual(MediaFormatType.floppy525.label, try table("en")["media_format.floppy_5_25"])
        XCTAssertEqual(MediaFormatType.cassette.label, "Compact Cassette")
    }
}
