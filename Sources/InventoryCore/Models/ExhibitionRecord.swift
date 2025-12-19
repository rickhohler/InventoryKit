//
//  ExhibitionRecord.swift
//  InventoryKit
//
//  Exhibition record for tracking when/where Products were displayed
//

import Foundation

/// Exhibition record for tracking when/where Products were displayed.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct ExhibitionRecord: Sendable, Codable, Hashable {
    public let exhibitionName: String
    public let startDate: Date
    public let endDate: Date?
    public let location: String?
    
    public init(
        exhibitionName: String,
        startDate: Date,
        endDate: Date? = nil,
        location: String? = nil
    ) {
        self.exhibitionName = exhibitionName
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
    }
}

