import Foundation

/// Structured copyright information as stored:
/// `{"text": ..., "year": ..., "holder": ..., "license": ..., "metadata": {...}}`.
public struct CopyrightInfoModel: CopyrightInfo, Codable, Hashable, Sendable {
    public var text: String?
    public var year: Int?
    public var holder: String?
    public var license: String?
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

extension CopyrightInfoModel {
    /// Parses a copyright notice such as "© 1983 Broderbund Software",
    /// "Copyright (C) 1981 BY H. ALAN GRIESEMER & STEPHAN C. BRADSHAW" or
    /// "Copyright 1983 Apple Computer". The original text is kept in `text`.
    public static func extract(from copyrightText: String) -> CopyrightInfoModel {
        var copyright = CopyrightInfoModel(text: copyrightText)

        if let yearMatch = copyrightText.range(of: #"\b(19|20)\d{2}\b"#, options: .regularExpression) {
            copyright.year = Int(copyrightText[yearMatch])
        }

        // The holder is the text captured after "BY", "© <year>" or "Copyright [(C)] <year>",
        // up to an opening parenthesis or the end.
        let patterns = [
            #"\bBY\s+(.+?)(?:\s*\(|$)"#,
            #"©\s*\d{4}\s+(.+?)(?:\s*\(|$)"#,
            #"Copyright\s+(?:\(C\)\s*)?\d{4}\s+(.+?)(?:\s*\(|$)"#,
        ]
        for pattern in patterns {
            if let holder = firstCapture(of: pattern, in: copyrightText) {
                copyright.holder = holder
                break
            }
        }

        // Otherwise use the text after the year, without a leading "BY" or "©".
        if copyright.holder == nil, let year = copyright.year,
           let yearRange = copyrightText.range(of: String(year)) {
            var rest = String(copyrightText[yearRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            for prefix in ["BY ", "by ", "By ", "©"] where rest.hasPrefix(prefix) {
                rest = String(rest.dropFirst(prefix.count)).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if rest.count > 2 {
                copyright.holder = rest
            }
        }

        return copyright
    }

    /// Tags for filtering and search: `copyright:extracted`, `copyright:<year>`,
    /// `copyright:<decade>s` and one `copyright:<word>` per holder (split on `&` and `,`),
    /// using the holder's last significant word.
    public func createTags() -> [String] {
        var tags: [String] = []
        if text != nil {
            tags.append("copyright:extracted")
        }
        if let year {
            tags.append("copyright:\(year)")
            tags.append("copyright:\((year / 10) * 10)s")
        }
        guard let holder else { return tags }

        let holders = holder
            .components(separatedBy: CharacterSet(charactersIn: "&,"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let stopWords: Set<String> = ["the", "and", "or", "of", "by", "inc", "llc", "corp", "ltd"]
        for name in holders {
            var normalized = name.lowercased()
                .replacingOccurrences(of: #"[^a-z0-9\s]"#, with: " ", options: .regularExpression)
                .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            for prefix in ["by", "copyright"] where normalized.hasPrefix(prefix + " ") {
                normalized = String(normalized.dropFirst(prefix.count + 1))
            }
            let words = normalized.split(separator: " ").map(String.init)
                .filter { $0.count > 2 && !stopWords.contains($0) }
            if let word = words.last {
                tags.append("copyright:\(word)")
            }
        }
        return tags
    }

    private static func firstCapture(of pattern: String, in text: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              match.numberOfRanges > 1,
              let range = Range(match.range(at: 1), in: text) else {
            return nil
        }
        let captured = text[range].trimmingCharacters(in: .whitespacesAndNewlines)
        return captured.isEmpty ? nil : captured
    }
}
