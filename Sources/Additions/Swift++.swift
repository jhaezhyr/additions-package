//
//  Swift Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 12/6/14.
//  Copyright (c) 2014 Braeden Hintze. All rights reserved.
//

// MARK:  Arithmetic- Protocols

/// Requires the adding operator `+`; provides the operator `+=`.
public protocol ArithmeticAddable
{
	/// Required
	static func	+ (lh: Self, rh: Self) -> Self
	/// Provided by default
	static func += (lh: inout Self, rh: Self)
}

extension ArithmeticAddable
{
	public static func += (lh: inout Self, rh: Self)
		{ lh = lh + rh }
}

public protocol ArithmeticSummable: ArithmeticAddable
{
	static func - (lh: Self, rh: Self) -> Self
	static func	-= (lh: inout Self, rh: Self)
}

extension ArithmeticSummable
{
	public static func	-= (lh: inout Self, rh: Self)
		{ lh = lh - rh }
}

extension ArithmeticSummable where Self: ArithmeticNegatable
{
	public static func - (lh: Self, rh: Self) -> Self
		{ return lh + -rh }
}

/// Requires the negating operator `-`.
public protocol ArithmeticNegatable
{
	static prefix func - (_: Self) -> Self
}

// MARK:  ArithmeticMultipliable

/// Requires the operator `*`; provides the operator `*=`.
public protocol ArithmeticMultipliable
{
	static func	* (_: Self, _: Self) -> Self
	static func *= (lh: inout Self, rh: Self)
}

extension ArithmeticMultipliable
{
	public static func *= (lh: inout Self, rh: Self)
		{ lh = lh * rh }
}


// MARK:  ArithmeticFactorable

/// Requires the inverse (1/x) function `arithmeticInverse()`; provides the division operator `/` and the operator `/=`.
public protocol ArithmeticFactorable: ArithmeticMultipliable
{
	func arithmeticInverse() -> Self
	static func / (lh: Self, rh: Self) -> Self
	static func /= (lh: inout Self, rh: Self)
}

extension ArithmeticFactorable
{
	public static func / (lh: Self, rh: Self) -> Self
		{ return lh * rh.arithmeticInverse() }
	public static func /= (lh: inout Self, rh: Self)
		{ lh = lh / rh }
}


// MARK:  ArithmeticValue

public protocol ArithmeticValue: ArithmeticSummable, ArithmeticFactorable, ArithmeticScalable
	{ }


// MARK:  ArithmeticScalable

public protocol ArithmeticScalable
{
	associatedtype ArithmeticScalar: NumberType
	static func * (_: Self, _: ArithmeticScalar) -> Self
	/// Provided by default.  The default assumes that rh can be inverted by `(1 / rh)`, and returns `(lh * (1 / rh))`.
	static func / (_: Self, _: ArithmeticScalar) -> Self
	static func *= (lh: inout Self, rh: ArithmeticScalar)
	static func /= (lh: inout Self, rh: ArithmeticScalar)
}

extension ArithmeticScalable
{
	public static func / (lh: Self, rh: ArithmeticScalar) -> Self
		{ return lh * (1 / rh) }
	public static func *= (lh: inout Self, rh: ArithmeticScalar)
		{ lh = lh * rh }
	public static func /= (lh: inout Self, rh: ArithmeticScalar)
		{ lh = lh / rh }
	
/*	public static func * <N: NumberType>(lh: Self, rh: N) -> Self
		{ return lh * ArithmeticScalar.fromDouble(N.toDouble(rh)) }
	public static func / <N: NumberType>(lh: Self, rh: N) -> Self
		{ return lh * (1 / ArithmeticScalar.fromDouble(N.toDouble(rh))) }
	public static func *= <N: NumberType>(lh: inout Self, rh: N)
		{ lh = lh * ArithmeticScalar.fromDouble(N.toDouble(rh)) }
	public static func /= <N: NumberType>(lh: inout Self, rh: N)
		{ lh = lh / ArithmeticScalar.fromDouble(N.toDouble(rh)) }*/
}


// MARK:  ArithmeticShiftable

/// Given `+(Self,Double)`, provides shifting functions for `Int`, `Float`, and `Double`.
public protocol ArithmeticShiftable
{
	associatedtype ArithmeticShift: NumberType
	static func + (lh: Self, rh: ArithmeticShift) -> Self
	static func - (lh: Self, rh: ArithmeticShift) -> Self
	static func += (lh: inout Self, rh: ArithmeticShift)
	static func -= (lh: inout Self, rh: ArithmeticShift)
}

extension ArithmeticShiftable
{
	public static func - (lh: Self, rh: ArithmeticShift) -> Self
		{ return lh + -rh }
	public static func += (lh: inout Self, rh: ArithmeticShift)
		{ lh = lh + rh }
	public static func -= (lh: inout Self, rh: ArithmeticShift)
		{ lh = lh - rh }
	
/*	public static func + <N: NumberType>(lh: Self, rh: N) -> Self
		{ return lh + ArithmeticShift.fromDouble(N.toDouble(rh)) }
	public static func - <N: NumberType>(lh: Self, rh: N) -> Self
		{ return lh + -ArithmeticShift.fromDouble(N.toDouble(rh)) }
	public static func += <N: NumberType>(lh: inout Self, rh: N)
		{ lh = lh + ArithmeticShift.fromDouble(N.toDouble(rh)) }
	public static func -= <N: NumberType>(lh: inout Self, rh: N)
		{ lh = lh - ArithmeticShift.fromDouble(N.toDouble(rh)) }*/
}


// MARK:  NumberType

public protocol NumberType: ExpressibleByIntegerLiteral
{
	static func fromDouble(_ double: Double) -> Self
	static func toDouble(_ x: Self) -> Double
	static func / (lh: Self, rh: Self) -> Self
	static prefix func - (x: Self) -> Self
}

public func numericCast<T: NumberType, U: NumberType>(_ original: T) -> U
	{ return U.fromDouble(T.toDouble(original)) }


// MARK:  FloatMathematical

/// Ensures that certain exponential and trigonometric functions are available on the type.
public protocol FloatMathematical: FloatingPoint
{
	static func exp(_ x: Self) -> Self
	static func log(_ x: Self) -> Self
	static func sin(_ x: Self) -> Self
	static func cos(_ x: Self) -> Self
	static func tan(_ x: Self) -> Self
	static func asin(_ x: Self) -> Self
	static func acos(_ x: Self) -> Self
	static func atan(_ x: Self) -> Self
	static func sinh(_ x: Self) -> Self
	static func cosh(_ x: Self) -> Self
	static func tanh(_ x: Self) -> Self
	static func asinh(_ x: Self) -> Self
	static func acosh(_ x: Self) -> Self
	static func atanh(_ x: Self) -> Self
	static func pow(_ lh: Self, _ rh: Self) -> Self
}

public func exp<T: FloatMathematical>(_ x: T) -> T
	{ return T.exp(x) }
public func log<T: FloatMathematical>(_ x: T) -> T
	{ return T.log(x) }
public func sin<T: FloatMathematical>(_ x: T) -> T
	{ return T.sin(x) }
public func cos<T: FloatMathematical>(_ x: T) -> T
	{ return T.cos(x) }
public func tan<T: FloatMathematical>(_ x: T) -> T
	{ return T.tan(x) }
public func asin<T: FloatMathematical>(_ x: T) -> T
	{ return T.asin(x) }
public func acos<T: FloatMathematical>(_ x: T) -> T
	{ return T.acos(x) }
public func atan<T: FloatMathematical>(_ x: T) -> T
	{ return T.atan(x) }
public func sinh<T: FloatMathematical>(_ x: T) -> T
	{ return T.sinh(x) }
public func cosh<T: FloatMathematical>(_ x: T) -> T
	{ return T.cosh(x) }
public func tanh<T: FloatMathematical>(_ x: T) -> T
	{ return T.tanh(x) }
public func asinh<T: FloatMathematical>(_ x: T) -> T
	{ return T.asinh(x) }
public func acosh<T: FloatMathematical>(_ x: T) -> T
	{ return T.acosh(x) }
public func atanh<T: FloatMathematical>(_ x: T) -> T
	{ return T.atanh(x) }
public func pow<T: FloatMathematical>(_ lh: T, _ rh: T) -> T
	{ return T.pow(lh, rh) }

#if canImport(Darwin)
import Darwin
extension Double: FloatMathematical
{
	public static func exp(_ x: Double) -> Double
		{ return exp(x) }
	public static func log(_ x: Double) -> Double
		{ return Darwin.log(x) }
	public static func sin(_ x: Double) -> Double
		{ return Darwin.sin(x) }
	public static func cos(_ x: Double) -> Double
		{ return Darwin.cos(x) }
	public static func tan(_ x: Double) -> Double
		{ return Darwin.tan(x) }
	public static func asin(_ x: Double) -> Double
		{ return Darwin.asin(x) }
	public static func acos(_ x: Double) -> Double
		{ return Darwin.acos(x) }
	public static func atan(_ x: Double) -> Double
		{ return Darwin.atan(x) }
	public static func sinh(_ x: Double) -> Double
		{ return Darwin.sinh(x) }
	public static func cosh(_ x: Double) -> Double
		{ return Darwin.cosh(x) }
	public static func tanh(_ x: Double) -> Double
		{ return Darwin.tanh(x) }
	public static func asinh(_ x: Double) -> Double
		{ return Darwin.asinh(x) }
	public static func acosh(_ x: Double) -> Double
		{ return Darwin.acosh(x) }
	public static func atanh(_ x: Double) -> Double
		{ return Darwin.atanh(x) }
	public static func pow(_ lh: Double, _ rh: Double) -> Double
		{ return Darwin.pow(lh, rh) }
}

extension Float: FloatMathematical
{
	public static func exp(_ x: Float) -> Float
		{ return Darwin.exp(x) }
	public static func log(_ x: Float) -> Float
		{ return Darwin.log(x) }
	public static func sin(_ x: Float) -> Float
		{ return Darwin.sin(x) }
	public static func cos(_ x: Float) -> Float
		{ return Darwin.cos(x) }
	public static func tan(_ x: Float) -> Float
		{ return Darwin.tan(x) }
	public static func asin(_ x: Float) -> Float
		{ return Darwin.asin(x) }
	public static func acos(_ x: Float) -> Float
		{ return Darwin.acos(x) }
	public static func atan(_ x: Float) -> Float
		{ return Darwin.atan(x) }
	public static func sinh(_ x: Float) -> Float
		{ return Darwin.sinh(x) }
	public static func cosh(_ x: Float) -> Float
		{ return Darwin.cosh(x) }
	public static func tanh(_ x: Float) -> Float
		{ return Darwin.tanh(x) }
	public static func asinh(_ x: Float) -> Float
		{ return Darwin.asinh(x) }
	public static func acosh(_ x: Float) -> Float
		{ return Darwin.acosh(x) }
	public static func atanh(_ x: Float) -> Float
		{ return Darwin.atanh(x) }
	public static func pow(_ lh: Float, _ rh: Float) -> Float
		{ return Darwin.pow(lh, rh) }
}
#elseif canImport(Glibc)
import Glibc
extension Double: FloatMathematical
{
	public static func exp(_ x: Double) -> Double
		{ return Glibc.exp(x) }
	public static func log(_ x: Double) -> Double
		{ return Glibc.log(x) }
	public static func sin(_ x: Double) -> Double
		{ return Glibc.sin(x) }
	public static func cos(_ x: Double) -> Double
		{ return Glibc.cos(x) }
	public static func tan(_ x: Double) -> Double
		{ return Glibc.tan(x) }
	public static func asin(_ x: Double) -> Double
		{ return Glibc.asin(x) }
	public static func acos(_ x: Double) -> Double
		{ return Glibc.acos(x) }
	public static func atan(_ x: Double) -> Double
		{ return Glibc.atan(x) }
	public static func sinh(_ x: Double) -> Double
		{ return Glibc.sinh(x) }
	public static func cosh(_ x: Double) -> Double
		{ return Glibc.cosh(x) }
	public static func tanh(_ x: Double) -> Double
		{ return Glibc.tanh(x) }
	public static func asinh(_ x: Double) -> Double
		{ return Glibc.asinh(x) }
	public static func acosh(_ x: Double) -> Double
		{ return Glibc.acosh(x) }
	public static func atanh(_ x: Double) -> Double
		{ return Glibc.atanh(x) }
	public static func pow(_ lh: Double, _ rh: Double) -> Double
		{ return Glibc.pow(lh, rh) }
}

extension Float: FloatMathematical
{
	public static func exp(_ x: Float) -> Float
		{ return Glibc.exp(x) }
	public static func log(_ x: Float) -> Float
		{ return Glibc.log(x) }
	public static func sin(_ x: Float) -> Float
		{ return Glibc.sin(x) }
	public static func cos(_ x: Float) -> Float
		{ return Glibc.cos(x) }
	public static func tan(_ x: Float) -> Float
		{ return Glibc.tan(x) }
	public static func asin(_ x: Float) -> Float
		{ return Glibc.asin(x) }
	public static func acos(_ x: Float) -> Float
		{ return Glibc.acos(x) }
	public static func atan(_ x: Float) -> Float
		{ return Glibc.atan(x) }
	public static func sinh(_ x: Float) -> Float
		{ return Glibc.sinh(x) }
	public static func cosh(_ x: Float) -> Float
		{ return Glibc.cosh(x) }
	public static func tanh(_ x: Float) -> Float
		{ return Glibc.tanh(x) }
	public static func asinh(_ x: Float) -> Float
		{ return Glibc.asinh(x) }
	public static func acosh(_ x: Float) -> Float
		{ return Glibc.acosh(x) }
	public static func atanh(_ x: Float) -> Float
		{ return Glibc.atanh(x) }
	public static func pow(_ lh: Float, _ rh: Float) -> Float
		{ return Glibc.pow(lh, rh) }
}
#endif
/*
extension CGFloat: FloatMathematical
{
	public static func exp(_ x: CGFloat) -> CGFloat
		{ return exp(x) }
	public static func log(_ x: CGFloat) -> CGFloat
		{ return log(x) }
	public static func sin(_ x: CGFloat) -> CGFloat
		{ return sin(x) }
	public static func cos(_ x: CGFloat) -> CGFloat
		{ return cos(x) }
	public static func tan(_ x: CGFloat) -> CGFloat
		{ return tan(x) }
	public static func asin(_ x: CGFloat) -> CGFloat
		{ return asin(x) }
	public static func acos(_ x: CGFloat) -> CGFloat
		{ return acos(x) }
	public static func atan(_ x: CGFloat) -> CGFloat
		{ return atan(x) }
	public static func sinh(_ x: CGFloat) -> CGFloat
		{ return sinh(x) }
	public static func cosh(_ x: CGFloat) -> CGFloat
		{ return cosh(x) }
	public static func tanh(_ x: CGFloat) -> CGFloat
		{ return tanh(x) }
	public static func asinh(_ x: CGFloat) -> CGFloat
		{ return asinh(x) }
	public static func acosh(_ x: CGFloat) -> CGFloat
		{ return acosh(x) }
	public static func atanh(_ x: CGFloat) -> CGFloat
		{ return atanh(x) }
	public static func pow(_ lh: CGFloat, _ rh: CGFloat) -> CGFloat
		{ return CGFloat(Darwin.pow(lh.native, rh.native)) }

}
*/

/*
extension Int: NumberType
{
	public static func fromDouble(_ double: Double) -> Int
		{ return Int(exactly: double)! }
	public static func toDouble(_ x: Int) -> Double
		{ return Double(x) }
}*/

extension Float: NumberType
{
	public static func fromDouble(_ double: Double) -> Float
		{ return Float(double) }
	public static func toDouble(_ x: Float) -> Double
		{ return Double(x) }
}

extension Double: NumberType
{
	public static func fromDouble(_ double: Double) -> Double
		{ return double }
	public static func toDouble(_ x: Double) -> Double
		{ return x }
}
/*
extension CGFloat: NumberType
{
	public static func fromDouble(_ double: Double) -> CGFloat
		{ return CGFloat(double) }
	public static func toDouble(_ x: CGFloat) -> Double
		{ return Double(x) }
}
*/

// MARK:  - High-Order functions

/// Wraps up a recursive closure (or function) in another function.  The `body` takes a reference to the result and a calculation parameter.  The result of `memoize` is a function that can be called to calculate a value, and the result of the calculations is stored in a cache.
/// Example:
/// 
public func memoize <T: Hashable, U> (_ body: @escaping ((T)->U, T)->U) -> (T)->U
{
    var memo: [T:U]			= [:]
    var result: ((T)->U)!	= nil
	
	result =
	{
		x in
		
        if let q = memo[x]
		{
			return q
		}
        else
		{
			let r = body(result, x)
	        memo[x] = r
		
    	    return r
		}
    }
	
    return result
}

let fibonacci = memoize
{
	fib, x in
	
	return (x < 2) ? x : fib(x - 1) + fib(x - 2)
}


/// Returns `candidate` iff `condition() == true`, and `nil` otherwise.
public func check<T>(_ candidate: T, condition: (T) throws -> Bool) rethrows -> T?
{
    return try condition(candidate) ? candidate : nil
}


/// Calls `algorithm` repeatedly, returning the first non-nil result.
public func    generateWith<T>(algorithm: () -> T?) -> T
{
    var result: T?
    
    repeat
    {
        result = algorithm()
    }
    while result == nil
    
    return result!
}


// MARK:  - Operators

infix operator ^^: LogicalDisjunctionPrecedence// { associativity left precedence 110 }
/// Logic XOR to accomadate || and &&.
public func	^^ (lhs: Bool, rhs: Bool) -> Bool
{
	return ((lhs || rhs) && !(lhs && rhs))
}


infix operator <>: ComparisonPrecedence //{ associativity left precedence 137 }
infix operator ><: ComparisonPrecedence // { associativity left precedence 137 }
extension Comparable
{
	/// This is the minimum operator.  Between many values, it evaluates to the smallest of them.
	static public func <> (lhs: Self, rhs: Self) -> Self
	{
		return (lhs < rhs ? lhs : rhs)
	}
	/// This is the maximum operator.  Between many values, it evaluates to the largest of them.
	static public func >< (lhs: Self, rhs: Self) -> Self
	{
		return (lhs > rhs ? lhs : rhs)
	}
}



infix operator ??=: AssignmentPrecedence // { assignment }
/// This is the fill operator.  If `lh` is nil, assigns `lh = rh`.  If `lh` is non-nil, this has *no* effect.
public func	??= <T> (lh: inout T?, rh: @autoclosure () -> T?)
{
	if (lh == nil)
		{ lh = rh() }
}


infix operator !≈: ComparisonPrecedence// { associativity none precedence 130 }
infix operator ≈≈: ComparisonPrecedence// { associativity none precedence 130 }
infix operator <!≈: ComparisonPrecedence// { associativity none precedence 130 }
infix operator >!≈: ComparisonPrecedence// { associativity none precedence 130 }
infix operator >≈: ComparisonPrecedence// { associativity none precedence 130 }
infix operator <≈: ComparisonPrecedence// { associativity none precedence 130 }

infix operator **: BitwiseShiftPrecedence// { associativity right precedence 160 }
/// Power operator
public func ** (base: Double, exponent: Double) -> Double
	{ return pow(base, exponent) }
/// Power operator
/*public func ** (base: CGFloat, exponent: CGFloat) -> CGFloat
	{ return pow(base, exponent) }*/
/// Power operator
public func ** (base: Float, exponent: Float) -> Float
	{ return pow(base, exponent) }
/// Power operator
public func ** (base: Double, exponent: Int) -> Double
	{ return pow(base, Double(exponent)) }
/// Power operator
/*public func ** (base: CGFloat, exponent: Int) -> CGFloat
	{ return pow(base, CGFloat(exponent)) }*/
/// Power operator
public func ** (base: Float, exponent: Int) -> Float
	{ return pow(base, Float(exponent)) }
/*
postfix operator *
public postfix func * <T> (x: UnsafePointer<T>) -> T
	{ return x.pointee }
public postfix func * <T> (x: UnsafeMutablePointer<T>) -> T
	{ return x.pointee }
*/


// MARK:  - ApproximatelyEquatable

public protocol ApproximatelyEquatable
{
	/// This is the "approximately equal" operator.  For floating point types, equality is rarely measured by actual data equivalence.  Instead, a tolerance is maintained.  This operator approximates equality using a default tolerance.  If necessary, the global tolerance can be *temporarily* altered for a more accurate fit.
	static func ≈≈ (_ lh: Self, _ rh: Self) -> Bool
	static func !≈ (_ lh: Self, _ rh: Self) -> Bool
}

extension ApproximatelyEquatable
{
	public static func !≈ (_ lh: Self, _ rh: Self) -> Bool
		{ return !(lh ≈≈ rh) }
}

extension ApproximatelyEquatable where Self: Comparable
{
	public static func <!≈ (_ lh: Self, _ rh: Self) -> Bool
		{ return (lh < rh) && (lh !≈ rh) }
	public static func >!≈ (_ lh: Self, _ rh: Self) -> Bool
		{ return (lh > rh) && (lh !≈ rh) }
	public static func <≈ (_ lh: Self, _ rh: Self) -> Bool
		{ return (lh < rh) || (lh ≈≈ rh) }
	public static func >≈ (_ lh: Self, _ rh: Self) -> Bool
		{ return (lh > rh) || (lh ≈≈ rh) }
}

extension Double: ApproximatelyEquatable
{
	static public func ≈≈ (lh: Double, rh: Double) -> Bool
	{
		return (abs(lh - rh) < Double.equalityTolerance)
	}
}
extension Float: ApproximatelyEquatable
{
	public static func ≈≈ (lh: Float, rh: Float) -> Bool
	{
		return (abs(lh - rh) < Float.equalityTolerance)
	}
}/*
extension CGFloat : ApproximatelyEquatable
{
	public static func ≈≈ (lh: CGFloat, rh: CGFloat) -> Bool
	{
		return (abs(lh - rh) < CGFloat.equalityTolerance)
	}
}*/


// MARK:  - Weak/Unowned Wrappers

final public class Object<T>
{
	public var value: T
	public init(_ t: T)
		{ value = t }
}

public struct Weak<T: AnyObject>
{
	public weak var value:		T?
	public init(_ t: T?)
		{ value = t }
}

public struct Unowned<T: AnyObject>
{
	public unowned var value:	T
	public init(_ t: T)
		{ value = t }
}

extension Array where Element: AnyObject
{
	public var weak: [Weak<Element>]
		{ return map { Weak($0) } }
	public var unowned: [Unowned<Element>]
		{ return map { Unowned($0) } }
}


// MARK:  - Optional Extensions

public struct OptionalNilError: Error { public init() {  } }

extension Optional
{
	public func unwrap() throws -> Wrapped
	{
		if let result = self
			{ return result }
		else
			{ throw OptionalNilError() }
	}
}

