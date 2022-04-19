import Foundation
import os

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let appLogger = Logger(subsystem: OSLog.subsystem, category: "App")

    public static func debug(_ message: String) {
        appLogger.debug("📢 \(message)")
    }
}
