import Foundation

/// Represents a key principal, founder, or notable person associated with a manufacturer.
public struct Contact: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var title: String?
    public var email: String?
    public var notes: String?
    public var socialMedia: SocialMedia
    
    public init(id: UUID = UUID(),
                name: String,
                title: String? = nil,
                email: String? = nil,
                notes: String? = nil,
                socialMedia: SocialMedia = SocialMedia()) {
        self.id = id
        self.name = name
        self.title = title
        self.email = email
        self.notes = notes
        self.socialMedia = socialMedia
    }
}

/// Social media presence/handles.
public struct SocialMedia: Codable, Sendable, Hashable {
    public var xAccount: String?      // Twitter/X
    public var github: String?        // Source code
    public var mastodon: String?      // Fediverse
    public var linkedIn: String?      // Professional
    public var youtube: String?       // Videos/Interviews
    public var website: String?       // Personal site
    public var bluesky: String?       // bsky.app
    public var threads: String?       // Instagram Threads
    
    public init(xAccount: String? = nil,
                github: String? = nil,
                mastodon: String? = nil,
                linkedIn: String? = nil,
                youtube: String? = nil,
                website: String? = nil,
                bluesky: String? = nil,
                threads: String? = nil) {
        self.xAccount = xAccount
        self.github = github
        self.mastodon = mastodon
        self.linkedIn = linkedIn
        self.youtube = youtube
        self.website = website
        self.bluesky = bluesky
        self.threads = threads
    }
}
