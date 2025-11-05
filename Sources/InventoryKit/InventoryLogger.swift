import Foundation

struct InventoryLogger: Sendable {
    private let level: InventoryLogLevel
    private let dateProvider: @Sendable () -> Date

    init(level: InventoryLogLevel, dateProvider: @escaping @Sendable () -> Date = Date.init) {
        self.level = level
        self.dateProvider = dateProvider
    }

    func log(_ level: InventoryLogLevel, _ message: @autoclosure () -> String) {
        guard self.level.allows(level) else { return }
        let timestamp = InventoryLogger.format(date: dateProvider())
        print("[InventoryKit][\(level.label)][\(timestamp)] \(message())")
    }

    func error(_ message: @autoclosure () -> String) { log(.error, message()) }
    func warn(_ message: @autoclosure () -> String) { log(.warning, message()) }
    func info(_ message: @autoclosure () -> String) { log(.info, message()) }
    func debug(_ message: @autoclosure () -> String) { log(.debug, message()) }
}

extension InventoryLogger {
    private static func format(date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
}
