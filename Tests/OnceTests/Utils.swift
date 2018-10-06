import Foundation

func asyncAndWait(concurrent: Int, block: @escaping () -> Void) {

    let g = DispatchGroup()
    for _ in 0..<concurrent {
        DispatchQueue.global().async(group: g) {
            block()
        }
    }
    g.wait()
}

extension Date {

    var dateComponents: DateComponents {
        return Calendar(identifier: .gregorian).dateComponents(in: .current, from: self)
    }

    func adding(_ dateComponents: DateComponents) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: self)!
    }
}
