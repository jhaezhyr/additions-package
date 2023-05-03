//
//  CGRange.swift
//  Architect
//
//  Created by Braeden Hintze on 2/26/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphics


// MARK:  - CGRange

//public typealias CGRange = ClosedRange<CGFloat>

public struct CGRange: CustomStringConvertible
{
	public var start: CGFloat
	public var end:	CGFloat
	
	public var width:	CGFloat
	{
		get { return end - start }
		set { end = start + newValue }
	}
	
	public var center: CGFloat
	{
		get { return start + (end - start) / 2 }
		set
		{
			let radius = width / 2
			start = newValue - radius
			end = newValue + radius
		}
	}
	
	public init(start: CGFloat, end: CGFloat)
	{
		self.start = start
		self.end = end
	}
	
	public init(start: CGFloat, width: CGFloat)
	{
		self.start = start
		end = start + width
	}
	
	public init(end: CGFloat, width: CGFloat)
	{
		self.end = end
		start = end - width
	}
	
	public init(center: CGFloat, width: CGFloat)
	{
		let radius = width / 2
		self.start = center - radius
		self.end = center + radius
	}
	
	/// Builds a range with two bounds, assigning the smaller to `start` and the larger to `end`.
	public init(_ bound1: CGFloat, _ bound2: CGFloat)
		{ self.init(start: bound1 <> bound2, end: bound1 >< bound2) }
	
	public func	offset(by offset: CGFloat) -> CGRange
		{ return CGRange(start: start+offset, end: end+offset) }
	
	public func	contains(_ value: CGFloat, inclusiveness: CGBoundInclusiveness = .half) -> Bool
	{
		switch inclusiveness
		{
			case .half:
				return (value >= start) && (value < end)
			case .exclusive:
				return (value > start) && (value < end)
			case .inclusive:
				return (value >= start) && (value <= end)
		}
	}
	
	public func	intersects(_ other: CGRange, inclusiveness: CGBoundInclusiveness = .half) -> Bool
	{
		// TODO: Testing
		switch inclusiveness
		{
			case .half:
				return	((other.start >= start) && (other.start < end)) ||
						((other.end >= start) && (other.end < end)) ||
						((other.start < start) && (other.end >= end))
			case .exclusive:
				return	((other.start > start) && (other.start < end)) ||
						((other.end > start) && (other.end < end)) ||
						((other.start <= start) && (other.end >= end))
			case .inclusive:
				return	((other.start >= start) && (other.start <= end)) ||
						((other.end >= start) && (other.end <= end)) ||
						((other.start < start) && (other.end > end))
		}
	}
	
	public func inset(by x: CGFloat) -> CGRange
		{ return CGRange(start: start + x, end: end - x) }
	
	public func	union(_ other: CGRange) -> CGRange
	{
		return CGRange(	start:	self.start <> other.start,
						end:	self.end >< other.end	)
	}
	
	public func clamp(_ value: CGFloat) -> CGFloat
		{ return value.clamp(start, end) }
	
	public var description:	String
		{ return "\(start) to \(end)" }
}


extension CGRect
{
	public func	offset(by pt: CGPoint) -> CGRect
		{ return offsetBy(dx: pt.x, dy: pt.y) }
	
	public init(x: CGRange, y: CGRange)
		{ self.init(x.start, y.start, x.end, y.end) }
	
	public var ranges: (x: CGRange, y: CGRange)
	{
		get { return (x: CGRange(start: nearPoint.x, end: farPoint.x), y: CGRange(start: nearPoint.y, end: farPoint.y)) }
		set { self = CGRect(x: newValue.x, y: newValue.y) }
	}
}

extension CGRange: ArithmeticShiftable, ArithmeticScalable
{
	public typealias ArithmeticShift = CGFloat
	public typealias ArithmeticScalar = CGFloat
	public static func + (lh: CGRange, rh: CGFloat) -> CGRange
		{ return CGRange.init(start: lh.start + rh, end: lh.end + rh) }
	public static func * (lh: CGRange, rh: CGFloat) -> CGRange
		{ return CGRange.init(start: lh.start * rh, end: lh.end * rh) }
}

public enum CGBoundInclusiveness
{
	/// Includes the lower bound, but not the upper bound.
	case half
	/// Includes the lower and upper bounds.
	case inclusive
	/// Includes neither bounds, lower or upper.
	case exclusive
}


public prefix func - (x: CGRange) -> CGRange
	{ return CGRange(start: -x.end, end: -x.start) }
/*
extension Range where Bound == CGFloat
{
	public var width:	CGFloat
	{
		get { return upperBound - lowerBound }
		set { upperBound = lowerBound + newValue }
	}
	
	public var center: CGFloat
	{
		get { return start + (end - start) / 2 }
		set
		{
			let radius = width / 2
			start = newValue - radius
			end = newValue + radius
		}
	}
}*/
