import Foundation

public final class Label {

    public let name: String
    private var scope: Scope = .install
    
    private enum Key {
        static let context = "com.v2ambition.once.context"
        static let timestamps = "timestamps"
    }

    private init(_ name: String) {
        self.name = name
    }
    
    private var contextKey: String {
        return Key.context + "." + name
    }
    
    private var context: [String: Any] {
        get {
            return UserDefaults.standard.object(forKey: contextKey) as? [String: Any] ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: contextKey)
        }
    }
    
    private var timestamps: [Date] {
        get {
            return context[Key.timestamps] as? [Date] ?? []
        }
        set {
            context[Key.timestamps] = newValue
        }
    }
    
    public func timestamp() {
        self.timestamps.append(Date())
    }
    
    var shouldDo: Bool {
        switch scope {
        case .install, .version, .session, .since, .every:
            return filteredTimestamps.isEmpty
        case .until(let until):
            return Date() > until || filteredTimestamps.isEmpty
        }
    }
    
    var filteredTimestamps: [Date] {
        return timestamps.filter { date in
            switch scope {
            case .install:                  return true
            case .version:
                return date >= (Environment.versionUpdateDate ?? Date.distantPast)
            case .session:                  return date >= Environment.sessionStartDate
            case .since(let since):         return date >= since
            case .until(let until):         return date <= until
            case .every(let period):
                return date == timestamps.last && date.adding(period) >= Date()
            }
        }
    }
}


extension Label {
    
    public typealias Done = () -> Void
    
    public func `do`(scope: Scope = .install, _ task: (Done) -> Void) {
        Environment.ensureInitialized()
        
        self.scope = scope
        if self.shouldDo {
            task {
                self.timestamps.append(Date())
            }
        }
    }
    
    public func `if`(scope: Scope = .install, countChecker: CountChecker, _ task: (Done) -> Void) {
        self.scope = scope
        
        if countChecker.check(self.filteredTimestamps.count) {
            task {
                self.timestamps.append(Date())
            }
        }
    }
    
    public func unless(scope: Scope = .install, countChecker: CountChecker, _ task: (Done) -> Void) {
        self.scope = scope
        
        if !countChecker.check(self.filteredTimestamps.count) {
            task {
                self.timestamps.append(Date())
            }
        }
    }
    
    public func reset() {
        self.timestamps = []
    }
}

extension Label {
    
    private static let registry = Atom<[String: Label]>(value: [:])
    
    static func of(_ name: String) -> Label {
        return registry.once_get(name, Label(name))
    }
}

extension Label: ExpressibleByStringLiteral {

    public convenience init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Label: Hashable {
    
    public static func == (a: Label, b: Label) -> Bool {
        return a.name == b.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
