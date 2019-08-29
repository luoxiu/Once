import XCTest
@testable import Once

class RunTests: XCTestCase {

    let count = 10_000

    func testRunWithToken() {
        let token = Token.makeStatic()

        var i = 0
        asyncAndWait(concurrent: count) {
            Once.run(token) {
                i += 1
            }
        }
        XCTAssertEqual(i, 1)
    }

    func testRunWithoutToken() {

        var i = 0
        asyncAndWait(concurrent: count) {
            Once.run {
                i += 1
            }
        }
        
        asyncAndWait(concurrent: count) {
            Once.run {
                i += 1
            }
        }
        XCTAssertEqual(i, 2)
    }

    static var allTests = [
        ("testRunWithToken", testRunWithToken),
        ("testRunWithoutToken", testRunWithoutToken)
    ]
}
