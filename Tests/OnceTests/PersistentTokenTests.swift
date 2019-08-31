import XCTest
@testable import Once

class PersistentTokenTests: XCTestCase {

    let count = 100
    
    func testMake() {
        let tokens = Atom<[PersistentToken]>(value: [])
        let name = UUID().uuidString
        
        asyncAndWait(concurrent: count) {
            tokens.append(PersistentToken.make(name))
        }
        
        let ts = tokens.get().reduce(into: [PersistentToken]()) { (r, t) in
            if !r.contains(where: { $0 === t }) { r.append(t) }
        }
        XCTAssertEqual(ts.count, 1)
    }

    func testIfEqualTo_Install() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            token.do(in: .install, if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 1)
    }
    
    func testIfLessThan_Install() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            token.do(in: .install, if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 3)
    }
    
    func testVersion() {
        func resetVersion() {
            UserDefaults.standard.set(nil, forKey: "com.v2ambition.once.version")
        }
        
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        
        asyncAndWait(concurrent: count) {
            token.do(in: .version, if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 1)
        
        resetVersion()
        PersistentToken.initialize()
        
        asyncAndWait(concurrent: count) {
            token.do(in: .version, if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 2)
    }
    
    func testSession() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            token.do(in: .session, if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 3)
    }
    
    func testReset() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            token.do(in: .session, if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 1)
        
        token.reset()
        
        asyncAndWait(concurrent: count) {
            token.do(in: .session, if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 2)
    }
    
    func testResetAll() {
        let tokens = Atom<[PersistentToken]>(value: [])
        let num = Atom(value: 0)
        asyncAndWait(concurrent: count) {
            let token = PersistentToken.make(UUID().uuidString)
            tokens.append(token)
            token.do(in: .session, if: .equalTo(0)) { done in
                num.add(1)
                done()
            }
        }
        XCTAssertEqual(num.get(), count)
        
        PersistentToken.resetAll()
        
        tokens.get().forEach {
            $0.do(in: .session, if: .equalTo(0)) { done in
                num.add(1)
                done()
            }
        }
        XCTAssertEqual(num.get(), count + count)
    }
    
    func testSince() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            token.do(in: .since(Date() - 0.5), if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 3)
        
        Thread.sleep(forTimeInterval: 0.5)
        asyncAndWait(concurrent: count) {
            token.do(in: .since(Date() - 0.5), if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 6)
    }
    
    func testUntil() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: count) {
            token.do(in: .until(Date() + 0.5), if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 3)
        
        token.reset()
        
        asyncAndWait(concurrent: count) {
            token.do(in: .until(Date() + 0.5), if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 6)
    }
    
    func testEvery() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: 10) {
            token.do(in: .every(.second(1)), if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 1)
        
        Thread.sleep(forTimeInterval: 1)
        
        asyncAndWait(concurrent: 10) {
            token.do(in: .every(.second(1)), if: .equalTo(0)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 2)
    }
    
    func testHasBeenDone() {
        let token = PersistentToken.make(UUID().uuidString)
        var i = 0
        asyncAndWait(concurrent: 10) {
            token.do(in: .session, if: .lessThan(3)) { done in
                i += 1
                done()
            }
        }
        XCTAssertEqual(i, 3)
        XCTAssertTrue(token.hasBeenDone(in: .session, .equalTo(3)))
    }

    static var allTests = [
        "testMake": testMake,
        "testIfEqualTo_Install": testIfEqualTo_Install,
        "testIfLessThan_Install": testIfLessThan_Install,
        "testVersion": testVersion,
        "testSession": testSession,
        "testReset": testReset,
        "testResetAll": testResetAll,
        "testSince": testSince,
        "testUntil": testUntil,
        "testEvery": testEvery,
        "testHasBeenDone": testHasBeenDone
    ]
}
