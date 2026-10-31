import Foundation
import InventoryCore
import InventoryTypes

/// In-memory repositories that record what services write, so tests can check that changes to
/// value-type entities are persisted through `save` / `update`.
final class RecordingAssetRepository: AssetRepository, @unchecked Sendable {
    typealias Entity = any InventoryAsset

    private let lock = NSLock()
    private var _stored: [UUID: any InventoryAsset] = [:]
    private var _saved: [UUID] = []
    private var _updated: [UUID] = []

    init(_ assets: [any InventoryAsset] = []) {
        for asset in assets { _stored[asset.id] = asset }
    }

    var stored: [UUID: any InventoryAsset] { lock.withLock { _stored } }
    var savedIDs: [UUID] { lock.withLock { _saved } }
    var updatedIDs: [UUID] { lock.withLock { _updated } }

    func put(_ asset: any InventoryAsset) { lock.withLock { _stored[asset.id] = asset } }

    func createAsset(id: UUID, name: String, provenance: String?, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
        fatalError("Not used")
    }
    func create() async throws -> Entity { fatalError("Not used") }
    func save(_ entity: Entity) async throws { lock.withLock { _saved.append(entity.id); _stored[entity.id] = entity } }
    func update(_ entity: Entity) async throws { lock.withLock { _updated.append(entity.id); _stored[entity.id] = entity } }
    func delete(id: UUID) async throws { lock.withLock { _stored[id] = nil } }
    func fetch(matching query: StorageQuery) async throws -> [Entity] { lock.withLock { Array(_stored.values) } }
    func retrieve(id: UUID) async throws -> Entity? { lock.withLock { _stored[id] } }
}

/// Records updated reference products.
final class RecordingReferenceProductRepository: ReferenceProductRepository, @unchecked Sendable {
    typealias Entity = any ReferenceProduct
    private let lock = NSLock()
    private var _updated: [any ReferenceProduct] = []
    var updated: [any ReferenceProduct] { lock.withLock { _updated } }

    func create() async throws -> Entity { fatalError("Not used") }
    func save(_ entity: Entity) async throws {}
    func update(_ entity: Entity) async throws { lock.withLock { _updated.append(entity) } }
    func delete(id: UUID) async throws {}
    func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    func retrieve(id: UUID) async throws -> Entity? { nil }
}

/// Records updated reference manufacturers.
final class RecordingReferenceManufacturerRepository: ReferenceManufacturerRepository, @unchecked Sendable {
    typealias Entity = any ReferenceManufacturer
    private let lock = NSLock()
    private var _updated: [any ReferenceManufacturer] = []
    var updated: [any ReferenceManufacturer] { lock.withLock { _updated } }

    func create() async throws -> Entity { fatalError("Not used") }
    func save(_ entity: Entity) async throws {}
    func update(_ entity: Entity) async throws { lock.withLock { _updated.append(entity) } }
    func delete(id: UUID) async throws {}
    func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    func retrieve(id: UUID) async throws -> Entity? { nil }
}

/// An asset repository over a test's own asset table: `update` and `save` write through
/// `store`, and are counted.
final class ClosureAssetRepository: AssetRepository, @unchecked Sendable {
    typealias Entity = any InventoryAsset

    private let lookup: @Sendable (UUID) -> (any InventoryAsset)?
    private let store: @Sendable (any InventoryAsset) -> Void
    private let lock = NSLock()
    private var _writes = 0
    var writes: Int { lock.withLock { _writes } }

    init(lookup: @escaping @Sendable (UUID) -> (any InventoryAsset)?, store: @escaping @Sendable (any InventoryAsset) -> Void) {
        self.lookup = lookup
        self.store = store
    }

    func createAsset(id: UUID, name: String, provenance: String?, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
        fatalError("Not used")
    }
    func create() async throws -> Entity { fatalError("Not used") }
    func save(_ entity: Entity) async throws { lock.withLock { _writes += 1 }; store(entity) }
    func update(_ entity: Entity) async throws { lock.withLock { _writes += 1 }; store(entity) }
    func delete(id: UUID) async throws {}
    func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    func retrieve(id: UUID) async throws -> Entity? { lookup(id) }
}
