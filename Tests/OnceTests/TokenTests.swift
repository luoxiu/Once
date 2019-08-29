import XCTest
@testable import Once

class TokenTests: XCTestCase {

    let count = 10_000
    
    func testToken() {
        let t1 = Token()
        let t2 = Token()
        
        var i = 0
        asyncAndWait(concurrent: count) {
            t1.run {
                i += 1
            }
            t2.run {
                i += 1
            }
        }
        
        XCTAssertEqual(i, 2)
    }

    func testStaticToken() {
        let fn = { () -> Token in
            Token.makeStatic()
        }

        let t0 = fn()
        let t1 = fn()
        let t2 = fn()

        XCTAssertTrue(t0 === t1)
        XCTAssertTrue(t1 === t2)
    }

    static var allTests = [
        ("testToken", testToken),
        ("testStaticToken", testStaticToken)
    ]
}
