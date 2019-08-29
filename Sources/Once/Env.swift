import Foundation

enum Env { }

extension Env {

    private enum Key {

        static let version = "com.v2ambition.once.version"

        static let versionUpdateDate = "com.v2ambition.once.versionUpdateDate"

        static let context = "com.v2ambition.once.context"
    }

    static let db = UserDefaults.standard

    static var sessionStartDate = Date()

    static var versionUpdateDate: Date?
}

extension Env {

    private static var isInitialized = false
    private static let mutex = NSLock()

    static func initialize() {
        if isInitialized {
            return
        }

        mutex.lock()
        defer { mutex.unlock() }

        if isInitialized {
            return
        }

        Env.sessionStartDate = Date()

        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if Env.db.string(forKey: Env.Key.version) == currentVersion {
                versionUpdateDate = db.object(forKey: Key.versionUpdateDate) as? Date
            } else {
                db.set(currentVersion, forKey: Key.version)
                db.set(Date(), forKey: Key.versionUpdateDate)
                versionUpdateDate = Date()
            }
        }

        isInitialized = true
    }

    static func ensureInit() {
        Env.initialize()
    }
}

// MARK: Context
extension Env {

    private static func contextKey(for label: Label) -> String {
        return Key.context + "." + label.rawValue
    }

    static func context(for label: Label) -> [String: Any] {
        if let context = db.object(forKey: contextKey(for: label)) as? [String: Any] {
            return context
        }

        let context: [String: Any] = [:]
        setContext(context, for: label)
        return context
    }

    static func setContext(_ context: [String: Any], for label: Label) {
        db.set(context, forKey: contextKey(for: label))
    }
}
