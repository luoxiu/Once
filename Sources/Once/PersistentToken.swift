import Foundation

public final class PersistentToken {
    
    private enum Key {
        static let version = "com.v2ambition.once.version"
        static let versionUpdateDate = "com.v2ambition.once.versionUpdateDate"
        
        static let context = "com.v2ambition.once.context"
        static let timestamps = "timestamps"
    }
    
    private static let registry = Atom<[String: PersistentToken]>(value: [:])
    private static let isInitialized = Atom(value: false, lock: DispatchSemaphoreLock())
    
    private static var sessionStartDate = Date()
    private static var versionUpdateDate: Date?

    public let name: String
    
    private let lock = NSRecursiveLock()
    private let contextKey: String
    private var context: [String: Any]
    
    private init(_ name: String) {
        self.name = name
        self.contextKey = Key.context + "." + name
        self.context = UserDefaults.standard.object(forKey: self.contextKey) as? [String: Any] ?? [:]
    }
    
    public static func make(_ name: String) -> PersistentToken {
        return registry.once_get(name, PersistentToken(name))
    }
    
    private func flushContext() {
        UserDefaults.standard.set(context, forKey: contextKey)
    }

    static func initialize() {
        sessionStartDate = Date()
        
        let currentVersion = appVersion()
        if UserDefaults.standard.string(forKey: Key.version) == currentVersion {
            versionUpdateDate = UserDefaults.standard.object(forKey: Key.versionUpdateDate) as? Date
        } else {
            UserDefaults.standard.set(currentVersion, forKey: Key.version)
            UserDefaults.standard.set(Date(), forKey: Key.versionUpdateDate)
            versionUpdateDate = Date()
        }
    }
    
    private static func ensureInitialized() {
        isInitialized.once_run(initialize)
    }
    
    private var timestamps: [Date] {
        get {
            return context[Key.timestamps] as? [Date] ?? []
        }
        set {
            context[Key.timestamps] = newValue
        }
    }
}

extension PersistentToken {
    
    private func filteredTimestamps(in scope: Scope) -> [Date] {
        let timestamps = self.timestamps
        return timestamps.filter { date in
            switch scope {
            case .install:                  return true
            case .version:
                guard let versionUpdateDate = PersistentToken.versionUpdateDate else { return true }
                return date > versionUpdateDate
            case .session:                  return date > PersistentToken.sessionStartDate
            case .since(let since):         return date > since
            case .until(let until):         return date < until
            }
        }
    }
    
    public func hasBeenDone(in scope: Scope, _ timesPredicate: TimesPredicate) -> Bool {
        return timesPredicate.evaluate(filteredTimestamps(in: scope).count)
    }
}

extension PersistentToken {
 
    public func `do`(in scope: Scope, if timesPredicate: TimesPredicate, _ task: (PersistentToken) -> Void) {
        PersistentToken.ensureInitialized()
        lock.withLock {
            if hasBeenDone(in: scope, timesPredicate) {
                task(self)
            }
        }
    }
    
    public func `do`(in scope: Scope, if timesPredicate: TimesPredicate, _ task: () -> Void) {
        PersistentToken.ensureInitialized()
        lock.withLock {
            if hasBeenDone(in: scope, timesPredicate) {
                task()
                timestamps.append(Date())
            }
        }
        flushContext()
    }
    
    public func done() {
        lock.withLock {
            timestamps.append(Date())
        }
        flushContext()
    }
    
    public var lastDone: Date? {
        return lock.withLock {
            timestamps.last
        }
    }
    
    public func reset() {
        lock.withLock {
            self.context = [:]
        }
        UserDefaults.standard.set(nil, forKey: contextKey)
    }
    
    public static func resetAll() {
        for (_, token) in self.registry.get() {
            token.reset()
        }
    }
}

extension PersistentToken {
    
    private static func appVersion() -> String {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        else {
            return "0.0.0"
        }
        return "\(version) (\(build))"
    }
}
