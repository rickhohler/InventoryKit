//
//  CatalogVendorType.swift
//  InventoryKit
//
//  Type of catalog vendor enumeration
//

import Foundation

/// Type of catalog vendor.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum CatalogVendorType: String, Sendable, Codable {
    case archive              // Digital archive (Archive.org, Internet Archive)
    case museum               // Museum collection
    case database             // Game/software database (MobyGames, etc.)
    case preservationProject  // Software preservation project
    case communityArchive     // Community-maintained archive
    case publisher            // Original publisher/manufacturer
    case distributor          // Software distributor
    case other
    
    public var displayName: String {
        switch self {
        case .archive: return "Archive"
        case .museum: return "Museum"
        case .database: return "Database"
        case .preservationProject: return "Preservation Project"
        case .communityArchive: return "Community Archive"
        case .publisher: return "Publisher"
        case .distributor: return "Distributor"
        case .other: return "Other"
        }
    }
}

