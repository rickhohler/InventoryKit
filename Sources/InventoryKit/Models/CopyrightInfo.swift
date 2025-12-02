import Foundation

/// Represents copyright information for an asset.
///
/// `CopyrightInfo` stores structured copyright data including the full copyright text,
/// extracted year, holder, and license information. This enables both exact text preservation
/// and structured querying.
///
/// ## Usage
///
/// ```swift
/// let copyright = CopyrightInfo(
///     text: "© 1983 Broderbund Software",
///     year: 1983,
///     holder: "Broderbund Software",
///     license: "Commercial"
/// )
/// ```
///
/// ## Copyright Text Extraction
///
/// Copyright text can be extracted from various formats:
/// - "© 1983 Broderbund Software"
/// - "Copyright (C) 1981 BY H. ALAN GRIESEMER & STEPHAN C. BRADSHAW"
/// - "Copyright 1983 Apple Computer"
///
/// - SeeAlso: ``InventoryAssetProtocol`` for asset protocol
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CopyrightInfo: Codable, Equatable, Hashable, Sendable {
    /// Full copyright text (preserved exactly as found).
    ///
    /// This preserves the exact copyright string without normalization,
    /// maintaining capitalization, formatting, and special characters.
    public var text: String?
    
    /// Copyright year (extracted from text).
    ///
    /// Extracted from copyright text using pattern matching.
    /// Typically a 4-digit year (e.g., 1983, 1981).
    public var year: Int?
    
    /// Copyright holder(s) (extracted from text).
    ///
    /// Extracted from copyright text, typically after "BY", "©", or "Copyright".
    /// May contain multiple holders separated by "&" or ",".
    public var holder: String?
    
    /// License type (if applicable).
    ///
    /// Examples: "Commercial", "Shareware", "Public Domain", "GPL", etc.
    public var license: String?
    
    /// Additional copyright metadata.
    ///
    /// Flexible key-value storage for additional copyright-related information.
    public var metadata: [String: String]
    
    public init(
        text: String? = nil,
        year: Int? = nil,
        holder: String? = nil,
        license: String? = nil,
        metadata: [String: String] = [:]
    ) {
        self.text = text
        self.year = year
        self.holder = holder
        self.license = license
        self.metadata = metadata
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CopyrightInfo {
    /// Extracts copyright information from a copyright string.
    ///
    /// Parses common copyright formats:
    /// - "© 1983 Broderbund Software"
    /// - "Copyright (C) 1981 BY H. ALAN GRIESEMER & STEPHAN C. BRADSHAW"
    /// - "Copyright 1983 Apple Computer"
    /// - "©1983 Broderbund Software"
    ///
    /// - Parameter copyrightText: Copyright string to parse
    /// - Returns: CopyrightInfo with extracted fields
    public static func extract(from copyrightText: String) -> CopyrightInfo {
        var copyright = CopyrightInfo()
        copyright.text = copyrightText  // Preserve exact text
        
        // Extract year (4-digit year, typically 1900-2099)
        if let yearMatch = copyrightText.range(of: #"\b(19|20)\d{2}\b"#, options: .regularExpression) {
            let yearString = String(copyrightText[yearMatch])
            copyright.year = Int(yearString)
        }
        
        // Extract holder (after "BY", "©", or "Copyright")
        // Pattern: "BY <holder>" or "© <year> <holder>" or "Copyright <year> <holder>"
        let patterns = [
            #"BY\s+(.+?)(?:\s*\(|$)"#,  // "BY H. ALAN GRIESEMER & STEPHAN C. BRADSHAW"
            #"©\s*\d{4}\s+(.+?)(?:\s*\(|$)"#,  // "© 1983 Broderbund Software"
            #"Copyright\s+(?:\(C\)\s*)?\d{4}\s+(.+?)(?:\s*\(|$)"#  // "Copyright 1983 Apple Computer"
        ]
        
        for pattern in patterns {
            if let holderRange = copyrightText.range(of: pattern, options: [.regularExpression, .caseInsensitive]) {
                let holderText = String(copyrightText[holderRange.upperBound...])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "()"))
                
                if !holderText.isEmpty {
                    copyright.holder = holderText
                    break
                }
            }
        }
        
        // If no holder found with patterns, try to extract after year
        if copyright.holder == nil, let year = copyright.year {
            let yearString = String(year)
            if let yearRange = copyrightText.range(of: yearString) {
                let afterYear = String(copyrightText[yearRange.upperBound...])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "BY©()"))
                
                if !afterYear.isEmpty && afterYear.count > 2 {
                    copyright.holder = afterYear.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        return copyright
    }
    
    /// Creates categorization tags from copyright information.
    ///
    /// Generates tags for filtering and searching:
    /// - `copyright:extracted` - Status tag
    /// - `copyright:<year>` - Year tag (e.g., "copyright:1981")
    /// - `copyright:<decade>s` - Decade tag (e.g., "copyright:1980s")
    /// - `copyright:<holder>` - Holder tag (normalized, e.g., "copyright:griesemer")
    ///
    /// - Returns: Array of tag strings
    public func createTags() -> [String] {
        var tags: [String] = []
        
        // Status tag
        if text != nil {
            tags.append("copyright:extracted")
        }
        
        // Year tag (for filtering)
        if let year = year {
            tags.append("copyright:\(year)")
            
            // Decade tag
            let decade = (year / 10) * 10
            tags.append("copyright:\(decade)s")
        }
        
        // Holder tag (normalized, for search)
        if let holder = holder {
            // Split on "&" or "," for multiple holders
            let holders = holder
                .components(separatedBy: CharacterSet(charactersIn: "&,"))
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            for holder in holders {
                // Extract meaningful words from holder name
                // Remove common prefixes and normalize
                var normalizedHolder = holder
                    .lowercased()
                    .replacingOccurrences(of: #"[^a-z0-9\s]"#, with: " ", options: .regularExpression)
                    .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Remove common prefixes
                let prefixes = ["by", "copyright", "©"]
                for prefix in prefixes {
                    if normalizedHolder.hasPrefix(prefix + " ") {
                        normalizedHolder = String(normalizedHolder.dropFirst(prefix.count + 1))
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                
                // Split into words and filter out single letters and common words
                let words = normalizedHolder
                    .components(separatedBy: " ")
                    .filter { word in
                        // Filter out single letters and very short words
                        word.count > 2 &&
                        // Filter out common words
                        !["the", "and", "or", "of", "by", "inc", "llc", "corp", "ltd"].contains(word)
                    }
                
                // Use meaningful words for tags
                // Prefer last name (last word) or company name (first significant word)
                if let lastWord = words.last, lastWord.count > 2 {
                    // Use last name/company name
                    tags.append("copyright:\(lastWord)")
                } else if let firstSignificantWord = words.first(where: { $0.count > 3 }), firstSignificantWord.count > 3 {
                    // Fallback to first significant word
                    tags.append("copyright:\(firstSignificantWord)")
                }
            }
        }
        
        return tags
    }
}

