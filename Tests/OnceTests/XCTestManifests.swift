import XCTest

#if os(Linux)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RunTests.allTests),
        testCase(PeriodTests.allTests),
        testCase(CountCheckerTests.allTests),
        testCase(DoTests.allTests)
    ]
}
#endif
