import Foundation

/// Questionnaire for Documents, Books, and Manuals.
public struct PublicationQuestionnaire: InventoryQuestionnaire {
    public var targetClassifier: InventoryItemClassifier { .document }
    
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
            "title": NSLocalizedString("question.pubTitle", bundle: .inventoryKit, value: "Title of the publication:", comment: "Question: Title"),
            "author": NSLocalizedString("question.author", bundle: .inventoryKit, value: "Author (optional):", comment: "Question: Author"),
            "isbn": NSLocalizedString("question.isbn", bundle: .inventoryKit, value: "ISBN / Catalog Number:", comment: "Question: ISBN"),
            "publicationYear": NSLocalizedString("question.pubYear", bundle: .inventoryKit, value: "Year of publication:", comment: "Question: Year"),
            "pageCount": NSLocalizedString("question.pageCount", bundle: .inventoryKit, value: "Number of pages:", comment: "Question: Pages"),
            "binding": NSLocalizedString("question.binding", bundle: .inventoryKit, value: "What is the binding type?", comment: "Question: Binding")
        ]
    }
}
