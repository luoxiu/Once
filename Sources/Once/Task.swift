import Foundation

final class Task {

    private let mutex = NSRecursiveLock()

    private let label: Label
    private lazy var context = Environment.context(for: label)

    var scope: Scope = .install

    private init(label: Label) {
        self.label = label
    }
}

extension Task {

    func lock() { mutex.lock() }

    func unlock() { mutex.unlock() }
}

extension Task {

    enum Key {
        static let timestamps = "timestamps"
    }

    var timestamps: [Date] {
        get {
            if let timestamps = context[Key.timestamps] as? [Date] {
                return timestamps
            }

            context[Key.timestamps] = []
            return []
        }
        set {
           context[Key.timestamps] = newValue
        }
    }

    var canDo: Bool {
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

extension Task {

    private static let registry = Atom<[Label: Task]>(value: [:])
    
    static func task(for label: Label) -> Task {
        return registry.once_get(label, Task(label: label))
    }
}
