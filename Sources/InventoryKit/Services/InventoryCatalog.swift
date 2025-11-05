import Foundation

/// Facade + repository actor that indexes large inventories for fast lookup, relationship checks, and identifier resolution.
public actor InventoryCatalog {
    private var schemaVersion: InventorySchemaVersion
    private var info: InventoryDocumentInfo?
    private var metadata: [String: String]

    private var assetsByID: [UUID: InventoryAsset]
    private var tagIndex: [String: Set<UUID>]
    private var identifierIndex: [IdentifierKey: UUID]
    private var relationshipTypesByID: [String: InventoryRelationshipType]

    public init(document: InventoryDocument = InventoryDocument(schemaVersion: .current, assets: [])) {
        self.schemaVersion = document.schemaVersion
        self.info = document.info
        self.metadata = document.metadata
        let initial = InventoryCatalog.buildInitialState(from: document)
        self.assetsByID = initial.assetsByID
        self.tagIndex = initial.tagIndex
        self.identifierIndex = initial.identifierIndex
        self.relationshipTypesByID = initial.relationshipTypesByID
    }

    // MARK: - CRUD

    @discardableResult
    public func upsert(_ asset: InventoryAsset) -> InventoryAsset {
        if let existing = assetsByID[asset.id] {
            deindex(asset: existing)
        }
        assetsByID[asset.id] = asset
        index(asset: asset)
        return asset
    }

    @discardableResult
    public func deleteAsset(id: UUID) -> InventoryAsset? {
        guard let removed = assetsByID.removeValue(forKey: id) else {
            return nil
        }
        deindex(asset: removed)
        return removed
    }

    public func replaceDocument(_ document: InventoryDocument) {
        schemaVersion = document.schemaVersion
        info = document.info
        metadata = document.metadata
        let initial = InventoryCatalog.buildInitialState(from: document)
        assetsByID = initial.assetsByID
        tagIndex = initial.tagIndex
        identifierIndex = initial.identifierIndex
        relationshipTypesByID = initial.relationshipTypesByID
    }

    // MARK: - Queries

    public var totalAssetCount: Int {
        assetsByID.count
    }

    public func allAssets(sorted: Bool = true) -> [InventoryAsset] {
        let values = Array(assetsByID.values)
        return sorted ? values.sorted(by: { $0.id.uuidString < $1.id.uuidString }) : values
    }

    public func paginatedAssets(page: InventoryPageRequest) -> InventoryPage<InventoryAsset> {
        let sortedAssets = allAssets()
        return paginate(items: sortedAssets, request: page)
    }

    public func paginatedAssets(taggedWith tags: Set<String>, page: InventoryPageRequest) -> InventoryPage<InventoryAsset> {
        let filtered = assets(taggedWith: tags)
        return paginate(items: filtered, request: page)
    }

    public func paginatedAssets(inLifecycle stage: InventoryLifecycleStage, page: InventoryPageRequest) -> InventoryPage<InventoryAsset> {
        let filtered = assets(inLifecycle: stage)
        return paginate(items: filtered, request: page)
    }

    public func asset(withID id: UUID) -> InventoryAsset? {
        assetsByID[id]
    }

    public func asset(identifierType: InventoryIdentifierType, value: String) -> InventoryAsset? {
        let key = IdentifierKey(type: identifierType, value: InventoryCatalog.normalizedIdentifierValue(value))
        guard let id = identifierIndex[key] else { return nil }
        return assetsByID[id]
    }

    public func assets(taggedWith tags: Set<String>) -> [InventoryAsset] {
        guard !tags.isEmpty else { return allAssets() }
        var intersection: Set<UUID>?
        for tag in tags {
            guard let ids = tagIndex[tag] else { return [] }
            if let existing = intersection {
                intersection = existing.intersection(ids)
            } else {
                intersection = ids
            }
            if intersection?.isEmpty == true {
                return []
            }
        }

        guard let matches = intersection else { return [] }
        return matches.compactMap { assetsByID[$0] }.sorted(by: { $0.id.uuidString < $1.id.uuidString })
    }

    public func assets(sourceOrigin origin: String) -> [InventoryAsset] {
        assetsByID.values
            .filter { $0.source?.origin == origin }
            .sorted(by: { $0.id.uuidString < $1.id.uuidString })
    }

    public func assets(inLifecycle stage: InventoryLifecycleStage) -> [InventoryAsset] {
        assetsByID.values
            .filter { $0.lifecycle?.stage == stage }
            .sorted(by: { $0.id.uuidString < $1.id.uuidString })
    }

    public func search(where predicate: @Sendable (InventoryAsset) -> Bool) -> [InventoryAsset] {
        assetsByID.values.filter(predicate)
    }

    public func embeddedComponents(for assetID: UUID) -> [InventoryAsset] {
        guard let asset = assetsByID[assetID] else { return [] }
        return asset.components.compactMap { link in
            assetsByID[link.assetID]
        }
    }

    public func relatedAssets(for assetID: UUID, typeID: String? = nil) -> [InventoryAsset] {
        guard let asset = assetsByID[assetID] else { return [] }
        let links = asset.linkedAssets.filter { link in
            guard let typeID else { return true }
            return link.typeID == typeID
        }
        return links.compactMap { assetsByID[$0.assetID] }
    }

    public func relationshipType(withID id: String) -> InventoryRelationshipType? {
        relationshipTypesByID[id]
    }

    public func relationshipTypes() -> [InventoryRelationshipType] {
        relationshipTypesByID.values.sorted(by: { $0.id < $1.id })
    }

    public func evaluateRelationships(forAssetID assetID: UUID) -> [InventoryRelationshipEvaluation] {
        guard let asset = assetsByID[assetID] else { return [] }
        var results: [InventoryRelationshipEvaluation] = []

        for requirement in asset.relationshipRequirements {
            let linked = relatedAssets(for: assetID, typeID: requirement.typeID)
            let matches = requirement.compatibleAssetIDs.isEmpty
                ? linked
                : linked.filter { requirement.compatibleAssetIDs.contains($0.id) }

            let tagsSatisfied = requirement.requiredTags.isEmpty ? true : matches.contains { related in
                Set(requirement.requiredTags).isSubset(of: Set(related.tags))
            }

            if matches.isEmpty {
                let status: InventoryRelationshipComplianceStatus = requirement.required ? .missingRequired : .missingOptional
                let relationshipName = relationshipTypesByID[requirement.typeID]?.displayName ?? requirement.name
                let message = status == .missingRequired
                    ? "Missing required related asset \(relationshipName)."
                    : "Optional related asset \(relationshipName) not linked."
                results.append(
                    InventoryRelationshipEvaluation(
                        requirement: requirement,
                        status: status,
                        message: message
                    )
                )
                continue
            }

            if !tagsSatisfied {
                results.append(
                    InventoryRelationshipEvaluation(
                        requirement: requirement,
                        status: .nonCompliantTags,
                        message: "Linked assets for \(requirement.name) lack required tags \(requirement.requiredTags)."
                    )
                )
                continue
            }

            let names = matches.map(\.name).joined(separator: ", ")
            results.append(
                InventoryRelationshipEvaluation(
                    requirement: requirement,
                    status: .satisfied,
                    message: "Requirement \(requirement.name) satisfied by \(names)."
                )
            )
        }

        return results
    }

    // MARK: - Document Interaction

    public func snapshotDocument(sortedByID: Bool = true) -> InventoryDocument {
        let assets = allAssets(sorted: sortedByID)
        return InventoryDocument(
            schemaVersion: schemaVersion,
            info: info,
            metadata: metadata,
            relationshipTypes: relationshipTypes(),
            assets: assets
        )
    }

    // MARK: - Indexing

    private func index(asset: InventoryAsset) {
        asset.tags.forEach { tag in
            tagIndex[tag, default: []].insert(asset.id)
        }
        asset.identifiers.forEach { identifier in
            let key = IdentifierKey(type: identifier.type, value: InventoryCatalog.normalizedIdentifierValue(identifier.value))
            identifierIndex[key] = asset.id
        }
    }

    private func deindex(asset: InventoryAsset) {
        asset.tags.forEach { tag in
            guard var set = tagIndex[tag] else { return }
            set.remove(asset.id)
            if set.isEmpty {
                tagIndex.removeValue(forKey: tag)
            } else {
                tagIndex[tag] = set
            }
        }
        asset.identifiers.forEach { identifier in
            let key = IdentifierKey(type: identifier.type, value: InventoryCatalog.normalizedIdentifierValue(identifier.value))
            if identifierIndex[key] == asset.id {
                identifierIndex.removeValue(forKey: key)
            }
        }
    }

    private static func normalizedIdentifierValue(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

private extension InventoryCatalog {
    struct InitialState {
        var assetsByID: [UUID: InventoryAsset]
        var tagIndex: [String: Set<UUID>]
        var identifierIndex: [IdentifierKey: UUID]
        var relationshipTypesByID: [String: InventoryRelationshipType]
    }

    static func buildInitialState(from document: InventoryDocument) -> InitialState {
        var assets: [UUID: InventoryAsset] = [:]
        var tags: [String: Set<UUID>] = [:]
        var identifiers: [IdentifierKey: UUID] = [:]

        document.assets.forEach { asset in
            assets[asset.id] = asset
            asset.tags.forEach { tag in
                tags[tag, default: []].insert(asset.id)
            }
            asset.identifiers.forEach { identifier in
                let key = IdentifierKey(type: identifier.type, value: InventoryCatalog.normalizedIdentifierValue(identifier.value))
                identifiers[key] = asset.id
            }
        }

        return InitialState(
            assetsByID: assets,
            tagIndex: tags,
            identifierIndex: identifiers,
            relationshipTypesByID: Dictionary(uniqueKeysWithValues: document.relationshipTypes.map { ($0.id, $0) })
        )
    }
}

private struct IdentifierKey: Hashable {
    let type: InventoryIdentifierType
    let value: String
}
