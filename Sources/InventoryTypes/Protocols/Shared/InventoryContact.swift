import Foundation

/// Represents a key principal, founder, or notable person associated with a manufacturer.
/// Represents a key principal, founder, or notable person associated with a manufacturer.
public protocol Contact: Codable, Sendable, Identifiable {
    var id: UUID { get set }
    var name: String { get set }
    var title: String? { get set }
    var email: String? { get set }
    var notes: String? { get set }
    var socialMedia: SocialMedia { get set }
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
