public enum CountChecker {

    case lessThan(Int)
    case equalTo(Int)
    case greaterThan(Int)

    func check(_ times: Int) -> Bool {
        switch self {
        case .equalTo(let count):       return times == count
        case .greaterThan(let count):   return times > count
        case .lessThan(let count):      return times < count
        }
    }
}
