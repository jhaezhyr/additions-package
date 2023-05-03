//
//  IntPoint.swift
//  Game Kit
//
//  Created by Braeden Hintze on 11/25/14.
//  Copyright (c) 2014 Braeden Hintze. All rights reserved.
//


public struct IntPoint: Equatable, Hashable
{
	public var x:	Int
	public var y:	Int
	
	public init(_ nx:Int, _ ny:Int)
	{
		x = nx
		y = ny
	}
	
	public init(x nx:Int, y ny:Int)
	{
		x = nx
		y = ny
	}
	
	public init()
	{
		x = 0
		y = 0
	}
	
	
	public var hashValue:	Int
		{ return 31 &* x.hashValue + y.hashValue }
}


public func	== (lh: IntPoint, rh: IntPoint) -> Bool
{
	return ((lh.x == rh.x) && (lh.y == rh.y))
}

public func	+ (lh: IntPoint, rh: IntPoint) -> IntPoint
	{ return IntPoint(x: lh.x + rh.x, y: lh.y + rh.y) }

public func	- (lh: IntPoint, rh: IntPoint) -> IntPoint
	{ return IntPoint(x: lh.x - rh.x, y: lh.y - rh.y) }

public func	+= (lh: inout IntPoint, rh: IntPoint)
	{ lh = lh + rh }

public func	-= (lh: inout IntPoint, rh: IntPoint)
	{ lh = lh - rh }


// MARK:  - IntRect

/// A container of integer indices including `origin` in a span `size`.  For example, a rect that only includes (5, 5) is:  Origin==(5,5), size==(1,1), end==(6,6)
public struct IntRect
{
	public var start:	IntPoint
	public var end:	IntPoint
	public var size:	IntPoint
	{
		get { return end - start }
		set { end = start + newValue }
	}
	
	public var x:		CountableRange<Int>
		{ return start.x ..< end.x }
	public var y:		CountableRange<Int>
		{ return start.y ..< end.y }
	
	
	public init(origin: IntPoint, size: IntPoint)
	{
		self.start = origin
		self.end = origin + size
	}
	
	public init(origin: IntPoint, end: IntPoint)
	{
		self.start = origin
		self.end = end
	}
	
	public init(end: IntPoint, size: IntPoint)
	{
		self.start = end - size
		self.end = end
	}
	
	public init(pt1: IntPoint, pt2: IntPoint)
	{
		let proposed = IntRect(origin: pt1, end: pt2)
		self = proposed.validate()
	}
	
	public init(x: Range<Int>, y: Range<Int>)
	{
		self.init(	origin:	IntPoint(x: x.lowerBound, y: y.lowerBound),
					end:	IntPoint(x: x.upperBound, y: y.upperBound	)	)
		
	}
	
	
	public func	validate() -> IntRect
	{
		var newRect = self
		
		if (newRect.size.x < 0)
		{
			newRect.start.x = newRect.end.x
			newRect.size.x *= -1
		}
		
		if (newRect.size.y < 0)
		{
			newRect.start.y = newRect.end.y
			newRect.size.y *= -1
		}
		
		return newRect
	}
	
	
	public func	contains(_ element: IntPoint) -> Bool
	{
		return ((element.x >= start.x) &&
				(element.x < end.x) &&
				(element.y >= start.y) &&
				(element.y < end.y)	)
	}
}


extension IntRect: Hashable
{
	public var hashValue:	Int
		{ return 31 &* start.hashValue + size.hashValue }
}


public func	== (lh: IntRect, rh: IntRect) -> Bool
	{ return (lh.start == rh.start) && (lh.size == rh.size) }


public func ... (lh: IntPoint, rh: IntPoint) -> IntRect
{
	return IntRect(origin: lh, end: rh + IntPoint(x: 1, y: 1))
}

public func ..< (lh: IntPoint, rh: IntPoint) -> IntRect
{
	return IntRect(origin: lh, end: rh)
}


extension IntRect: Sequence
{
	public func	makeIterator() -> IntRectGenerator
	{
		return IntRectGenerator(rect: self)
	}
	
	
	/// Must be exactly the point before a valid point, or will return nil.
	public func	advancePoint(_ x: IntPoint) -> IntPoint?
	{
		var point = x
		point.x += 1
		
		if (point.x == end.x)
		{
			point.x = start.x
			point.y += 1
		}
		
		if contains(point)
			{ return point }
		else
			{ return nil }
	}
	
	
	public func	precedePoint(_ x: IntPoint) -> IntPoint?
	{
		var point = x
		point.x -= 1
		
		if (point.x == start.x)
		{
			point.x = end.x - 1
			point.y -= 1
		}
		
		if contains(point)
			{ return point }
		else
			{ return nil }
	}
}


/// Iterates through each element in each row, in an order of (0, 0), (1, 0), (2, 0), (0, 1), (1, 1)....  2-dimensional arrays that are indexed with IntPoints should be accessed like so:  myArray[pt.y][pt.x].
public struct IntRectGenerator: IteratorProtocol
{
	var rect:	IntRect
	var point:	IntPoint?
	
	
	init(rect: IntRect)
	{
		self.rect = rect
		point = rect.start
	}
	
	
	public mutating func next() -> IntPoint?
	{
		let result = point
		
		if let point = point
			{ self.point = rect.advancePoint(point) }
		
		return result
	}
}


// MARK:  - CoreGraphics Glue

import CoreGraphics


public extension CGPoint
{
    init(_ intPoint: IntPoint)
	{
		self.init(x: CGFloat(intPoint.x), y: CGFloat(intPoint.y))
	}
}


public extension CGRect
{
    init(_ intRect: IntRect)
	{
		self.init(origin: CGPoint(intRect.start), size: CGSize(width: intRect.size.x, height: intRect.size.y))
	}
}


public extension IntPoint
{
    var CGPoint:	CoreGraphics.CGPoint
		{ return CoreGraphics.CGPoint.init(x: CGFloat(x), y: CGFloat(y)) }
}


public extension IntRect
{
    var CGRect:		CoreGraphics.CGRect
		{ return CoreGraphics.CGRect(origin: CGPoint(start), size: CGSize(width: size.x, height: size.y)) }
}
