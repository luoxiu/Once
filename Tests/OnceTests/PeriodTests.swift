import XCTest
@testable import Once

class PeriodTests: XCTestCase {

    func testPeriod() {
        let d1 = Period.year(1).later
        XCTAssertEqual(d1.dateComponents.year, Date().dateComponents.year! + 1)

        let d2 = Period.month(1).ago
        if d2.dateComponents.month == 12 {
            XCTAssertEqual(Date().dateComponents.month, 1)
        } else {
            XCTAssertEqual(d2.dateComponents.month, Date().dateComponents.month! - 1)
        }

        let p = Period.week(1) + Period.day(2) + Period.hour(3) + Period.minute(4) + Period.second(5)
        let d3 = p.later

        let i = Double(5) + 4 * 60 + 3 * 60 * 60 + 2 * 24 * 60 * 60 + 7 * 24 * 60 * 60
        XCTAssert(d3.timeIntervalSinceNow - i < 0.001)
    }

    static var allTests = [
        ("testPeriod", testPeriod)
    ]
}
