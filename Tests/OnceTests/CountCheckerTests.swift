import XCTest
@testable import Once

class CountCheckerTests: XCTestCase {

    func testCountChecker() {

        XCTAssertTrue(CountChecker.equalTo(1).check(1))
        XCTAssertTrue(CountChecker.lessThan(1).check(0))
        XCTAssertTrue(CountChecker.greaterThan(1).check(2))

        XCTAssertFalse(CountChecker.lessThan(1).check(2))
        XCTAssertFalse(CountChecker.greaterThan(1).check(0))
    }

    static var allTests = [
        ("testCountChecker", testCountChecker)
    ]
}
