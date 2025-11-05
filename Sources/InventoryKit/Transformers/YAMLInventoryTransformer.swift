import Foundation

public struct YAMLInventoryTransformer: InventoryDataTransformer {
    private let codec: InventoryCodec

    public init(codec: InventoryCodec = InventoryCodec()) {
        self.codec = codec
    }

    public var format: InventoryDataFormat { .yaml }

    public func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> InventoryDocument {
        try codec.decode(from: data, validatingAgainst: version)
    }

    public func encode(_ document: InventoryDocument) throws -> Data {
        let string = try codec.encode(document)
        return Data(string.utf8)
    }
}
