import Foundation

public func `do`(_ label: Label, scope: Scope = .install, block: (Sealer) -> Void) {
    Env.ensureInit()

    let task = Task.task(for: label)

    task.lock()
    defer { task.unlock() }

    task.scope = scope

    if task.canDo {
        block(task.sealer)
    }
}

public func `if`(_ label: Label, scope: Scope = .install, times: CountChecker, do block: (Sealer) -> Void) {
    Env.ensureInit()

    let task = Task.task(for: label)

    task.lock()
    defer { task.unlock() }

    task.scope = scope

    if times.check(task.filteredTimestamps.count) {
        block(task.sealer)
    }
}

public func unless(_ label: Label, scope: Scope = .install, times: CountChecker, do block: (Sealer) -> Void) {
    Env.ensureInit()

    let task = Task.task(for: label)

    task.lock()
    defer { task.unlock() }

    task.scope = scope

    if !times.check(task.filteredTimestamps.count) {
        block(task.sealer)
    }
}

public func clear(_ label: Label) {
    let task = Task.task(for: label)

    task.lock()
    defer { task.unlock() }

    task.timestamps = []
}

public func lastDone(of label: Label) -> Date? {
    let task = Task.task(for: label)

    task.lock()
    defer { task.unlock() }

    return task.timestamps.last
}
