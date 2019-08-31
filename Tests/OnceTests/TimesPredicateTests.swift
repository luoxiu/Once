import XCTest
@testable import Once

class TimesPredicateTests: XCTestCase {

    func testTimesChecker() {

        XCTAssertTrue(TimesPredicate.equalTo(1).evaluate(1))
        XCTAssertTrue(TimesPredicate.lessThan(1).evaluate(0))
        XCTAssertTrue(TimesPredicate.moreThan(1).evaluate(2))

        XCTAssertFalse(TimesPredicate.lessThan(1).evaluate(2))
        XCTAssertFalse(TimesPredicate.moreThan(1).evaluate(0))
        
        XCTAssertTrue(TimesPredicate.moreThanOrEqualTo(0).evaluate(0))
        XCTAssertTrue(TimesPredicate.lessThanOrEqualTo(1).evaluate(0))
    }

    static var allTests = [
        ("testTimesChecker", testTimesChecker)
    ]
}
