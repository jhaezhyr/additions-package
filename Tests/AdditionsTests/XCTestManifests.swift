import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AdditionsTests.allTests),
        testCase(Additions_Tests.allTests),
        testCase(MathOperatorTests.allTests),
    ]
}
#endif
