InventoryKit
============

Mission
-------
InventoryKit is a Swift Package Manager (SPM) library that manages asset inventories backed by semantic-versioned schemas. The library must remain storage-agnostic, format-flexible, and production-ready for public consumption on GitHub.

Use Cases
---------
* **Vintage Computers & Parts (1980s)**: Track rare systems, boards, and chips, including embedded components (CPU, RAM, storage) plus historically accurate provenance and maintenance data. Capture peripherals (keyboard, mouse, CRT monitors) with compatibility requirements.
* **Automotive Parts Inventory**: Manage thousands of SKUs, MRO details, and lifecycle events for mechanical/electrical parts. Support assemblies where parts are nested within larger systems and require compatibility/compliance checks.

Completed Foundation
--------------------
* SPM package initialized with cross-platform (macOS + Linux) support and Yams dependency.
* Core domain models + helpers: schema versions, assets, lifecycle/health/MRO metadata, relationship definitions, pagination primitives, transformers.
* YAML/JSON serialization with schema enforcement and semantic version compatibility checks.
* Storage abstractions via `InventoryStorageProvider`, thread-safe text-file provider, and high-volume `InventoryCatalog` with pagination + relationship evaluation.
* `InventoryService` bootstrap API with logging + configuration to give consumers a single entry point.
* Unit tests covering schema parsing, serialization, catalog queries, pagination, storage providers, and service lifecycle.
* GitHub Actions workflow running `swift test --parallel` across macOS and Ubuntu.

Next Iterations
---------------
1. **Domain Modeling**
   * Flesh out richer asset attributes:
     - Asset Identifier (unique, stable).
     - Asset Source / provenance (who supplied it, from where, and optional contacts).
     - Asset Lifecycle metadata: acquisition/disposal dates, provenance entries (timestamp, actor, note).
     - MRO inventory details (stock levels, reorder thresholds, supplier metadata).
     - Asset Health profile (physical condition, operational readiness, calibration/diagnostic notes).
     - Relationships: embedded components (parent/child assets) and required peripherals with compatibility/compliance metadata.
   * Consider `InventorySource`, `LifecycleEvent`, `MROStock`, and relationship helper types to keep models modular.

2. **Storage and Transformation Abstractions**
   * Expand beyond the provided text-file provider with CloudKit, database, or network providers that conform to `InventoryStorageProvider`.
   * Allow providers to expose custom transformers or binary formats when needed.
   * Document patterns for secure persistence (encryption, auth) when building custom providers.

3. **Schema + Format Support**
   * Author explicit JSON/YAML schemas and bundle them for validation.
   * Ensure serializer outputs conform to schemas; add schema validation tests.
   * Consider version negotiation helpers when reading legacy data.

4. **CRUD + Query API**
   * Build read/search/update/delete APIs around in-memory documents.
   * Support filtered queries (e.g., by tags, source, lifecycle stage) and batched updates.
   * Evaluate concurrency strategy and sendable guarantees for async contexts.

5. **Testing + Tooling**
   * Expand unit tests to cover transformers, CRUD flows, schema mismatches, and lifecycle logic.
   * Add sample inventory fixtures for regression coverage.
   * Consider DocC or README samples demonstrating YAML/JSON structures.

6. **Operational Readiness**
   * Document contribution/development setup.
   * Follow semantic versioning for the library alongside documented schema version updates.
   * Audit for Swift API design guidelines, concurrency safety, and public API documentation comments.

Additions, corrections, or new recommendations are welcome. Update the plan as architecture decisions evolve.
