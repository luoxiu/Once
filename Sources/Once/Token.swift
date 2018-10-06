import Foundation

public final class Token {

    private let lock = NSLock()
    private var isSealed = false

    @inline(__always)
    func run(_ block: () -> Void) {
        if isSealed {
            return
        }

        lock.lock()
        defer { lock.unlock() }

        if isSealed {
            return
        }

        block()
        isSealed = true
    }
}

private let lock = NSLock()
private var cache: [String: Token] = [:]

public func makeToken(dso: UnsafeRawPointer = #dsohandle,
                      file: String = #file,
                      line: Int = #line,
                      column: Int = #column,
                      function: String = #function) -> Token {

    let key = "\(Int(bitPattern: dso))-\(file)-\(line)-\(column)-\(function)"
    if let token = cache[key] {
        return token
    }

    lock.lock()
    defer { lock.unlock() }

    if let token = cache[key] {
        return token
    }

    let token = Token()
    cache[key] = token
    return token
}
