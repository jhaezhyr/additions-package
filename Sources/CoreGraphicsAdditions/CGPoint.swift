//
//  CGPoint.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphics


extension CGPoint
{
	public init(_ vector: CGPoint)
		{ self.init(x: CGFloat(vector.x), y: CGFloat(vector.y)) }
	public init(_ size: CGSize)
		{ self.init(x: CGFloat(size.width), y: CGFloat(size.height)) }
	public init(_ vector: CGVector)
		{ self.init(x: CGFloat(vector.dx), y: CGFloat(vector.dy)) }
	
	init(xy: CGFloat)
		{ self.init(x: xy, y: xy) }
}

extension CGPoint: Hashable
{
	public var hashValue: Int
		{ return x.hashValue ^ y.hashValue }
}

extension CGPoint
{
	public init(radius: CGFloat, radians: CGFloat)
		{ self.init(radius: radius, angle: Angle(radians)) }
	public init(radius: CGFloat, degrees: CGFloat)
		{ self.init(radius: radius, radians: radian(from: degrees)) }
	public init(radius: CGFloat, angle a: Angle)
		{ self.init(x: radius * CGFloat(cos(a)), y: radius * CGFloat(sin(a))) }
	
	/// The angle of the vector in radians, within the interval (-π, π].
	public var angle: Angle
	{
		get
		{
			if (x > 0) // Quadrants 1 and 4
			{
				//	asin y/r = theta
				return asin(y/length) as Angle
			}
			else // Quadrants 2 and 3
			{
				let raw: Angle = asin(y/length)
				
				if (raw < 0) // Lower half of circle, excluding 180°.
				{
					// d = raw + π/2
					// return -π/2 - d
					
					return -π - raw
				}
				else // Upper half and 180°.
				{
					// d = π/2 - raw
					// return π/2 + d
					
					return π - raw
				}
			}
		}
		
		mutating set
		{
			let radius = length
			
			x = radius * CGFloat(cos(newValue))
			y = radius * CGFloat(sin(newValue))
		}
	}
	
	public var length:	CGFloat
	{
		get { return sqrt(x*x + y*y) }
		mutating set
		{
			let ratio	= newValue / length
			
			x *= ratio
			y *= ratio
		}
	}
}

/*extension CGPoint: CustomStringConvertible
{
	public var description:	String
		{ return "(\(x), \(y)))" }

	public var debugDescription:	String
		{ return "x: \(x), y: \(y)" }
}*/

extension CGPoint: ArithmeticAddable, ArithmeticSummable, ArithmeticNegatable, ArithmeticScalable
{
	public static func + (l: CGPoint, r: CGPoint) -> CGPoint
	{
		return CGPoint(x: l.x + r.x,
						  y:l.y + r.y	)
	}
	
	public static prefix func - (v: CGPoint) -> CGPoint
	{
		return CGPoint(x: -v.x,
						  y: -v.y	)
	}
	
	public typealias ArithmeticScalar = CGFloat
	public static func * (l: CGPoint, r: CGFloat) -> CGPoint
	{
		return CGPoint(x:  l.x * r,
						  y:	l.y * r	)
	}
}

public extension CGPoint
{
	/// Generates a random vector anywhere in space.
	static func unboundedRandom() -> CGPoint
	{
		return CGPoint(x: CGFloat.unboundedRandom(),
						  y: CGFloat.unboundedRandom()	)
	}
	
	/// Generates a random vector anywhere within the bounding box formed by `min` and `max`.
	static func randomInBounds(_ min: CGPoint, _ max: CGPoint) -> CGPoint
	{
		return CGPoint(x: CGFloat.random(min.x, max.x),
						  y: CGFloat.random(min.y, max.y)	)
	}
	
	/// Generates a random vector anywhere within `bounds`.
	static func randomInBounds(_ bounds: CGRect) -> CGPoint
	{
		return CGPoint.randomInBounds(.init(bounds.origin), .init(bounds.farPoint))
	}
	
	/// Generates a random vector anywhere within the bounding box formed by `min` and `max`.
	static func randomInSphere(center: CGPoint, radius: CGFloat) -> CGPoint
	{
		var result:	CGPoint
		let lowerBound = center - CGPoint(x: radius, y: radius)
		let upperBound = center + CGPoint(x: radius, y: radius)
		repeat
		{
			result = CGPoint.randomInBounds(lowerBound, upperBound)
		} while ((result - center).length > radius)
		
		return result
	}
	
	/// Generates a random vector anywhere within the ellipse of `min` and `max`.
	static func randomInEllipse(_ min: CGPoint, _ max: CGPoint) -> CGPoint
	{
		let size	= max - min
		let point	= randomInSphere(center: CGPoint(xy: 0.5), radius: 0.5)
		
		return min + CGPoint(x: point.x * size.x, y: point.y * size.y)
	}
}


public extension CGPoint
{
	static let forwardVector = CGPoint(x: 1, y: 0)
	
	func transpose() -> CGPoint
	{
		return CGPoint(x: y, y: x)
	}
	
	
	func rotated(by angle: Angle) -> CGPoint
	{
		let cosine = CGFloat(cos(angle))
		let sine = CGFloat(sin(angle))
		return CGPoint(x: cosine * x - sine * y, y: cosine * y + sine * x)
	}
}
