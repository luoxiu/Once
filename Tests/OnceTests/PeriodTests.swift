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
    }

    static var allTests = [
        ("testPeriod", testPeriod)
    ]
}
