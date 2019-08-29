import Foundation

final class Atom<Value> {
    
    private let lock = Lock()
    private var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    func get() -> Value {
        return self.lock.withLock {
            self.value
        }
    }
    
    func set(_ new: Value) {
        self.lock.withLock {
            self.value = new
        }
    }
    
    func withLock<Result>(_ body: (Value) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }
        return try body(value)
    }
    
    func withLockMutating<Result>(_ body: (inout Value) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }
        return try body(&value)
    }
    
    func exchange(with new: Value) -> Value {
        return self.withLockMutating {
            let old = $0
            $0 = new
            return old
        }
    }
}

// MARK: Bool + Once

extension Atom where Value == Bool {

    func once_run(_ task: () -> Void) {
        if value { return }
        
        self.withLockMutating {
            if $0 { return }
            task()
            $0 = true
        }
    }
}

// MARK: Dictionary + Once

protocol DictionaryProtocol {
    associatedtype K: Hashable
    associatedtype V
    
    var dict: Dictionary<K, V> {
        get set
    }
}

extension Dictionary: DictionaryProtocol {
    
    var dict: Dictionary {
        get { return self }
        set { self = newValue }
    }
}

extension Atom where Value: DictionaryProtocol {
    
    func once_get(_ key: Value.K, _ make: @autoclosure () -> Value.V) -> Value.V {
        if let v = value.dict[key] {
            return v
        }
        
        return withLockMutating {
            if let v = $0.dict[key] { return v }
            let v = make()
            $0.dict[key] = v
            return v
        }
    }
}
