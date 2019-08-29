import Foundation

#if canImport(os)
private final class OSUnfairLock: NSLocking {
    
    private var s = os_unfair_lock_s()
    
    func lock() {
        os_unfair_lock_lock(&s)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&s)
    }
}
#endif

final class Lock {
    
    let locking: NSLocking
    
    init() {
        #if canImport(os)
        locking = OSUnfairLock()
        #else
        locking = NSLock()
        #endif
    }
    
    func lock() {
        locking.lock()
    }
    
    func unlock() {
        locking.unlock()
    }
    
    func withLock<T>(_ body: @escaping () -> T) -> T {
        lock()
        defer { unlock() }
        return body()
    }
}
