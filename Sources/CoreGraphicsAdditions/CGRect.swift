//
//  CGRect.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphics
import AdditionsCore

public extension CGRect
{
	// MARK:  Properties
	
	/// The point with the minimum values.  Defines the rect with `farPoint`.
	///
	/// Always has the same value as `origin`, but setting it changes `size`, not `farPoint`.
    var nearPoint: CGPoint
	{
		get { return origin }
		set { self = CGRect(origin: newValue, size: CGSize(farPoint - newValue)) }
	}
	
	/// The point with the maximum values.  Defines the rect with `nearPoint`.
	///
	/// Has the same value as `origin + size`, and setting it changes only `size`.
	var farPoint: CGPoint
	{
		get { return CGPoint(x: origin.x + size.width, y: origin.y + size.height) }
		set { size = CGSize(width: newValue.x - origin.x, height: newValue.y - origin.y) }
	}
	
	/// The point with the central values.  Defines the rect with `size`.
	///
	/// Has the same value as `origin + size / 2`, and setting it changes only `origin`.
	var center: CGPoint
	{
		get	{ return origin + CGPoint(size / 2) }
		set	{ origin = newValue + -CGPoint(size / 2) }
	}
					
	var diagonalLength:	CGFloat
	{
		get	{ return size.magnitude }
	}
	
	subscript(position: Position2) -> CGPoint
	{
		get
		{
			let x = position.x.map { $0 ? farPoint.x : origin.x } ?? center.x
			let y = position.y.map { $0 ? farPoint.y : origin.y } ?? center.y
			return CGPoint(x: x, y: y)
		}
	}
	
	/// Sets the size of the rect while maintaining value of the reference point.
	///
	/// `reference(_:)` calculates a reference point of a given rect.
	///
	/// ````
	/// // e.g. Resize around the bottom-middle.
	/// var myRect = CGRect(origin: CGPoint(x: 4, y: 1), size: CGSize(width: 6, height: 3))
	/// func baseOfRect(rect: CGRect) -> CGPoint
	///		{ return CGPoint(x: center.x, y: origin.y) }
	/// myRect.setSize(CGSize(width: 2, height: 2), about: baseOfRect)
	/// // myRect == CGRect(origin: CGPoint(x: 6, y: 1), size: CGSize(width: 2, height: 2))
	/// ````
	///
	/// - Note:  Do not calculate `reference()` using a captured reference to the receiver.  A current copy of the rect is passed in as the sole parameter of the function.
	mutating func setSize(_ newSize: CGSize, about reference: (CGRect) -> CGPoint)
	{
		// The "point" should stay the same, so after the size is mutated, origin should compensate if necessary.
		var newSelf = self
		
		let originalPoint = reference(newSelf)
		newSelf.size = newSize
		let shiftedPoint = reference(newSelf)
		let correctionOffset = originalPoint - shiftedPoint
		newSelf.origin += correctionOffset
		
		self = newSelf
	}
	
	mutating func setLocation(to newPoint: CGPoint, about reference: (CGRect) -> CGPoint)
	{
		let originalReference = reference(self)
		let delta = newPoint - originalReference
		origin += delta
	}
	
	
	// MARK:  Initialization
	
	/// Similar to legacy Toolbox's `RectMake()`, sets x1, x2, y1, and y2 according to the parameters.
	/// Not to be confused with the behavior of CGRectMake, which takes (x1, y1, width, height).
	init(	_ x1:	CGFloat,
			_ y1:	CGFloat,
			_ x2:	CGFloat,
			_ y2:	CGFloat	)
	{
		self.init(origin: CGPoint(x: x1, y: y1), size: CGSize(width: x2 - x1, height: y2 - y1))
	}
	
	/// Creates a rect with any two diagonally opposite vertices.
	init(_ pt1: CGPoint, _ pt2: CGPoint)
	{
		self.init(pt1.x <> pt2.x, pt1.y <> pt2.y, pt1.x >< pt2.x, pt1.y >< pt2.y)
	}
	
	/// Creates a rect using the center.
	init(center: CGPoint, size: CGSize)
	{
		self.init(origin: center + -CGPoint(x: size.width/2, y: size.height/2), size: size)
	}
}

public extension CGRect
{
	func contains(_ point: CGPoint, inclusiveness: CGBoundInclusiveness) -> Bool
	{
		switch inclusiveness
		{
			case .half:
				return	(point.x >= origin.x) && (point.x < farPoint.x) &&
						(point.y >= origin.y) && (point.y < farPoint.y)
			case .inclusive:
				return	(point.x >= origin.x) && (point.x <= farPoint.x) &&
						(point.y >= origin.y) && (point.y <= farPoint.y)
			case .exclusive:
				return	(point.x > origin.x) && (point.x < farPoint.x) &&
						(point.y > origin.y) && (point.y < farPoint.y)
		}
	}
	
	func contains(_ point: CGPoint, whenRotatedBy angle: Angle, about axis: CGPoint) -> Bool
	{
		fatalError("contains(_:whenRotatedBy:about:) is not implemented.")
	}
}

extension CGRect: CustomStringConvertible
{
	public var description:	String
		{ return "(\(origin), \(farPoint))" }
	
	public var debugDescription:	String
		{ return "CGRect(origin: \(origin), size: \(size))" }
}

public extension CGRect
{
	var x1:		CGFloat
	{
		get	{ return origin.x }
		set	{ size.width = x2 - newValue; origin.x = newValue }
	}
	var y1:		CGFloat
	{
		get	{ return origin.y }
		set	{ size.height = y2 - newValue; origin.y = newValue }
	}
	
	var x2:		CGFloat
	{
		get	{ return origin.x + size.width }
		set	{ size.width = newValue - x1 }
	}
	var y2:		CGFloat
	{
		get	{ return origin.y + size.height }
		set	{ size.height = newValue - y1 }
	}
	
	var left:	CGFloat
	{
		get	{ return x1 }
		set	{ x1 = newValue }
	}
	var right:  CGFloat
	{
		get	{ return x2 }
		set	{ x2 = newValue }
	}
	var top:	CGFloat
	{
		get
		{
			if CGRect.flippedEnvironment
				{ return y2 }
			else
				{ return y1 }
		}
		set
		{
			if CGRect.flippedEnvironment
				{ y2 = newValue }
			else
				{ y1 = newValue }
		}
	}
	var bottom: CGFloat
	{
		get
		{
			if CGRect.flippedEnvironment
				{ return y1 }
			else
				{ return y2 }
		}
		set
		{
			if CGRect.flippedEnvironment
				{ y1 = newValue }
			else
				{ y2 = newValue }
		}
	}
	
	/// Top-left corner, according to whether the environment is flipped.
	var topLeft:		CGPoint
	{
		get	{ return CGPoint(x: left, y: top) }
		set { left = newValue.x; top = newValue.y }
	}
	var bottomLeft:	CGPoint
	{
		get	{ return CGPoint(x: left, y: bottom) }
		set	{ left = newValue.x; bottom = newValue.y }
	}
	var topRight:	CGPoint
	{
		get	{ return CGPoint(x: right, y: top) }
		set	{ right = newValue.x; top = newValue.y }
	}
	var bottomRight:	CGPoint
	{
		get	{ return CGPoint(x: right, y: bottom) }
		set	{ right = newValue.x; bottom = newValue.y }
	}

	
	#if os(OSX)
		fileprivate static var flippedStack = [true]
	#else
		fileprivate static var flippedStack = [false]
	#endif
	
    static var flippedEnvironment: Bool
		{ return flippedStack.last! }
	
	/// Sets the environment flip to the indicated flag.  Must be balanced with a call to `restoreFlippedEnvironment()` when the flip is no longer necessary.
    static func saveFlippedEnvironment(_ flipped: Bool)
		{ flippedStack.append(flipped) }
	
	/// Toggles the environment flip using a call to `saveFlippedEnvironment(_:)`.  Must be similarly balanced with a call to `restoreFlippedEnvironment()`.
    static func flipEnvironment()
		{ flippedStack.append(!flippedEnvironment) }
	
	/// Restores the `flippedEnvironment` flag after a call to `saveFlippedEnvironment(_:)`.
	///
	/// DON'T call this without saving a flip state first.
    static func restoreFlippedEnvironment()
		{ flippedStack.removeLast() }
}


extension CGRect: ArithmeticScalable
{
	public typealias ArithmeticScalar = CGFloat
	public static func * (lh: CGRect, rh: CGFloat) -> CGRect
		{ return CGRect(origin: lh.origin * rh, size: lh.size * rh) }
}


