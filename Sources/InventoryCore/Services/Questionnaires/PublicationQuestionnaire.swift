import InventoryTypes
import Foundation

/// Questionnaire for Documents, Books, and Manuals.
public struct PublicationQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: ItemClassifierType { .document }
    
    public var title: String
    public var author: String?
    public var isbn: String?
    public var publicationYear: Int?
    public var pageCount: Int?
    
    public enum Binding: String, Codable, Sendable {
        case hardcover = "binding:hardcover"
        case softcover = "binding:softcover"
        case spiral = "binding:spiral"
        case digitalPDF = "format:pdf"
        case digitalEPUB = "format:epub"
        case looseLeaf = "binding:loose_leaf"
    }
    public var binding: Binding
    
    public init(
        title: String,
        author: String? = nil,
        isbn: String? = nil,
        publicationYear: Int? = nil,
        pageCount: Int? = nil,
        binding: Binding = .softcover
    ) {
        self.title = title
        self.author = author
        self.isbn = isbn
        self.publicationYear = publicationYear
        self.pageCount = pageCount
        self.binding = binding
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        tags.append(binding.rawValue)
        
        if publicationYear != nil {
            tags.append("vintage")
        }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        attrs["title"] = title
        if let auth = author { attrs["author"] = auth }
        if let code = isbn { attrs["isbn"] = code }
        if let year = publicationYear { attrs["year"] = String(year) }
        if let pages = pageCount { attrs["page_count"] = String(pages) }
        attrs["binding"] = binding.rawValue
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "title": InventoryLocalizedString("question.pubTitle", value: "Title of the publication:", comment: "Question: Title"),
            "author": InventoryLocalizedString("question.author", value: "Author (optional):", comment: "Question: Author"),
            "isbn": InventoryLocalizedString("question.isbn", value: "ISBN / Catalog Number:", comment: "Question: ISBN"),
            "publicationYear": InventoryLocalizedString("question.pubYear", value: "Year of publication:", comment: "Question: Year"),
            "pageCount": InventoryLocalizedString("question.pageCount", value: "Number of pages:", comment: "Question: Pages"),
            "binding": InventoryLocalizedString("question.binding", value: "What is the binding type?", comment: "Question: Binding")
        ]
    }
}
