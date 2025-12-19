//
//  InventoryCollectionTypes.swift
//  InventoryKit
//
//  Collection type constants
//

import Foundation

/// Collection type constants for product catalogs.
///
/// Collection types are stored as strings in asset metadata (`metadata["collectionType"]`).
/// This provides constants for standard collection types while allowing flexibility.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum InventoryCollectionTypes {
    /// Source collection from a trusted source (Archive.org collection, etc.)
    public static let sourceCollection = "sourceCollection"
    
    /// Game series (e.g., "Lode Runner Series")
    public static let gameSeries = "gameSeries"
    
    /// Platform-specific collection (e.g., "Apple II Games")
    public static let platformCollection = "platformCollection"
    
    /// Genre-based collection (e.g., "Adventure Games")
    public static let genreCollection = "genreCollection"
    
    /// Publisher collection (e.g., "Broderbund Games")
    public static let publisherCollection = "publisherCollection"
    
    /// Curated by community or experts
    public static let curatedCollection = "curatedCollection"
    
    /// Museum collection
    public static let museumCollection = "museumCollection"
    
    /// Software preservation project
    public static let preservationCollection = "preservationCollection"
    
    /// Other collection type
    public static let other = "other"
}

