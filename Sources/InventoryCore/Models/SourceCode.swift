import Foundation

/// Represents details about the source code availability for an item.
public struct SourceCode: Codable, Sendable, Hashable {
    /// The URL to the source code repository (e.g. GitHub, GitLab, Archive.org).
    public var url: URL
    
    /// Notes regarding the source code (e.g. "Partial source", "Missing assets").
    public var notes: String?
    
    /// The date when the source code was made open/public, if known.
    public var dateOpened: Date?
    
    /// The license under which the source code is released (e.g. "MIT", "GPLv3").
    public var license: String?
    
    public init(url: URL, 
                notes: String? = nil, 
                dateOpened: Date? = nil, 
                license: String? = nil) {
        self.url = url
        self.notes = notes
        self.dateOpened = dateOpened
        self.license = license
    }
}
