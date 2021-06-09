//
//  Arithmetic Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

extension SignedNumeric where Self: Comparable
{
	public func	signed(_ sign: FloatingPointSign) -> Self
	{
		if (sign == .plus)
			{ return self }
		else
			{ return -self }
	}
}


extension Comparable
{
	/// Returns `self` if it is in the range, or returns the nearest bound if not.
	///
	/// - Parameters:
	///		- lowerBound:  The lowest value this function can return
	///		- upperBound:  The highest value this function can return.
	public func	clamp(_ lowerBound: Self, _ upperBound: Self) -> Self
	{
		assert(upperBound >= lowerBound, "Can't clamp value when top is higher than bottom.")
		
		if (self < lowerBound)
			{ return lowerBound }
		else if (upperBound < self)
			{ return upperBound }
		else
			{ return self }
	}
}


extension Int
{
	public var		shortOrdinal:	String
	{
		let num	= abs(self)
		
		switch (num % 10)
		{
			case 1 where num != 11:
				return "\(self)st"
			case 2 where num != 12:
				return "\(self)nd"
			case 3 where num != 13:
				return "\(self)rd"
			default:
				return "\(self)th"
		}
	}
}


// MARK:  Tolerance

public extension Double
{
	static var equalityTolerance:	Double	= 2.0 / Double(1 << 15)
}

public extension Float
{
	static var equalityTolerance:	Float	= 2.0 / Float(1 << 11)
}
/*
public extension CGFloat
{
	static var equalityTolerance:	CGFloat	= 2.0 / CGFloat(1 << 15)
}
*/

// MARK:  Math

public func	log(_ n: Double, base b: Double) -> Double
{
	return log(n)/log(b)
}


public func	log(_ n: Float, base b: Float) -> Float
{
	return log(n)/log(b)
}

/*
public func	log(_ n: CGFloat, base b: CGFloat) -> CGFloat
{
	return log(n)/log(b)
}
*/
