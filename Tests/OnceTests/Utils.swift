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
