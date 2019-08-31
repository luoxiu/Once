import Foundation

public struct Period {

    public let year: Int

    public let month: Int

    public let day: Int

    public let hour: Int

    public let minute: Int

    public let second: Int
    
    public init(
        year: Int = 0, month: Int = 0, day: Int = 0,
        hour: Int = 0, minute: Int = 0, second: Int = 0
    ) {
        self.year = max(year, 0)
        self.month = max(month, 0)
        self.day = max(day, 0)
        self.hour = max(hour, 0)
        self.minute = max(minute, 0)
        self.second = max(second, 0)
    }
}

extension Period: Equatable {

    public static func == (lhs: Period, rhs: Period) -> Bool {
        let now = Date()
        return now.adding(lhs) == now.adding(rhs)
    }
}

extension Period {

    public static func year(_ num: Int) -> Period {
        return Period(year: num)
    }

    public static func month(_ num: Int) -> Period {
        return Period(month: num)
    }

    public static func day(_ num: Int) -> Period {
        return Period(day: num)
    }

    public static func hour(_ num: Int) -> Period {
        return Period(hour: num)
    }

    public static func minute(_ num: Int) -> Period {
        return Period(minute: num)
    }

    public static func second(_ num: Int) -> Period {
        return Period(second: num)
    }

    public static func week(_ num: Int) -> Period {
        return Period(day: 7 * num)
    }
}

extension Date {

    public func adding(_ period: Period) -> Date {
        let comps = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: .current,
            year: period.year,
            month: period.month,
            day: period.day,
            hour: period.hour,
            minute: period.minute,
            second: period.second
        )
        return Calendar(identifier: .gregorian).date(byAdding: comps, to: self) ?? self
    }

    public func subtracting(_ period: Period) -> Date {
        let comps = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: .current,
            year: -period.year,
            month: -period.month,
            day: -period.day,
            hour: -period.hour,
            minute: -period.minute,
            second: -period.second
        )
        return Calendar(identifier: .gregorian).date(byAdding: comps, to: self) ?? self
    }
}

extension Period {
    
    public var later: Date {
        return Date().adding(self)
    }
    
    public var ago: Date {
        return Date().subtracting(self)
    }
}
