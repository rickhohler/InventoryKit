import Foundation

/// Data Transfer Object for importing Assets.
public struct AssetImportData: Sendable {
    public let name: String
    public let manufacturerName: String
    public let type: String?
    public let location: String?
    public let acquisitionSource: String?
    public let acquisitionDate: Date?
    public let tags: [String]
    public let metadata: [String: String]
    
    public init(name: String, manufacturerName: String, type: String? = nil, location: String? = nil, acquisitionSource: String? = nil, acquisitionDate: Date? = nil, tags: [String] = [], metadata: [String : String] = [:]) {
        self.name = name
        self.manufacturerName = manufacturerName
        self.type = type
        self.location = location
        self.acquisitionSource = acquisitionSource
        self.acquisitionDate = acquisitionDate
        self.tags = tags
        self.metadata = metadata
    }
}

/// Data Transfer Object for importing Products.
public struct ProductImportData: Sendable {
    public let title: String
    public let manufacturerName: String
    public let platform: String?
    public let releaseDate: Date?
    
    public init(title: String, manufacturerName: String, platform: String? = nil, releaseDate: Date? = nil) {
        self.title = title
        self.manufacturerName = manufacturerName
        self.platform = platform
        self.releaseDate = releaseDate
    }
}
