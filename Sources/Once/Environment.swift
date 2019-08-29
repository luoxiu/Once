import Foundation

enum Environment { }

extension Environment {

    private enum Key {

        static let version = "com.v2ambition.once.version"

        static let versionUpdateDate = "com.v2ambition.once.versionUpdateDate"

        static let context = "com.v2ambition.once.context"
    }

    static let userDefaults = UserDefaults.standard

    static var sessionStartDate = Date()

    static var versionUpdateDate: Date?
}

extension Environment {

    private static var isInitialized = Atom(value: false)

    static func initialize() {
        isInitialized.once_run {
            Environment.sessionStartDate = Date()
            
            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return
            }
            
            if Environment.userDefaults.string(forKey: Environment.Key.version) == currentVersion {
                versionUpdateDate = userDefaults.object(forKey: Key.versionUpdateDate) as? Date
            } else {
                userDefaults.set(currentVersion, forKey: Key.version)
                userDefaults.set(Date(), forKey: Key.versionUpdateDate)
                versionUpdateDate = Date()
            }
        }
    }

    static func ensureIsInitialized() {
        Environment.initialize()
    }
}

// MARK: Context
extension Environment {

    private static func contextKey(for label: Label) -> String {
        return Key.context + "." + label.rawValue
    }

    static func context(for label: Label) -> [String: Any] {
        if let context = userDefaults.object(forKey: contextKey(for: label)) as? [String: Any] {
            return context
        }

        let context: [String: Any] = [:]
        setContext(context, for: label)
        return context
    }

    static func setContext(_ context: [String: Any], for label: Label) {
        userDefaults.set(context, forKey: contextKey(for: label))
    }
}
