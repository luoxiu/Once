import XCTest

#if os(Linux)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TokenTests.allTests),
        testCase(PeriodTests.allTests),
        testCase(TimesPredicateTests.allTests),
        testCase(PersistentTokenTests.allTests)
    ]
}
#endif
