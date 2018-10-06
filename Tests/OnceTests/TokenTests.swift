import XCTest
@testable import Once

class TokenTests: XCTestCase {

    let count = 100_000

    func testToken() {
        let fn = { () -> Token in
            Once.makeToken()
        }

        let t0 = fn()
        let t1 = fn()
        let t2 = fn()

        XCTAssertTrue(t0 === t1)
        XCTAssertTrue(t1 === t2)
    }

    static var allTests = [
        ("testToken", testToken)
    ]
}
