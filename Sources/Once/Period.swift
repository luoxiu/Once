import Foundation

public struct Period {

    let year: UInt

    let month: UInt

    let day: UInt

    let hour: UInt

    let minute: UInt

    let second: UInt

    init(year: UInt = 0, month: UInt = 0, day: UInt = 0,
         hour: UInt = 0, minute: UInt = 0, second: UInt = 0) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
}

extension Period {

    public static func + (lhs: Period, rhs: Period) -> Period {
        let year = lhs.year + rhs.year
        let month = lhs.month + rhs.month
        let day = lhs.day + rhs.day
        let hour = lhs.hour + rhs.hour
        let minute = lhs.minute + rhs.minute
        let second = lhs.second + rhs.second
        return Period(year: year, month: month, day: day,
                      hour: hour, minute: minute, second: second)
    }
}

extension Period: Equatable {

    public static func == (lhs: Period, rhs: Period) -> Bool {
        let now = Date()
        return now.adding(lhs) == now.adding(rhs)
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

extension Period {

    public static func year(_ num: UInt) -> Period {
        return Period(year: num)
    }

    public static func month(_ num: UInt) -> Period {
        return Period(month: num)
    }

    public static func day(_ num: UInt) -> Period {
        return Period(day: num)
    }

    public static func hour(_ num: UInt) -> Period {
        return Period(hour: num)
    }

    public static func minute(_ num: UInt) -> Period {
        return Period(minute: num)
    }

    public static func second(_ num: UInt) -> Period {
        return Period(second: num)
    }

    public static func week(_ num: UInt) -> Period {
        return Period(day: 7 * num)
    }
}

extension Date {

    public func adding(_ period: Period) -> Date {
        let dc = DateComponents(calendar: Calendar(identifier: .gregorian),
                                timeZone: .current,
                                year: Int(period.year),
                                month: Int(period.month),
                                day: Int(period.day),
                                hour: Int(period.hour),
                                minute: Int(period.minute),
                                second: Int(period.second))
        return Calendar(identifier: .gregorian).date(byAdding: dc, to: self)!
    }

    public func subtracting(_ period: Period) -> Date {
        let dc = DateComponents(calendar: Calendar(identifier: .gregorian),
                                timeZone: .current,
                                year: -Int(period.year),
                                month: -Int(period.month),
                                day: -Int(period.day),
                                hour: -Int(period.hour),
                                minute: -Int(period.minute),
                                second: -Int(period.second))
        return Calendar(identifier: .gregorian).date(byAdding: dc, to: self)!
    }
}
