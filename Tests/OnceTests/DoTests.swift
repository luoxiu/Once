import XCTest
@testable import Once

class DoTests: XCTestCase {

    let count = 1000

    func testDoInstall() {
        let label = Label(rawValue: UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            Once.do(label, scope: .install) { (sealer) in
                i += 1
                sealer.seal()
            }
        }
        XCTAssertEqual(i, 1)
    }

    func testDoSince() {
        let label = Label(rawValue: UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            Once.do(label, scope: .since(Period.day(1).ago)) { (sealer) in
                i += 1
                sealer.seal()
            }
        }

        XCTAssertEqual(i, 1)
    }

    func testDoUntil() {
        let label = Label(rawValue: UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            Once.do(label, scope: .until(Period.day(1).later)) { (sealer) in
                i += 1
                sealer.seal()
            }
        }

        XCTAssertEqual(i, 1)
    }

    func testDoEvery() {
        let label = Label(rawValue: UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            Once.do(label, scope: .every(.second(1))) { (sealer) in
                i += 1
                sealer.seal()
            }
        }
        sleep(1)
        asyncAndWait(concurrent: count) {
            Once.do(label, scope: .every(.second(1))) { (sealer) in
                i += 1
                sealer.seal()
            }
        }
        XCTAssertEqual(i, 2)
    }

    func testIf() {
        let label = Label(rawValue: UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            Once.if(label, scope: .session, times: .lessThan(5)) { (sealer) in
                i += 1
                sealer.seal()
            }
        }

        XCTAssertEqual(i, 5)
    }

    func testUnless() {
        let label = Label(rawValue: UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            Once.unless(label, scope: .session, times: .greaterThan(5)) { (sealer) in
                i += 1
                sealer.seal()
            }
        }
        XCTAssertEqual(i, 6)
    }

    func testClear() {
        var i = 0
        Once.do("deadbeef", scope: .version) { (sealer) in
            i += 1
            sealer.seal()
        }

        XCTAssertEqual(i, 1)
        Once.clear("deadbeef")

        XCTAssertNil(Once.lastDone(of: "deadbeef"))
    }

    static var allTests = [
        "testDoInstall": testDoInstall,
        "testDoSince": testDoSince,
        "testDoUntil": testDoUntil,
        "testDoEvery": testDoEvery,
        "testIf": testIf,
        "testUnless": testUnless,
        "testClear": testClear
    ]
}
