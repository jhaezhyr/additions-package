//
//  Random.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

#if swift(<4.2)

#if canImport(Darwin)
import Darwin
#else
import Glibc
var arc4random_uniform = { (_ hi: UInt32) -> UInt32 in UInt32(Glibc.random()) % hi }
// TODO Test this random stuff.
#endif


public protocol UniformRandom
{
	/// Returns a random value within `[low, high]`.
	static func	random(_ low: Self, _ high: Self) -> Self
}

public protocol UnboundedUniformRandom: UniformRandom
{
	/// Returns a random value from anywhere in the number line.
	static func	unboundedRandom() -> Self
}

extension UniformRandom where Self: ArithmeticSummable
{
	static func random(center: Self, range: Self)
	{
		return random(center: center - range, range: center + range)
	}
}

extension UniformRandom where Self: Comparable
{
	public static func	random(_ range: ClosedRange<Self>) -> Self
	{
		assert(!range.isEmpty, "Can't find a random integer in an empty range.")
		return random(range.lowerBound, range.upperBound)
	}
}

extension UniformRandom where Self: Comparable & Strideable
{
	public static func	random(_ range: Range<Self>) -> Self
	{
		assert(!range.isEmpty, "Can't find a random integer in an empty range.")
		return random(range.lowerBound, range.upperBound.advanced(by: -1))
	}
}


public protocol GaussianRandom
{
	static func	gaussianRandom(mean: Self, deviation: Self) -> Self
}


extension Int: UnboundedUniformRandom
{
	/// Returns a random integer in [min, max].
	public static func random(_ min: Int, _ max: Int) -> Int
	{
    	assert(min <= max)
		return min + Int(arc4random_uniform(UInt32(max - min + 1)))
	}
	
	/// Returns a random integer in [Int.min, Int.max]
	public static func unboundedRandom() -> Int
	{
		return Int(Int32(bitPattern: arc4random_uniform(UInt32.max)))
	}
}


extension Double: UnboundedUniformRandom
{
	public static func	random(_ min: Double, _ max: Double) -> Double
	{
		assert(min <= max)
		return min + Double.standardRandom() * (max - min)
	}
	
	/// Returns a random value in [0, 1]
	public static func	standardRandom() -> Double
	{
		return Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
	}
	
	public static func	unboundedRandom() -> Double
	{
		return Double(Int.unboundedRandom()) + Double.standardRandom()
	}
}

extension Double: GaussianRandom
{
	fileprivate static var gaussianRandomRoots: (Double, Double, useSecond: Bool) = Double.calculateGaussianRandomRoots()
	
	fileprivate static func calculateGaussianRandomRoots() -> (Double, Double, useSecond: Bool)
	{
		var x1, x2, w, y1, y2:	Double
 
        repeat {
                x1 = 2.0 * Double.standardRandom() - 1.0;
                x2 = 2.0 * Double.standardRandom() - 1.0;
                w = x1 * x1 + x2 * x2;
        } while ( w >= 1.0 );

        w = sqrt( (-2.0 * log( w ) ) / w );
        y1 = x1 * w;
    	y2 = x2 * w;
		
		return (y1, y2, false)
	}
	
	public static func	gaussianRandom(mean: Double, deviation: Double) -> Double
	{
		let (y1, y2, useSecond) = gaussianRandomRoots
		
		if useSecond
			{ gaussianRandomRoots = calculateGaussianRandomRoots() }
		
		return (useSecond ? y2 : y1) * deviation + mean
	}
}


extension Float: UnboundedUniformRandom
{
	public static func	random(_ min: Float, _ max: Float) -> Float
	{
		assert(min <= max)
		return min + Float.standardRandom() * (max - min)
	}
	
	/// Returns a random value in [0, 1]
	public static func	standardRandom() -> Float
	{
		return Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max)
	}
	
	public static func	unboundedRandom() -> Float
	{
		return Float(Int.unboundedRandom()) + Float.standardRandom()
	}
}

extension Float: GaussianRandom
{
	fileprivate static var gaussianRandomRoots: (Float, Float, useSecond: Bool) = Float.calculateGaussianRandomRoots()
	
	fileprivate static func calculateGaussianRandomRoots() -> (Float, Float, useSecond: Bool)
	{
		var x1, x2, w, y1, y2:	Float
 
        repeat {
                x1 = 2.0 * Float.standardRandom() - 1.0;
                x2 = 2.0 * Float.standardRandom() - 1.0;
                w = x1 * x1 + x2 * x2;
        } while ( w >= 1.0 );

        w = sqrt( (-2.0 * log( w ) ) / w );
        y1 = x1 * w;
    	y2 = x2 * w;
		
		return (y1, y2, false)
	}
	
	public static func	gaussianRandom(mean: Float, deviation: Float) -> Float
	{
		let (y1, y2, useSecond) = gaussianRandomRoots
		
		if useSecond
			{ gaussianRandomRoots = calculateGaussianRandomRoots() }
		
		return (useSecond ? y2 : y1) * deviation + mean
	}
}

/*
extension CGFloat: UnboundedUniformRandom
{
	public static func	random(_ min: CGFloat, _ max: CGFloat) -> CGFloat
	{
		return CGFloat(NativeType.random(min.native, max.native))
	}
	
	/// Returns a random value in [0, 1]
	public static func	standardRandom() -> CGFloat
	{
		return CGFloat(NativeType.standardRandom())
	}
	
	public static func	unboundedRandom() -> CGFloat
	{
		return CGFloat(NativeType.unboundedRandom())
	}
}

extension CGFloat: GaussianRandom
{
	public static func	gaussianRandom(mean: CGFloat, deviation: CGFloat) -> CGFloat
	{
		return CGFloat(NativeType.gaussianRandom(mean: mean.native, deviation: deviation.native))
	}
}
*/

public extension Bool
{
	public static func random() -> Bool
	{
		let intForm = arc4random_uniform(2)
		
		return (intForm == 1)
	}
	
	public static func random(chance: Double) -> Bool
	{
		let floatForm = Double.standardRandom()
		
		return (floatForm <= chance)
	}
}


extension Collection where Self.Index: UniformRandom, Self.Index: Comparable & Strideable
{
	public func random() -> Iterator.Element
	{
		precondition(!self.isEmpty, "Can't find random element of empty array.")
		return self[Index.random(startIndex, endIndex.advanced(by: -1))]
	}
}

#endif
