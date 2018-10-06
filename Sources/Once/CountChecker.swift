public enum CountChecker {

    case equalTo(Int)
    case moreThan(Int)
    case lessThan(Int)

    func check(_ times: Int) -> Bool {
        switch self {
        case .equalTo(let count):       return times == count
        case .moreThan(let count):      return times > count
        case .lessThan(let count):      return times < count
        }
    }
}
