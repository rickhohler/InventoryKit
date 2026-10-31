import Foundation
import InventoryTypes
import InventoryCore

/// Concrete implementation of the Relationship Service.
public actor InventoryRelationshipService: RelationshipService {
    
    private let storage: any StorageProvider
    
    public init(storage: any StorageProvider) {
        self.storage = storage
    }
    
    public func evaluateCompliance(for asset: any InventoryAsset) async throws -> [any InventoryRelationshipEvaluation] {
        var results: [RelationshipEvaluation] = []
        
        for req in asset.relationshipRequirements {
            // 1. Find links that claim to satisfy this requirement type
            let links = asset.linkedAssets.filter { $0.typeID == req.typeID }
            
            if links.isEmpty {
                let status: InventoryRelationshipComplianceStatus = req.required ? .missingRequired : .missingOptional
                results.append(RelationshipEvaluation(
                    requirement: req,
                    status: status,
                    message: req.required ? "Required relationship '\(req.name)' is missing." : "Optional relationship '\(req.name)' not linked."
                ))
                continue
            }
            
            // 2. Verify compliance of the linked assets
            var isSatisfied = false
            var failureReasons: [String] = []
            var foundTargets = 0
            var idMismatch = false
            
            for link in links {
                // Fetch the actual target asset
                let targetAsset = try await storage.performTransaction { tx in
                    try await tx.retrieveAsset(id: link.assetID)
                }
                
                guard let target = targetAsset else {
                    failureReasons.append("Linked asset \(link.assetID) not found in storage.")
                    continue
                }
                foundTargets += 1
                
                // Check ID Constraints
                if !req.compatibleAssetIDs.isEmpty {
                    if req.compatibleAssetIDs.contains(target.id) {
                        isSatisfied = true
                        break
                    }
                    // Only an ID list: the target isn't one of the allowed assets.
                    if req.requiredTags.isEmpty { idMismatch = true }
                }
                
                // Check TagType Constraints
                if !req.requiredTags.isEmpty {
                    let targetTags = Set(target.tags)
                    let required = Set(req.requiredTags)
                    if required.isSubset(of: targetTags) {
                        isSatisfied = true
                        break
                    }
                }
                
                // If no specific constraints are defined, the link itself satisfying the typeID is sufficient
                if req.compatibleAssetIDs.isEmpty && req.requiredTags.isEmpty {
                    isSatisfied = true
                    break
                }
                
                if !isSatisfied {
                     failureReasons.append("Asset '\(target.name)' does not meet tag/ID constraints.")
                }
            }
            
            if isSatisfied {
                results.append(RelationshipEvaluation(requirement: req, status: .satisfied, message: "Relationship satisfied."))
            } else if foundTargets == 0 {
                // Every linked asset is gone: the relationship is effectively missing.
                results.append(RelationshipEvaluation(
                    requirement: req,
                    status: req.required ? .missingRequired : .missingOptional,
                    message: "Linked assets for '\(req.name)' not found: \(failureReasons.joined(separator: "; "))"
                ))
            } else if idMismatch {
                results.append(RelationshipEvaluation(
                    requirement: req,
                    status: .incompatible,
                    message: "Linked assets for '\(req.name)' are not among its compatible assets: \(failureReasons.joined(separator: "; "))"
                ))
            } else {
                results.append(RelationshipEvaluation(
                    requirement: req,
                    status: .nonCompliantTags,
                    message: "Linked assets exist for '\(req.name)' but do not match criteria: \(failureReasons.joined(separator: "; "))"
                ))
            }
        }
        
        return results
    }
    
    public func link(sourceID: UUID, targetID: UUID, typeID: String, note: String?) async throws {
        let storage = self.storage
        try await storage.performTransaction { tx in
            // 1. Fetch Source
            guard var source = try await tx.retrieveAsset(id: sourceID) else {
                throw RelationshipError.assetNotFound(sourceID)
            }
            
            // 2. Fetch Target to ensure it exists
            guard let _ = try await tx.retrieveAsset(id: targetID) else {
                throw RelationshipError.assetNotFound(targetID)
            }
            
            // 3. Create Link
            if let index = source.linkedAssets.firstIndex(where: { $0.assetID == targetID }) {
                source.linkedAssets[index] = LinkedAsset(assetID: targetID, typeID: typeID, note: note)
            } else {
                let link = LinkedAsset(assetID: targetID, typeID: typeID, note: note)
                source.linkedAssets.append(link)
            }
            
            // 4. Persist: assets may be value types, so the changed copy is written back.
            try await storage.assetRepository.update(source)
            try await tx.save()
        }
    }
    
    public func unlink(sourceID: UUID, targetID: UUID) async throws {
        let storage = self.storage
        try await storage.performTransaction { tx in
            guard var source = try await tx.retrieveAsset(id: sourceID) else {
                 throw RelationshipError.assetNotFound(sourceID)
            }
            
            source.linkedAssets.removeAll { $0.assetID == targetID }
            try await storage.assetRepository.update(source)
            try await tx.save()
        }
    }
    
    public func findCandidates(for requirement: any InventoryRelationshipRequirement) async throws -> [any InventoryAsset] {
        return try await storage.performTransaction { tx in
            var candidates: [any InventoryAsset] = []
            
            // 1. If explicit IDs
            if !requirement.compatibleAssetIDs.isEmpty {
                 for id in requirement.compatibleAssetIDs {
                     if let a = try await tx.retrieveAsset(id: id) { candidates.append(a) }
                 }
                 return candidates
            }
            
            // 2. If filtering by Tags (Naive Scan)
            let all = try await tx.fetchAssets(matching: .all())
            
            let requiredTags = Set(requirement.requiredTags)
            
            candidates = all.filter { asset in
                if !requiredTags.isEmpty {
                     let assetTags = Set(asset.tags)
                     if !requiredTags.isSubset(of: assetTags) {
                         return false
                     }
                }
                return true
            }
            
            return candidates
        }
    }
}

enum RelationshipError: Error {
    case assetNotFound(UUID)
    case typeMismatch
}
