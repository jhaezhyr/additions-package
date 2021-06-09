
import XCTest
@testable import Additions

final class MathOperatorTests: XCTestCase
{
	func testPower()
	{
		XCTAssertEqual(2.0 as Double ** 5.0 as Double, 32.0 as Double)
	}
	
	func testApproximatelyEqual()
	{
		XCTAssertTrue(3.0 - 0.00000000000001 ≈≈ 3.0)
	}

    static var allTests = [
        ("testPower", testPower),
        ("testApproximatelyEqual", testApproximatelyEqual),
    ]

}