import Foundation

public class Sealer {

    private let task: Task

    fileprivate init(_ task: Task) {
        self.task = task
    }

    public func seal() {
        task.lock()
        defer { task.unlock() }

        task.timestamps.append(Date())
    }
}

extension Task {

    var sealer: Sealer {
        return Sealer(self)
    }
}
