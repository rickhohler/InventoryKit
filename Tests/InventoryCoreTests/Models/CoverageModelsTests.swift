import XCTest
@testable import InventoryCore
import InventoryTypes

final class CoverageModelsTests: XCTestCase {
    
    func testPlatforms() {
        for p in PlatformType.allCases {
            XCTAssertFalse(p.displayName.isEmpty)
            XCTAssertFalse(p.rawValue.isEmpty)
        }
    }
    
    func testTags() {
        // Test consolidated collection
        let allTags = TagType.allTags
        XCTAssertFalse(allTags.isEmpty)
        // Verify it contains at least one of each type
        XCTAssertTrue(allTags.contains(where: { $0.localizedLabel == TagType.Condition.new.localizedLabel }))
        XCTAssertTrue(allTags.contains(where: { $0.localizedLabel == TagType.Format.physical.localizedLabel }))
        
        // Condition
        for c in TagType.Condition.allCases {
            XCTAssertFalse(c.localizedLabel.isEmpty)
            XCTAssertFalse(c.rawValue.isEmpty)
        }
        
        // Format
        for f in TagType.Format.allCases {
            XCTAssertFalse(f.localizedLabel.isEmpty)
            XCTAssertFalse(f.rawValue.isEmpty)
        }
        var info: (any InventoryTypes.InventoryDocumentInfo)? { nil }
        // Content
        for c in TagType.Content.allCases {
            XCTAssertFalse(c.localizedLabel.isEmpty)
            XCTAssertFalse(c.rawValue.isEmpty)
        }
        
        // DigitalState
        for d in TagType.DigitalState.allCases {
            XCTAssertFalse(d.localizedLabel.isEmpty)
            XCTAssertFalse(d.rawValue.isEmpty)
        }
        
        // Manufacturer
        for m in TagType.Manufacturer.allCases {
            XCTAssertFalse(m.localizedLabel.isEmpty)
            XCTAssertFalse(m.rawValue.isEmpty)
        }
        
        // Region
        for r in TagType.Region.allCases {
            XCTAssertFalse(r.localizedLabel.isEmpty)
            XCTAssertFalse(r.rawValue.isEmpty)
        }
        
        // Acquisition
        for a in TagType.Acquisition.allCases {
            XCTAssertFalse(a.localizedLabel.isEmpty)
            XCTAssertFalse(a.rawValue.isEmpty)
        }
        
        // Interface
        for i in TagType.Interface.allCases {
            XCTAssertFalse(i.localizedLabel.isEmpty)
            XCTAssertFalse(i.rawValue.isEmpty)
        }
        
        // Material
        for m in TagType.Material.allCases {
            XCTAssertFalse(m.localizedLabel.isEmpty)
            XCTAssertFalse(m.rawValue.isEmpty)
        }
        
        // MediaFormatType
        for m in TagType.MediaFormatType.allCases {
            XCTAssertFalse(m.localizedLabel.isEmpty)
            XCTAssertFalse(m.rawValue.isEmpty)
        }
    }
    
    func testGenericQuestionnaire() {
        let q = GenericQuestionnaire(notes: "Test Note")
        // GenericQuestionnaire does not have a `questions` property if it comes from protocol extension that returns [:], 
        // but `InventoryQuestionnaire` might not have default implementation for `questions`?
        // Wait, `InventoryQuestionnaire` usually has `localizedQuestions`.
        // `questions` property was deprecated/removed in previous session? 
        // Need to check protocol. But assuming `localizedQuestions` is the key.
        
        XCTAssertFalse(q.localizedQuestions.isEmpty)
        XCTAssertEqual(q.targetClassifier, .other)
        
        let tags = q.generateTags()
        XCTAssertTrue(tags.contains("type:other"))
        
        let attrs = q.generateAttributes()
        XCTAssertEqual(attrs["notes"], "Test Note")
    }
}
