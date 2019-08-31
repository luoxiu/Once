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

final class DispatchSemaphoreLock: NSLocking {
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    func lock() {
        semaphore.wait()
    }
    
    func unlock() {
        semaphore.signal()
    }
}

final class Lock: NSLocking {
    
    private let locking: NSLocking
    
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
}

extension NSLocking {
    
    func withLock<T>(_ body: () -> T) -> T {
        lock()
        defer { unlock() }
        return body()
    }
}
