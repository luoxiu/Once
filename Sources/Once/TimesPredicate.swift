public struct TimesPredicate {
    
    private let contains: (Int) -> Bool

    public static func equalTo(_ n: Int) -> TimesPredicate {
        return TimesPredicate { $0 == n }
    }
    
    public static func lessThan(_ n: Int) -> TimesPredicate {
        return TimesPredicate { $0 < n }
    }
    
    public static func moreThan(_ n: Int) -> TimesPredicate {
        return TimesPredicate { $0 > n }
    }
    
    public static func moreThanOrEqualTo(_ n: Int) -> TimesPredicate {
        return TimesPredicate { $0 > n || $0 == n }
    }
    
    public static func lessThanOrEqualTo(_ n: Int) -> TimesPredicate {
        return TimesPredicate { $0 < n || $0 == n }
    }
    
    public func evaluate(_ times: Int) -> Bool {
        return contains(times)
    }
}
