import Foundation

enum Environment { }

extension Environment {

    private enum Key {
        static let version = "com.v2ambition.once.version"
        static let versionUpdateDate = "com.v2ambition.once.versionUpdateDate"
    }

    static var sessionStartDate = Date()
    static var versionUpdateDate: Date?

    private static let isInitialized = Atom(value: false)

    static func initialize() {
        isInitialized.once_run {
            Environment.sessionStartDate = Date()
            
            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return
            }
            
            if UserDefaults.standard.string(forKey: Environment.Key.version) == currentVersion {
                versionUpdateDate = UserDefaults.standard.object(forKey: Key.versionUpdateDate) as? Date
            } else {
                UserDefaults.standard.set(currentVersion, forKey: Key.version)
                UserDefaults.standard.set(Date(), forKey: Key.versionUpdateDate)
                versionUpdateDate = Date()
            }
        }
    }

    static func ensureInitialized() {
        Environment.initialize()
    }
}
