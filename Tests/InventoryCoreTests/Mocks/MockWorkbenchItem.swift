import Foundation
import InventoryCore

public struct MockWorkbenchItem: WorkbenchItem {
    public let id: UUID
    public let sourceAssetID: UUID
    public let workingFileURL: URL
    public var state: WorkbenchState
    
    public var contents: any InventoryCompoundBase
    public var isModified: Bool
    
    public init(
        id: UUID = UUID(),
        sourceAssetID: UUID,
        workingFileURL: URL,
        state: WorkbenchState = .ready,
        contents: any InventoryCompoundBase,
        isModified: Bool = false
    ) {
        self.id = id
        self.sourceAssetID = sourceAssetID
        self.workingFileURL = workingFileURL
        self.state = state
        self.contents = contents
        self.isModified = isModified
    }
}
