# InventoryKit Services

InventoryKit provides a suite of stateless services for processing inventory data. These services are designed to be used independently or chained together via `AsyncDataPipeline`.

## Service Index

### 1. FormattingService
**Purpose**: Data hygiene and normalization.
- **Strategies**:
  - `NameCorrectionStrategy`: Fixes common typos (e.g., "broderbund" -> "Brøderbund").
  - `BasicCleanupStrategy`: Trims whitespace.
- **Source**: `InventoryCore/Services/Formatting/FormattingService.swift`
- **Usage**:
  ```swift
  let service = FormattingService(context: context)
  service.formatContact(&contact)
  ```

### 2. SuggestionService (Enrichment)
**Purpose**: Data enrichment via suggestions and auto-completion.
- **Strategies**:
  - `ReferenceManufacturerLookupStrategy`: Suggests manufacturers from a reference database.
- **Source**: `InventoryCore/Services/Suggestions/SuggestionService.swift`
- **Usage**:
  ```swift
  let service = SuggestionService(context: context)
  await service.enrichContact(&contact)
  ```

### 3. InventoryValidationService
**Purpose**: Validates entities against business rules.
- **Strategies**:
  - `InventoryAppLogicValidators`: Collection of common validators (URL, Positive Number, Date Range).
- **Source**: `InventoryCore/Services/Validation/InventoryValidationService.swift`
- **Usage**:
  ```swift
  let service = InventoryValidationService(context: context)
  let result = service.validate(requirements)
  ```

### 4. InventoryIDGenerator
**Purpose**: Generates deterministic, namespace-based UUIDv5s for Reference Data.
- **Source**: `InventoryCore/Services/Identification/InventoryIDGenerator.swift`
- **Usage**:
  ```swift
  let id = InventoryIDGenerator.generate(for: .manufacturer, name: "Atari")
  ```

### 5. InventoryImportService
**Purpose**: High-level orchestration of file ingestion.
**Source**: `InventoryKit/Services/Import/InventoryImportService.swift`
**Usage**:
  ```swift
  let service = InventoryImportService(storage: storage)
  let candidates = try await service.scan(urls: [fileURL])
  let asset = try await service.import(candidate: candidate)
  ```

### 6. InventoryRelationshipService
**Purpose**: Manages asset linking and compliance evaluation.
**Source**: `InventoryKit/Services/Relationships/InventoryRelationshipService.swift`
**Usage**:
  ```swift
  let service = InventoryRelationshipService(storage: storage)
  try await service.link(sourceID: id1, targetID: id2, typeID: "rel.display")
  let compliance = try await service.evaluateCompliance(for: asset)
  ```

## Pipelines

Services can be orchestrated using `InventoryPipelineStages`:

- **FormattingStage**: Wraps `FormattingService`.
- **EnrichmentStage**: Wraps `SuggestionService`.
- **ValidationStage**: Wraps `InventoryValidationService`.

```swift
let pipeline = AsyncDataPipeline<MyContact, MyContact> { $0 }
    .appending(FormattingStage(service: formattingService))
    .appending(EnrichmentStage(service: suggestionService))
```
