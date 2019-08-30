import XCTest
@testable import Once

class RunTests: XCTestCase {

    let count = 10_000
    
    func testMake() {
        let counter = Atom(value: 0)
        let token = Token.make()

        var i = 0
        asyncAndWait(concurrent: count) {
            counter.add(1)
            token.do { i += 1 }
        }
        
        XCTAssertEqual(counter.get(), count)
        XCTAssertEqual(i, 1)
    }
    
    func testStaticMake() {
        let tokens = Atom<[Token]>(value: [])
        
        asyncAndWait(concurrent: count) {
            tokens.append(Token.makeStatic())
        }
        
        var i = 0
        tokens.get().forEach {
            $0.do { i += 1 }
        }
        
        XCTAssertTrue(tokens.get().count == count)
        XCTAssertTrue(i == 1)
    }

    static var allTests = [
        ("testMake", testMake),
        ("testStaticMake", testStaticMake)
    ]
}
