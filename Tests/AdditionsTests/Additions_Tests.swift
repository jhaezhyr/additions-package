//
//  Additions_Tests.swift
//  Additions Tests
//
//  Created by Braeden Hintze on 6/25/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Additions
import XCTest

class Additions_Tests: XCTestCase
{
    
    override func setUp()
	{
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
	{
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func	testIntegerFormat()
	{
		let myTestString = "Join us, one and all!"
		if let indexRange = myTestString.range(of: "and")
		{
			let andString = myTestString[indexRange]
			print(andString)
			var myTestString2 = myTestString
			myTestString2.replaceSubrange(indexRange, with: "or")
			print(Substring(myTestString2))
		}
	}
	
	func testAngleFunctions()
	{
		print("Testing `.twoPiInterval`")
		for angle in stride(from: -720, to: 720, by: 45)
		{
			let angle = Angle.Raw(angle)°
			XCTAssert((0°...2*π).contains(angle.twoPiInterval))
			XCTAssert((-π...π).contains(angle.piInterval))
		}
	}
}

