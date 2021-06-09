//
//  Angle.swift
//  Game Kit
//
//  Created by Braeden Hintze on 6/24/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//


public let π:	Angle		= 3.141592653589793238462643383
//public let π:	Angle.Raw	= π.radians

#if false

public typealias Angle = Double

#else
postfix operator °


/// A struct representing an angle by wrapping its radian value (a `Double`).  Provides calculations and initializations appropriate to an angle, such as degrees and radians, reference angle, and the angle between intervals like [0, 2π) and (-π, π].
public struct Angle: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible, Hashable, Comparable, ArithmeticSummable, ArithmeticNegatable, ArithmeticScalable, Codable// , SignedNumeric
{
	public typealias ArithmeticScalar = Double
	
	public typealias Raw = Double
	public var radians:	Raw
	
	public var degrees:	Raw
	{
		get { return radians * 180 / π.radians }
		mutating set { radians = newValue * π.radians / 180 }
	}
	
	/// The angle's representation in degrees (°), minutes ('), and seconds(").  There are 60" in 1', and 60' in 1°.
	public var nauticalAngle:	(degrees: Int, minutes: Int, seconds: Raw)
	{
		get
		{
			var totalSeconds	= degrees * 60 * 60
			let givenDegrees	= totalSeconds.truncatingRemainder(dividingBy: (60 * 60)).rounded(.down)
      totalSeconds -= givenDegrees * (60 * 60)
			let givenMinutes	= totalSeconds.truncatingRemainder(dividingBy: 60).rounded(.down)
      totalSeconds -= givenMinutes * 60
			
			return (Int(givenDegrees), Int(givenMinutes), totalSeconds)
		}
		set
		{
			degrees = Raw(newValue.degrees) + Raw(newValue.minutes) / 60 + newValue.seconds / (60 * 60)
		}
	}
	
	// TODO: Document
	public var reference:	Angle
	{
		get
		{
			let πI = Angle.abs(piInterval)
			
			if (πI < π/2)
				{ return πI }
			else
				{ return π + -πI }
		}
		mutating set
		{
			switch quadrant
			{
				case 1, 3:
					radians += newValue.radians - reference.radians
				case 2, 4:
					radians += reference.radians - newValue.radians
				default:
					break
			}
		}
	}
	
	
	/// A co-terminal angle in the interval [0, 2π).
	///
	/// Disclaimer, results of 2π happen occasionally.
	public var twoPiInterval:	Angle
	{
		if (radians < 0.0)
			{ return 2*π - (-self).truncatingRemainder(dividingBy: 2*π) }
		else
			{ return self.truncatingRemainder(dividingBy: 2*π) }
	
	}
	
	/// A co-terminal angle in the interval (-π, π].
	///
	/// Disclaimer, results of -π happen occasionally.
	public var piInterval:	Angle
	{
		let _2π = twoPiInterval
		
		if _2π > π
		{
			return _2π + -2 * π
		}
		else // if _2π > 0
		{
			return _2π
		}
	}
	
	// TODO: Test and document
	public var quadrant:	Int
	{
		let _2π	= twoPiInterval
		
		if (_2π < π/2)
			{ return 1 }
		else if (_2π < π)
			{ return 2 }
		else if (_2π < 3*π/2)
			{ return 3 }
		else
			{ return 4 }
	}
	
	// MARK:  Init
	
	public init()
		{ radians = 0 }
	public init(_ angle: Angle)
		{ radians = angle.radians }
	/*
	public init(_ Angle.Raw: Angle.Raw)
		{ radians = Raw(Angle.Raw) }
	*/
	public init(_ double: Double)
		{ radians = Raw(double) }
	
	public init(_ float: Float)
		{ radians = Raw(float) }
	
	public init(degrees: Angle)
		{ radians = degrees.radians * π.radians / 180 }
	/*
	public init(degrees: Angle.Raw)
		{ radians = Raw(degrees) * π.radians / 180 }
	*/
	public init(degrees: Double)
		{ radians = Raw(degrees) * π.radians / 180 }
	
	public init(degrees: Float)
		{ radians = Raw(degrees) * π.radians / 180 }
	/*
	public init(facing: CGPoint)
	{
		let raw = atan(facing.y / facing.x) as Angle.Raw
		
		if (facing.x < 0)
			{ radians = raw + (π/2).radians.signed(raw.sign) }
		else
			{ radians = raw }
	}*/
	
	// MARK: Random
	
#if swift(>=4.2)
	public static func random(center: Angle, range: Angle) -> Angle
	{
		return Angle(Raw.random(in: center.radians - range.radians ..< center.radians + range.radians))
	}
	
	public static func	random(_ low: Angle, _ high: Angle) -> Angle
	{
		return Angle(Raw.random(in: low.radians ..< high.radians))
	}
	
	/// Returns a random Angle in [0, 2π).
	public static func	randomInPiInterval() -> Angle
	{
		return Angle(Raw.random(in: -π.radians ..< π.radians))
	}
	
	/// Returns a random Angle in (-π, π].
	public static func	randomInTwoPiInterval() -> Angle
	{
		return Angle(Raw.random(in: 0 ..< 2 * π.radians))
	}
	
	/// Returns a random Angle within [0, 2π).
	public static func random() -> Angle
	{
		return randomInTwoPiInterval()
	}

#else

	public static func	random(center: Angle, range: Angle) -> Angle
	{
		return Angle(Raw.random(center.radians - range.radians, center.radians + range.radians))
	}
	
	public static func	random(_ low: Angle, _ high: Angle) -> Angle
	{
		return Angle(Raw.random(low.radians, high.radians))
	}
	
	
	public static func	gaussianRandom(mean: Angle, deviation: Angle) -> Angle
	{
		return Angle(Raw.gaussianRandom(mean: mean.radians, deviation: deviation.radians))
	}
	
	/// Returns a random Angle in [0, 2π).
	public static func	randomInPiInterval() -> Angle
	{
		return Angle(Raw.random(-π.radians, π.radians))
	}
	
	/// Returns a random Angle in (-π, π].
	public static func	randomInTwoPiInterval() -> Angle
	{
		return Angle(Raw.random(0, 2 * π.radians))
	}
	
	/// Returns a random Angle within [0, 2π).
	public static func	random() -> Angle
	{
		return randomInTwoPiInterval()
	}
#endif

	/// Finds the interior angle between `angle1` and `angle2`.
	public func	betweenAngles(_ angle1: Angle, _ angle2: Angle) -> Angle
	{
		let twoπ = π * 2.0
		var angle = (angle2 + -angle1).twoPiInterval
		
		if (angle >= π)
			{ angle = angle + -twoπ }
		
		if (angle <= -π)
			{ angle = angle + -twoπ }
		
		return angle
	}
	/*
	/// Finds the interior angle between vectors `v1` and `v2`.
	public static func	betweenVectors(_ lh: CGPoint, _ rh: CGPoint) -> Angle
	{
		var v1 = lh
		var v2 = rh
		if (v1.length ≈≈ 1)
			{ v1.length = 1 }
		if (v2.length ≈≈ 1)
			{ v2.length = 1 }
		
		let cosine = v1.x*v2.x + v1.y*v2.y
		return acos(cosine)
	}
	*/
	
	// MARK:  More Angle Calculation
	
	/// Rotates the angle by `angle` and returns `reference`.
	/// Examples:
	/// 	50°.referenceAgainstAngle(20°) == 30°
	/// 	90°.referenceAgainstAngle(170°) == 80°
	/// 	10°.referenceAgainstAngle(90°) == 80°
	public func referenceAgainstAngle(_ angle: Angle) -> Angle
	{
		return Angle.abs(reference - angle.reference)
	}
	
	
	public mutating func	alterReferenceAgainstAngle(_ angle: Angle, to ref: Angle)
	{
	//	let myRef		= reference
	//	let otherRef	= angle.reference
		var relative	= self - angle
		
		relative.reference = ref
		
		self = relative + angle
	}
}




extension Angle: ApproximatelyEquatable
{
	public static func ≈≈ (lhs: Angle, rhs: Angle) -> Bool
		{ return lhs.radians ≈≈ rhs.radians }
}

extension Angle {
	public static var leastNormalMagnitude: Angle { return Angle(Raw.leastNormalMagnitude) }
	public static var greatestFiniteMagnitude: Angle { return Angle(Raw.greatestFiniteMagnitude) }
}

extension Angle {

	/// A textual representation of `Angle`.
	public var description: String { return "\(degrees)°" }
}

extension Angle {
	public func hash(into hasher: inout Hasher)
    { self.radians.hash(into: &hasher) }
}

extension Angle
{
	/// Create an instance initialized to `value`.
	public init(floatLiteral value: Double)
		{ radians = Raw(value) }
}

extension Angle
{
	/// Create an instance initialized to `value`.
	public init(integerLiteral value: Int)
		{ radians = Raw(value) }
}

extension Angle
{
	/// Returns the absolute value of `x`
	public static func abs(_ x: Angle) -> Angle
		{ return Angle((Swift.abs as (Angle.Raw) -> Angle.Raw)(x.radians)) }
}

extension Angle//: Strideable
{
	public typealias Stride = Angle
	
	/// Returns a stride `x` such that `Angle.advancedBy(x)` approximates
	/// `other`.
	///
	/// Complexity: O(1).
	public func distance(to other: Angle) -> Angle.Stride
		{ return Angle(radians.distance(to: other.radians)) }
	

	/// Returns a `Angle` `x` such that `Angle.distanceTo(x)` approximates
	/// `n`.
	///
	/// Complexity: O(1).
	public func advanced(by amount: Angle) -> Angle
		{ return Angle(radians.advanced(by: amount.radians)) }
}


public func sin(_ x: Angle) -> Angle.Raw		{ return sin(x.radians) }
public func sinh(_ x: Angle) -> Angle.Raw		{ return sinh(x.radians) }
public func cos(_ x: Angle) -> Angle.Raw		{ return cos(x.radians) }
public func cosh(_ x: Angle) -> Angle.Raw		{ return cosh(x.radians) }
public func tan(_ x: Angle) -> Angle.Raw		{ return tan(x.radians) }
public func tanh(_ x: Angle) -> Angle.Raw		{ return tanh(x.radians) }
/*
public func	asin(_ x: Angle.Raw) -> Angle		{ return Angle(asin(x) as Angle.Raw) }
public func	asinh(_ x: Angle.Raw) -> Angle	{ return Angle(asinh(x) as Angle.Raw) }
public func	acos(_ x: Angle.Raw) -> Angle		{ return Angle(acos(x) as Angle.Raw) }
public func	acosh(_ x: Angle.Raw) -> Angle	{ return Angle(acosh(x) as Angle.Raw) }
public func	atan(_ x: Angle.Raw) -> Angle		{ return Angle(atan(x) as Angle.Raw) }
public func	atanh(_ x: Angle.Raw) -> Angle	{ return Angle(atanh(x) as Angle.Raw) }
*/
//public func fabs(_ x: Angle) -> Angle					{ return Angle(fabs(x.radians)) }
//public func fma(_ x: Angle, y: Angle, z: Angle) -> Angle	{ return Angle(fma(x.radians, y.radians, z.radians)) }
//public func fmax(_ lhs: Angle, rhs: Angle) -> Angle	{ return Angle(fmax(lhs.radians, rhs.radians)) }
//public func fmin(_ lhs: Angle, rhs: Angle) -> Angle	{ return Angle(fmin(lhs.radians, rhs.radians)) }
//public func fmod(_ lhs: Angle, rhs: Angle) -> Angle	{ return Angle(fmod(lhs.radians, rhs.radians)) }
//public func fpclassify(_ x: Angle) -> Int				{ return fpclassify(x.radians.floatingPointClass) }

/*public func frexp(_ x: Angle) -> (Angle, Int)
{
	let both = frexp(x.radians)
	return (Angle(both.0), both.1)
}*/

//public func ilogb(_ x: Angle) -> Int		{ return ilogb(x.radians) }
//public func isfinite(_ x: Angle) -> Bool	{ return isfinite(x.radians) }
//public func isinf(_ x: Angle) -> Bool		{ return isinf(x.radians) }
//public func isnan(_ x: Angle) -> Bool		{ return isnan(x.radians) }
//public func isnormal(_ x: Angle) -> Bool	{ return isnormal(x.radians) }
/*public func j0(_ x: Angle) -> Angle		{ return Angle(j0(x.radians)) }
public func j1(_ x: Angle) -> Angle		{ return Angle(j1(x.radians)) }
public func jn(_ n: Int, x: Angle) -> Angle	{ return Angle(jn(n, x.radians)) }
public func ldexp(_ x: Angle, n: Int) -> Angle	{ return Angle(ldexp(x.radians, n)) }

public func lgamma(_ x: Angle) -> (Angle, Int)
{
	let both = lgamma(x.radians)
	return (Angle(both.0), both.1)
}

public func log(_ x: Angle) -> Angle		{ return Angle(log(x.radians)) }
public func log10(_ x: Angle) -> Angle	{ return Angle(log10(x.radians)) }
public func log1p(_ x: Angle) -> Angle	{ return Angle(log1p(x.radians)) }
public func log2(_ x: Angle) -> Angle		{ return Angle(log2(x.radians)) }
public func logb(_ x: Angle) -> Angle		{ return Angle(logb(x.radians)) }
public func modf(_ x: Angle) -> (Angle, Angle)
{
	let both = lgamma(x.radians)
	return (Angle(both.0), Angle(both.1))
}

public func nan(_ tag: String) -> Angle					{ return nan(tag) }
public func nearbyint(_ x: Angle) -> Angle				{ return Angle(nearbyint(x.radians)) }
public func nextafter(_ lhs: Angle, rhs: Angle) -> Angle	{ return Angle(nextafter(lhs.radians, rhs.radians)) }
public func pow(_ lhs: Angle, rhs: Angle) -> Angle		{ return Angle(pow(lhs.radians, rhs.radians)) }
public func remainder(_ lhs: Angle, rhs: Angle) -> Angle	{ return Angle(remainder(lhs.radians, rhs.radians)) }

public func remquo(_ x: Angle, y: Angle) -> (Angle, Int)
{
	let both = remquo(x.radians, y.radians)
	return (Angle(both.0), both.1)
}

public func rint(_ x: Angle) -> Angle				{ return Angle(rint(x.radians)) }
public func round(_ x: Angle) -> Angle			{ return Angle(round(x.radians)) }
public func scalbn(_ x: Angle, n: Int) -> Angle	{ return Angle(scalbn(x.radians, n)) }
//public func signbit(_ x: Angle) -> Int			{ return signbit(x.radians) }

public func sqrt(_ x: Angle) -> Angle				{ return Angle(sqrt(x.radians)) }

public func tgamma(_ x: Angle) -> Angle			{ return Angle(tgamma(x.radians)) }
public func trunc(_ x: Angle) -> Angle			{ return Angle(trunc(x.radians)) }
public func y0(_ x: Angle) -> Angle				{ return Angle(y0(x.radians)) }
public func y1(_ x: Angle) -> Angle				{ return Angle(y1(x.radians)) }
public func yn(_ n: Int, x: Angle) -> Angle		{ return Angle(yn(n, x.radians)) }
*/

// MARK:  - Basic Operations

public func	== (lh: Angle, rh: Angle) -> Bool	{ return lh.radians == rh.radians }
public func	< (lh: Angle, rh: Angle) -> Bool	{ return lh.radians < rh.radians }
public func + (lh: Angle, rh: Angle) -> Angle	{ return Angle(lh.radians + rh.radians) }
public func * (lh: Angle, rh: Angle) -> Angle	{ return Angle(lh.radians * rh.radians) }
public prefix func - (a: Angle) -> Angle		{ return Angle(-a.radians) }

public func - (lh: Angle, rh: Angle) -> Angle	{ return Angle(lh.radians - rh.radians) }
public func	* (lh: Angle, rh: Double) -> Angle	{ return Angle(lh.radians * rh) }

public func	% (lh: Angle, rh: Angle) -> Angle
{
	let result = lh.radians.truncatingRemainder(dividingBy: rh.radians)
	
	if (result < 0)
		{ return Angle(result + rh.radians) }
	else
		{ return Angle(result) }
}

extension Angle
{
	public func	arithmeticInverse() -> Angle
		{ return Angle(1 / radians) }
}

//public func	%= (lh: inout Angle, rh: Angle)		{ return lh = lh % rh }


// MARK:  - Glue to Existing Types

/*
public extension Angle.Raw
{
	public init(_ angle: Angle)
		{ self.init(angle.radians) }
}*/

extension Float
{
	public init(_ angle: Angle)
		{ self.init(angle.radians) }
}

extension Double
{
	public init(_ angle: Angle)
		{ self.init(angle.radians) }
}


// MARK:  - Angle Conversion

/// `°`, produced with option-shift-8, converts a value into an angle using degrees.  Example:  `90° == Angle(degrees: 90)`.
public postfix func ° (x: Angle.Raw) -> Angle
{
	return Angle(degrees: x)
}
#endif

public func		degree(from radian: Double) -> Double
{
	return radian * 180.0 / .pi
}

public func		degree(from radian: Float) -> Float
{
	return radian * 180.0 / .pi
}
/*
public func		degree(from radian: Angle.Raw) -> Angle.Raw
{
	return radian * 180.0 / .pi
}
*/
public func		radian(from degree: Double) -> Double
{
	return degree * .pi / 180
}

public func		radian(from degree: Float) -> Float
{
	return degree * .pi / 180
}
/*
public func		radian(from degree: Angle.Raw) -> Angle.Raw
{
	return degree * .pi / 180
}*/

public func		radian(from degree: Int) -> Double
{
	return Double(degree) * .pi / 180
}



extension Angle//: FloatingPoint
{
	/// A type that can represent any written exponent.
    public typealias Exponent = Raw.Exponent

    /// Creates a new value from the given sign, exponent, and significand.
    ///
    /// The following example uses this initializer to create a new `Double`
    /// instance. `Double` is a binary floating-point type that has a radix of
    /// `2`.
    ///
    ///     let x = Double(sign: .plus, exponent: -2, significand: 1.5)
    ///     // x == 0.375
    ///
    /// This initializer is equivalent to the following calculation, where `**`
    /// is exponentation, computed as if by a single, correctly rounded,
    /// floating-point operation:
    ///
    ///     let sign: FloatingPointSign = .plus
    ///     let exponent = -2
    ///     let significand = 1.5
    ///     let y = (sign == .minus ? -1 : 1) * significand * Double.radix ** exponent
    ///     // y == 0.375
    ///
    /// As with any basic operation, if this value is outside the representable
    /// range of the type, overflow or underflow occurs, and zero, a subnormal
    /// value, or infinity may result. In addition, there are two other edge
    /// cases:
    ///
    /// - If the value you pass to `significand` is zero or infinite, the result
    ///   is zero or infinite, regardless of the value of `exponent`.
    /// - If the value you pass to `significand` is NaN, the result is NaN.
    ///
    /// For any floating-point value `x` of type `F`, the result of the following
    /// is equal to `x`, with the distinction that the result is canonicalized
    /// if `x` is in a noncanonical encoding:
    ///
    ///     let x0 = F(sign: x.sign, exponent: x.exponent, significand: x.significand)
    ///
    /// This initializer implements the `scaleB` operation defined by the [IEEE
    /// 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameters:
    ///   - sign: The sign to use for the new value.
    ///   - exponent: The new value's exponent.
    ///   - significand: The new value's significand.
    public init(sign: FloatingPointSign, exponent: Raw.Exponent, significand: Angle)
	{
		radians = Raw.init(sign: sign, exponent: exponent, significand: significand.radians)
	}


	public init(_ value: UInt8)	{ radians = Raw(value) }
	public init(_ value: Int8)	{ radians = Raw(value) }
	public init(_ value: UInt16)	{ radians = Raw(value) }
	public init(_ value: Int16)	{ radians = Raw(value) }
	public init(_ value: UInt32)	{ radians = Raw(value) }
	public init(_ value: Int32)	{ radians = Raw(value) }
	public init(_ value: UInt64)	{ radians = Raw(value) }
	public init(_ value: Int64)	{ radians = Raw(value) }
	public init(_ value: UInt)	{ radians = Raw(value) }
	public init(_ value: Int)	{ radians = Raw(value) }
	
	public var sign: FloatingPointSign { return radians.sign }
	public var isNormal: Bool { return radians.isNormal }
	public var isFinite: Bool { return radians.isFinite }
	public var isZero: Bool { return radians.isZero }
	public var isSubnormal: Bool { return radians.isSubnormal }
	public var isInfinite: Bool { return radians.isInfinite }
	public var isNaN: Bool { return radians.isNaN }
	public var isSignalingNaN: Bool { return radians.isSignalingNaN }
	public var floatingPointClass: FloatingPointClassification
		{ return radians.floatingPointClass }
	
    /// The radix, or base of exponentiation, for a floating-point type.
    ///
    /// The magnitude of a floating-point value `x` of type `F` can be calculated
    /// by using the following formula, where `**` is exponentiation:
    ///
    ///     let magnitude = x.significand * F.radix ** x.exponent
    ///
    /// A conforming type may use any integer radix, but values other than 2 (for
    /// binary floating-point types) or 10 (for decimal floating-point types)
    /// are extraordinarily rare in practice.
    public static var radix: Int { return Raw.radix }

    /// A quiet NaN ("not a number").
    ///
    /// A NaN compares not equal, not greater than, and not less than every
    /// value, including itself. Passing a NaN to an operation generally results
    /// in NaN.
    ///
    ///     let x = 1.21
    ///     // x > Double.nan == false
    ///     // x < Double.nan == false
    ///     // x == Double.nan == false
    ///
    /// Because a NaN always compares not equal to itself, to test whether a
    /// floating-point value is NaN, use its `isNaN` property instead of the
    /// equal-to operator (`==`). In the following example, `y` is NaN.
    ///
    ///     let y = x + Double.nan
    ///     print(y == Double.nan)
    ///     // Prints "false"
    ///     print(y.isNaN)
    ///     // Prints "true"
    ///
    /// - SeeAlso: `isNaN`, `signalingNaN`
    public static var nan: Angle { return Angle(Raw.nan) }

    /// A signaling NaN ("not a number").
    ///
    /// The default IEEE 754 behavior of operations involving a signaling NaN is
    /// to raise the Invalid flag in the floating-point environment and return a
    /// quiet NaN.
    ///
    /// Operations on types conforming to the `FloatingPoint` protocol should
    /// support this behavior, but they might also support other options. For
    /// example, it would be reasonable to implement alternative operations in
    /// which operating on a signaling NaN triggers a runtime error or results
    /// in a diagnostic for debugging purposes. Types that implement alternative
    /// behaviors for a signaling NaN must document the departure.
    ///
    /// Other than these signaling operations, a signaling NaN behaves in the
    /// same manner as a quiet NaN.
    ///
    /// - SeeAlso: `nan`
    public static var signalingNaN: Angle { return Angle(Raw.signalingNaN) }

    /// Positive infinity.
    ///
    /// Infinity compares greater than all finite numbers and equal to other
    /// infinite values.
    ///
    ///     let x = Double.greatestFiniteMagnitude
    ///     let y = x * 2
    ///     // y == Double.infinity
    ///     // y > x
    public static var infinity: Angle { return Angle(Raw.infinity) }

    /// The greatest finite number representable by this type.
    ///
    /// This value compares greater than or equal to all finite numbers, but less
    /// than `infinity`.
    ///
    /// This value corresponds to type-specific C macros such as `FLT_MAX` and
    /// `DBL_MAX`. The naming of those macros is slightly misleading, because
    /// `infinity` is greater than this value.
//    public static var greatestFiniteMagnitude: Angle { return Angle(Raw.greatestFiniteMagnitude) }

    /// The mathematical constant pi.
    ///
    /// This value should be rounded toward zero to keep user computations with
    /// angles from inadvertently ending up in the wrong quadrant. A type that
    /// conforms to the `FloatingPoint` protocol provides the value for `pi` at
    /// its best possible precision.
    ///
    ///     print(Double.pi)
    ///     // Prints "3.14159265358979"
    public static var pi: Angle { return Angle(Raw.pi) }


    /// The unit in the last place of 1.0.
    ///
    /// The positive difference between 1.0 and the next greater representable
    /// number. The `ulpOfOne` constant corresponds to the C macros
    /// `FLT_EPSILON`, `DBL_EPSILON`, and others with a similar purpose.
    public static var ulpOfOne: Angle { return Angle(Raw.ulpOfOne) }

    /// The least positive normal number.
    ///
    /// This value compares less than or equal to all positive normal numbers.
    /// There may be smaller positive numbers, but they are *subnormal*, meaning
    /// that they are represented with less precision than normal numbers.
    ///
    /// This value corresponds to type-specific C macros such as `FLT_MIN` and
    /// `DBL_MIN`. The naming of those macros is slightly misleading, because
    /// subnormals, zeros, and negative numbers are smaller than this value.
//    public static var leastNormalMagnitude: Angle { return Angle(Raw.leastNormalMagnitude) }

    /// The least positive number.
    ///
    /// This value compares less than or equal to all positive numbers, but
    /// greater than zero. If the type supports subnormal values,
    /// `leastNonzeroMagnitude` is smaller than `leastNormalMagnitude`;
    /// otherwise they are equal.
    public static var leastNonzeroMagnitude: Angle { return Angle(Raw.leastNonzeroMagnitude) }
/*
    /// The sign of the floating-point value.
    ///
    /// The `sign` property is `.minus` if the value's signbit is set, and
    /// `.plus` otherwise. For example:
    ///
    ///     let x = -33.375
    ///     // x.sign == .minus
    ///
    /// Don't use this property to check whether a floating point value is
    /// negative. For a value `x`, the comparison `x.sign == .minus` is not
    /// necessarily the same as `x < 0`. In particular, `x.sign == .minus` if
    /// `x` is -0, and while `x < 0` is always `false` if `x` is NaN, `x.sign`
    /// could be either `.plus` or `.minus`.
    public var sign: FloatingPointSign { get }

    /// The exponent of the floating-point value.
    ///
    /// The *exponent* of a floating-point value is the integer part of the
    /// logarithm of the value's magnitude. For a value `x` of a floating-point
    /// type `F`, the magnitude can be calculated as the following, where `**`
    /// is exponentiation:
    ///
    ///     let magnitude = x.significand * F.radix ** x.exponent
    ///
    /// In the next example, `y` has a value of `21.5`, which is encoded as
    /// `1.34375 * 2 ** 4`. The significand of `y` is therefore 1.34375.
    ///
    ///     let y: Double = 21.5
    ///     // y.significand == 1.34375
    ///     // y.exponent == 4
    ///     // Double.radix == 2
    ///
    /// The `exponent` property has the following edge cases:
    ///
    /// - If `x` is zero, then `x.exponent` is `Int.min`.
    /// - If `x` is +/-infinity or NaN, then `x.exponent` is `Int.max`
    ///
    /// This property implements the `logB` operation defined by the [IEEE 754
    /// specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    public var exponent: Angle.Exponent { get }

    /// The significand of the floating-point value.
    ///
    /// The magnitude of a floating-point value `x` of type `F` can be calculated
    /// by using the following formula, where `**` is exponentiation:
    ///
    ///     let magnitude = x.significand * F.radix ** x.exponent
    ///
    /// In the next example, `y` has a value of `21.5`, which is encoded as
    /// `1.34375 * 2 ** 4`. The significand of `y` is therefore 1.34375.
    ///
    ///     let y: Double = 21.5
    ///     // y.significand == 1.34375
    ///     // y.exponent == 4
    ///     // Double.radix == 2
    ///
    /// If a type's radix is 2, then for finite nonzero numbers, the significand
    /// is in the range `1.0 ..< 2.0`. For other values of `x`, `x.significand`
    /// is defined as follows:
    ///
    /// - If `x` is zero, then `x.significand` is 0.0.
    /// - If `x` is infinity, then `x.significand` is 1.0.
    /// - If `x` is NaN, then `x.significand` is NaN.
    /// - Note: The significand is frequently also called the *mantissa*, but
    ///   significand is the preferred terminology in the [IEEE 754
    ///   specification][spec], to allay confusion with the use of mantissa for
    ///   the fractional part of a logarithm.
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    public var significand: Angle { get }

    /// Returns the sum of this value and the given value, rounded to a
    /// representable value.
    ///
    /// This method serves as the basis for the addition operator (`+`). For
    /// example:
    ///
    ///     let x = 1.5
    ///     print(x.adding(2.25))
    ///     // Prints "3.75"
    ///     print(x + 2.25)
    ///     // Prints "3.75"
    ///
    /// The `adding(_:)` method implements the addition operation defined by the
    /// [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to add.
    /// - Returns: The sum of this value and `other`, rounded to a representable
    ///   value.
    ///
    /// - SeeAlso: `add(_:)`
    public func adding(_ other: Angle) -> Angle

    /// Adds the given value to this value in place, rounded to a representable
    /// value.
    ///
    /// This method serves as the basis for the in-place addition operator
    /// (`+=`). For example:
    ///
    ///     var (x, y) = (2.25, 2.25)
    ///     x.add(7.0)
    ///     // x == 9.25
    ///     y += 7.0
    ///     // y == 9.25
    ///
    /// - Parameter other: The value to add.
    ///
    /// - SeeAlso: `adding(_:)`
    public mutating func add(_ other: Angle)

    /// Returns the additive inverse of this value.
    ///
    /// The result is always exact. This method serves as the basis for the
    /// negation operator (prefixed `-`). For example:
    ///
    ///     let x = 21.5
    ///     let y = x.negated()
    ///     // y == -21.5
    ///
    /// - Returns: The additive inverse of this value.
    ///
    /// - SeeAlso: `negate()`
    public func negated() -> Angle

    /// Replaces this value with its additive inverse.
    ///
    /// The result is always exact. This example uses the `negate()` method to
    /// negate the value of the variable `x`:
    ///
    ///     var x = 21.5
    ///     x.negate()
    ///     // x == -21.5
    ///
    /// - SeeAlso: `negated()`
    public mutating func negate()

    /// Returns the difference of this value and the given value, rounded to a
    /// representable value.
    ///
    /// This method serves as the basis for the subtraction operator (`-`). For
    /// example:
    ///
    ///     let x = 7.5
    ///     print(x.subtracting(2.25))
    ///     // Prints "5.25"
    ///     print(x - 2.25)
    ///     // Prints "5.25"
    ///
    /// The `subtracting(_:)` method implements the addition operation defined by
    /// the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to subtract from this value.
    /// - Returns: The difference of this value and `other`, rounded to a
    ///   representable value.
    ///
    /// - SeeAlso: `subtract(_:)`
    public func subtracting(_ other: Angle) -> Angle

    /// Subtracts the given value from this value in place, rounding to a
    /// representable value.
    ///
    /// This method serves as the basis for the in-place subtraction operator
    /// (`-=`). For example:
    ///
    ///     var (x, y) = (7.5, 7.5)
    ///     x.subtract(2.25)
    ///     // x == 5.25
    ///     y -= 2.25
    ///     // y == 5.25
    ///
    /// - Parameter other: The value to subtract.
    ///
    /// - SeeAlso: `subtracting(_:)`
    public mutating func subtract(_ other: Angle)

    /// Returns the product of this value and the given value, rounded to a
    /// representable value.
    ///
    /// This method serves as the basis for the multiplication operator (`*`).
    /// For example:
    ///
    ///     let x = 7.5
    ///     print(x.multiplied(by: 2.25))
    ///     // Prints "16.875"
    ///     print(x * 2.25)
    ///     // Prints "16.875"
    ///
    /// The `multiplied(by:)` method implements the multiplication operation
    /// defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to multiply by this value.
    /// - Returns: The product of this value and `other`, rounded to a
    ///   representable value.
    ///
    /// - SeeAlso: `multiply(by:)`
    public func multiplied(by other: Angle) -> Angle

    /// Multiplies this value by the given value in place, rounding to a
    /// representable value.
    ///
    /// This method serves as the basis for the in-place multiplication operator
    /// (`*=`). For example:
    ///
    ///     var (x, y) = (7.5, 7.5)
    ///     x.multiply(by: 2.25)
    ///     // x == 16.875
    ///     y *= 2.25
    ///     // y == 16.875
    ///
    /// - Parameter other: The value to multiply by this value.
    ///
    /// - SeeAlso: `multiplied(by:)`
    public mutating func multiply(by other: Angle)

    /// Returns the quotient of this value and the given value, rounded to a
    /// representable value.
    ///
    /// This method serves as the basis for the division operator (`/`). For
    /// example:
    ///
    ///     let x = 7.5
    ///     let y = x.divided(by: 2.25)
    ///     // y == 16.875
    ///     let z = x * 2.25
    ///     // z == 16.875
    ///
    /// The `divided(by:)` method implements the division operation
    /// defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to use when dividing this value.
    /// - Returns: The quotient of this value and `other`, rounded to a
    ///   representable value.
    ///
    /// - SeeAlso: `divide(by:)`
    public func divided(by other: Angle) -> Angle

    /// Divides this value by the given value in place, rounding to a
    /// representable value.
    ///
    /// This method serves as the basis for the in-place division operator
    /// (`/=`). For example:
    ///
    ///     var (x, y) = (16.875, 16.875)
    ///     x.divide(by: 2.25)
    ///     // x == 7.5
    ///     y /= 2.25
    ///     // y == 7.5
    ///
    /// - Parameter other: The value to use when dividing this value.
    ///
    /// - SeeAlso: `divided(by:)`
    public mutating func divide(by other: Angle)
*/
    /// Returns the remainder of this value divided by the given value.
    ///
    /// For two finite values `x` and `y`, the remainder `r` of dividing `x` by
    /// `y` satisfies `x == y * q + r`, where `q` is the integer nearest to
    /// `x / y`. If `x / y` is exactly halfway between two integers, `q` is
    /// chosen to be even. Note that `q` is *not* `x / y` computed in
    /// floating-point arithmetic, and that `q` may not be representable in any
    /// available integer type.
    ///
    /// The following example calculates the remainder of dividing 8.625 by 0.75:
    ///
    ///     let x = 8.625
    ///     print(x / 0.75)
    ///     // Prints "11.5"
    ///
    ///     let q = (x / 0.75).rounded(.toNearestOrEven)
    ///     // q == 12.0
    ///     let r = x.remainder(dividingBy: 0.75)
    ///     // r == -0.375
    ///
    ///     let x1 = 0.75 * q + r
    ///     // x1 == 8.625
    ///
    /// If this value and `other` are finite numbers, the remainder is in the
    /// closed range `-abs(other / 2)...abs(other / 2)`. The
    /// `remainder(dividingBy:)` method is always exact. This method implements
    /// the remainder operation defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to use when dividing this value.
    /// - Returns: The remainder of this value divided by `other`.
    ///
    /// - SeeAlso: `formRemainder(dividingBy:)`,
    ///   `truncatingRemainder(dividingBy:)`
    public func remainder(dividingBy other: Angle) -> Angle
		{ return Angle(radians.remainder(dividingBy: other.radians)) }

    /// Replaces this value with the remainder of itself divided by the given
    /// value.
    ///
    /// For two finite values `x` and `y`, the remainder `r` of dividing `x` by
    /// `y` satisfies `x == y * q + r`, where `q` is the integer nearest to
    /// `x / y`. If `x / y` is exactly halfway between two integers, `q` is
    /// chosen to be even. Note that `q` is *not* `x / y` computed in
    /// floating-point arithmetic, and that `q` may not be representable in any
    /// available integer type.
    ///
    /// The following example calculates the remainder of dividing 8.625 by 0.75:
    ///
    ///     var x = 8.625
    ///     print(x / 0.75)
    ///     // Prints "11.5"
    ///
    ///     let q = (x / 0.75).rounded(.toNearestOrEven)
    ///     // q == 12.0
    ///     x.formRemainder(dividingBy: 0.75)
    ///     // x == -0.375
    ///
    ///     let x1 = 0.75 * q + x
    ///     // x1 == 8.625
    ///
    /// If this value and `other` are finite numbers, the remainder is in the
    /// closed range `-abs(other / 2)...abs(other / 2)`. The
    /// `remainder(dividingBy:)` method is always exact.
    ///
    /// - Parameter other: The value to use when dividing this value.
    ///
    /// - SeeAlso: `remainder(dividingBy:)`,
    ///   `formTruncatingRemainder(dividingBy:)`
    public mutating func formRemainder(dividingBy other: Angle)
		{ radians.formRemainder(dividingBy: other.radians) }

    /// Returns the remainder of this value divided by the given value using
    /// truncating division.
    ///
    /// Performing truncating division with floating-point values results in a
    /// truncated integer quotient and a remainder. For values `x` and `y` and
    /// their truncated integer quotient `q`, the remainder `r` satisfies
    /// `x == y * q + r`.
    ///
    /// The following example calculates the truncating remainder of dividing
    /// 8.625 by 0.75:
    ///
    ///     let x = 8.625
    ///     print(x / 0.75)
    ///     // Prints "11.5"
    ///
    ///     let q = (x / 0.75).rounded(.towardZero)
    ///     // q == 11.0
    ///     let r = x.truncatingRemainder(dividingBy: 0.75)
    ///     // r == 0.375
    ///
    ///     let x1 = 0.75 * q + r
    ///     // x1 == 8.625
    ///
    /// If this value and `other` are both finite numbers, the truncating
    /// remainder has the same sign as `other` and is strictly smaller in
    /// magnitude. The `truncatingRemainder(dividingBy:)` method is always
    /// exact.
    ///
    /// - Parameter other: The value to use when dividing this value.
    /// - Returns: The remainder of this value divided by `other` using
    ///   truncating division.
    ///
    /// - SeeAlso: `formTruncatingRemainder(dividingBy:)`,
    ///   `remainder(dividingBy:)`
    public func truncatingRemainder(dividingBy other: Angle) -> Angle
		{ return Angle(radians.truncatingRemainder(dividingBy: other.radians)) }

    /// Replaces this value with the remainder of itself divided by the given
    /// value using truncating division.
    ///
    /// Performing truncating division with floating-point values results in a
    /// truncated integer quotient and a remainder. For values `x` and `y` and
    /// their truncated integer quotient `q`, the remainder `r` satisfies
    /// `x == y * q + r`.
    ///
    /// The following example calculates the truncating remainder of dividing
    /// 8.625 by 0.75:
    ///
    ///     var x = 8.625
    ///     print(x / 0.75)
    ///     // Prints "11.5"
    ///
    ///     let q = (x / 0.75).rounded(.towardZero)
    ///     // q == 11.0
    ///     x.formTruncatingRemainder(dividingBy: 0.75)
    ///     // x == 0.375
    ///
    ///     let x1 = 0.75 * q + x
    ///     // x1 == 8.625
    ///
    /// If this value and `other` are both finite numbers, the truncating
    /// remainder has the same sign as `other` and is strictly smaller in
    /// magnitude. The `formtruncatingRemainder(dividingBy:)` method is always
    /// exact.
    ///
    /// - Parameter other: The value to use when dividing this value.
    ///
    /// - SeeAlso: `truncatingRemainder(dividingBy:)`,
    ///   `formRemainder(dividingBy:)`
    public mutating func formTruncatingRemainder(dividingBy other: Angle)
		{ radians.formTruncatingRemainder(dividingBy: other.radians) }

    /// Returns the square root of the value, rounded to a representable value.
    ///
    /// The following example declares a function that calculates the length of
    /// the hypotenuse of a right triangle given its two perpendicular sides.
    ///
    ///     func hypotenuse(_ a: Double, _ b: Double) -> Double {
    ///         return (a * a + b * b).squareRoot()
    ///     }
    ///
    ///     let (dx, dy) = (3.0, 4.0)
    ///     let distance = hypotenuse(dx, dy)
    ///     // distance == 5.0
    ///
    /// - Returns: The square root of the value.
    ///
    /// - SeeAlso: `sqrt(_:)`, `formSquareRoot()`
    public func squareRoot() -> Angle
		{ return Angle(radians.squareRoot()) }

    /// Replaces this value with its square root, rounded to a representable
    /// value.
    ///
    /// - SeeAlso: `sqrt(_:)`, `squareRoot()`
    public mutating func formSquareRoot()
		{ radians.formSquareRoot() }
/*
    /// Returns the result of adding the product of the two given values to this
    /// value, computed without intermediate rounding.
    ///
    /// This method is equivalent to the C `fma` function and implements the
    /// `fusedMultiplyAdd` operation defined by the [IEEE 754
    /// specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameters:
    ///   - lhs: One of the values to multiply before adding to this value.
    ///   - rhs: The other value to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this value.
    public func addingProduct(_ lhs: Angle, _ rhs: Angle) -> Angle

    /// Adds the product of the two given values to this value in place, computed
    /// without intermediate rounding.
    ///
    /// - Parameters:
    ///   - lhs: One of the values to multiply before adding to this value.
    ///   - rhs: The other value to multiply.
    public mutating func addProduct(_ lhs: Angle, _ rhs: Angle)

    /// Returns the lesser of the two given values.
    ///
    /// This method returns the minimum of two values, preserving order and
    /// eliminating NaN when possible. For two values `x` and `y`, the result of
    /// `minimum(x, y)` is `x` if `x <= y`, `y` if `y < x`, or whichever of `x`
    /// or `y` is a number if the other is a quiet NaN. If both `x` and `y` are
    /// NaN, or either `x` or `y` is a signaling NaN, the result is NaN.
    ///
    ///     Double.minimum(10.0, -25.0)
    ///     // -25.0
    ///     Double.minimum(10.0, .nan)
    ///     // 10.0
    ///     Double.minimum(.nan, -25.0)
    ///     // -25.0
    ///     Double.minimum(.nan, .nan)
    ///     // nan
    ///
    /// The `minimum` method implements the `minNum` operation defined by the
    /// [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameters:
    ///   - x: A floating-point value.
    ///   - y: Another floating-point value.
    /// - Returns: The minimum of `x` and `y`, or whichever is a number if the
    ///   other is NaN.
    public static func minimum(_ x: Angle, _ y: Angle) -> Angle

    /// Returns the greater of the two given values.
    ///
    /// This method returns the maximum of two values, preserving order and
    /// eliminating NaN when possible. For two values `x` and `y`, the result of
    /// `maximum(x, y)` is `x` if `x > y`, `y` if `x <= y`, or whichever of `x`
    /// or `y` is a number if the other is a quiet NaN. If both `x` and `y` are
    /// NaN, or either `x` or `y` is a signaling NaN, the result is NaN.
    ///
    ///     Double.maximum(10.0, -25.0)
    ///     // 10.0
    ///     Double.maximum(10.0, .nan)
    ///     // 10.0
    ///     Double.maximum(.nan, -25.0)
    ///     // -25.0
    ///     Double.maximum(.nan, .nan)
    ///     // nan
    ///
    /// The `maximum` method implements the `maxNum` operation defined by the
    /// [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameters:
    ///   - x: A floating-point value.
    ///   - y: Another floating-point value.
    /// - Returns: The greater of `x` and `y`, or whichever is a number if the
    ///   other is NaN.
    public static func maximum(_ x: Angle, _ y: Angle) -> Angle

    /// Returns the value with lesser magnitude.
    ///
    /// This method returns the value with lesser magnitude of the two given
    /// values, preserving order and eliminating NaN when possible. For two
    /// values `x` and `y`, the result of `minimumMagnitude(x, y)` is `x` if
    /// `x.magnitude <= y.magnitude`, `y` if `y.magnitude < x.magnitude`, or
    /// whichever of `x` or `y` is a number if the other is a quiet NaN. If both
    /// `x` and `y` are NaN, or either `x` or `y` is a signaling NaN, the result
    /// is NaN.
    ///
    ///     Double.minimumMagnitude(10.0, -25.0)
    ///     // 10.0
    ///     Double.minimumMagnitude(10.0, .nan)
    ///     // 10.0
    ///     Double.minimumMagnitude(.nan, -25.0)
    ///     // -25.0
    ///     Double.minimumMagnitude(.nan, .nan)
    ///     // nan
    ///
    /// The `minimumMagnitude` method implements the `minNumMag` operation
    /// defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameters:
    ///   - x: A floating-point value.
    ///   - y: Another floating-point value.
    /// - Returns: Whichever of `x` or `y` has lesser magnitude, or whichever is
    ///   a number if the other is NaN.
    public static func minimumMagnitude(_ x: Angle, _ y: Angle) -> Angle

    /// Returns the value with greater magnitude.
    ///
    /// This method returns the value with greater magnitude of the two given
    /// values, preserving order and eliminating NaN when possible. For two
    /// values `x` and `y`, the result of `maximumMagnitude(x, y)` is `x` if
    /// `x.magnitude > y.magnitude`, `y` if `x.magnitude <= y.magnitude`, or
    /// whichever of `x` or `y` is a number if the other is a quiet NaN. If both
    /// `x` and `y` are NaN, or either `x` or `y` is a signaling NaN, the result
    /// is NaN.
    ///
    ///     Double.maximumMagnitude(10.0, -25.0)
    ///     // -25.0
    ///     Double.maximumMagnitude(10.0, .nan)
    ///     // 10.0
    ///     Double.maximumMagnitude(.nan, -25.0)
    ///     // -25.0
    ///     Double.maximumMagnitude(.nan, .nan)
    ///     // nan
    ///
    /// The `maximumMagnitude` method implements the `maxNumMag` operation
    /// defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameters:
    ///   - x: A floating-point value.
    ///   - y: Another floating-point value.
    /// - Returns: Whichever of `x` or `y` has greater magnitude, or whichever is
    ///   a number if the other is NaN.
    public static func maximumMagnitude(_ x: Angle, _ y: Angle) -> Angle

    /// Returns this value rounded to an integral value using the specified
    /// rounding rule.
    ///
    /// The following example rounds a value using four different rounding rules:
    ///
    ///     let x = 6.5
    ///
    ///     // Equivalent to the C 'round' function:
    ///     print(x.rounded(.toNearestOrAwayFromZero))
    ///     // Prints "7.0"
    ///
    ///     // Equivalent to the C 'trunc' function:
    ///     print(x.rounded(.towardZero))
    ///     // Prints "6.0"
    ///
    ///     // Equivalent to the C 'ceil' function:
    ///     print(x.rounded(.up))
    ///     // Prints "7.0"
    ///
    ///     // Equivalent to the C 'floor' function:
    ///     print(x.rounded(.down))
    ///     // Prints "6.0"
    ///
    /// For more information about the available rounding rules, see the
    /// `FloatingPointRoundingRule` enumeration. To round a value using the
    /// default "schoolbook rounding", you can use the shorter `rounded()`
    /// method instead.
    ///
    ///     print(x.rounded())
    ///     // Prints "7.0"
    ///
    /// - Parameter rule: The rounding rule to use.
    /// - Returns: The integral value found by rounding using `rule`.
    ///
    /// - SeeAlso: `rounded()`, `round(_:)`, `FloatingPointRoundingRule`
    public func rounded(_ rule: FloatingPointRoundingRule) -> Angle

    /// Rounds the value to an integral value using the specified rounding rule.
    ///
    /// The following example rounds a value using four different rounding rules:
    ///
    ///     // Equivalent to the C 'round' function:
    ///     var w = 6.5
    ///     w.round(.toNearestOrAwayFromZero)
    ///     // w == 7.0
    ///
    ///     // Equivalent to the C 'trunc' function:
    ///     var x = 6.5
    ///     x.round(.towardZero)
    ///     // x == 6.0
    ///
    ///     // Equivalent to the C 'ceil' function:
    ///     var y = 6.5
    ///     y.round(.up)
    ///     // y == 7.0
    ///
    ///     // Equivalent to the C 'floor' function:
    ///     var z = 6.5
    ///     z.round(.down)
    ///     // z == 6.0
    ///
    /// For more information about the available rounding rules, see the
    /// `FloatingPointRoundingRule` enumeration. To round a value using the
    /// default "schoolbook rounding", you can use the shorter `round()` method
    /// instead.
    ///
    ///     var w1 = 6.5
    ///     w1.round()
    ///     // w1 == 7.0
    ///
    /// - Parameter rule: The rounding rule to use.
    ///
    /// - SeeAlso: `round()`, `rounded(_:)`, `FloatingPointRoundingRule`
    public mutating func round(_ rule: FloatingPointRoundingRule)

    /// The least representable value that compares greater than this value.
    ///
    /// For any finite value `x`, `x.nextUp` is greater than `x`. For `nan` or
    /// `infinity`, `x.nextUp` is `x` itself. The following special cases also
    /// apply:
    ///
    /// - If `x` is `-infinity`, then `x.nextUp` is `-greatestFiniteMagnitude`.
    /// - If `x` is `-leastNonzeroMagnitude`, then `x.nextUp` is `-0.0`.
    /// - If `x` is zero, then `x.nextUp` is `leastNonzeroMagnitude`.
    /// - If `x` is `greatestFiniteMagnitude`, then `x.nextUp` is `infinity`.
    public var nextUp: Angle { get }

    /// The greatest representable value that compares less than this value.
    ///
    /// For any finite value `x`, `x.nextDown` is greater than `x`. For `nan` or
    /// `-infinity`, `x.nextDown` is `x` itself. The following special cases
    /// also apply:
    ///
    /// - If `x` is `infinity`, then `x.nextDown` is `greatestFiniteMagnitude`.
    /// - If `x` is `leastNonzeroMagnitude`, then `x.nextDown` is `0.0`.
    /// - If `x` is zero, then `x.nextDown` is `-leastNonzeroMagnitude`.
    /// - If `x` is `-greatestFiniteMagnitude`, then `x.nextDown` is `-infinity`.
    public var nextDown: Angle { get }

    /// Returns a Boolean value indicating whether this instance is equal to the
    /// given value.
    ///
    /// This method serves as the basis for the equal-to operator (`==`) for
    /// floating-point values. When comparing two values with this method, `-0`
    /// is equal to `+0`. NaN is not equal to any value, including itself. For
    /// example:
    ///
    ///     let x = 15.0
    ///     x.isEqual(to: 15.0)
    ///     // true
    ///     x.isEqual(to: .nan)
    ///     // false
    ///     Double.nan.isEqual(to: .nan)
    ///     // false
    ///
    /// The `isEqual(to:)` method implements the equality predicate defined by
    /// the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to compare with this value.
    /// - Returns: `true` if `other` has the same value as this instance;
    ///   otherwise, `false`.
    public func isEqual(to other: Angle) -> Bool

    /// Returns a Boolean value indicating whether this instance is less than the
    /// given value.
    ///
    /// This method serves as the basis for the less-than operator (`<`) for
    /// floating-point values. Some special cases apply:
    ///
    /// - Because NaN compares not less than nor greater than any value, this
    ///   method returns `false` when called on NaN or when NaN is passed as
    ///   `other`.
    /// - `-infinity` compares less than all values except for itself and NaN.
    /// - Every value except for NaN and `+infinity` compares less than
    ///   `+infinity`.
    ///
    ///     let x = 15.0
    ///     x.isLess(than: 20.0)
    ///     // true
    ///     x.isLess(than: .nan)
    ///     // false
    ///     Double.nan.isLess(than: x)
    ///     // false
    ///
    /// The `isLess(than:)` method implements the less-than predicate defined by
    /// the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to compare with this value.
    /// - Returns: `true` if `other` is less than this value; otherwise, `false`.
    public func isLess(than other: Angle) -> Bool

    /// Returns a Boolean value indicating whether this instance is less than or
    /// equal to the given value.
    ///
    /// This method serves as the basis for the less-than-or-equal-to operator
    /// (`<=`) for floating-point values. Some special cases apply:
    ///
    /// - Because NaN is incomparable with any value, this method returns `false`
    ///   when called on NaN or when NaN is passed as `other`.
    /// - `-infinity` compares less than or equal to all values except NaN.
    /// - Every value except NaN compares less than or equal to `+infinity`.
    ///
    ///     let x = 15.0
    ///     x.isLessThanOrEqualTo(20.0)
    ///     // true
    ///     x.isLessThanOrEqualTo(.nan)
    ///     // false
    ///     Double.nan.isLessThanOrEqualTo(x)
    ///     // false
    ///
    /// The `isLessThanOrEqualTo(_:)` method implements the less-than-or-equal
    /// predicate defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: The value to compare with this value.
    /// - Returns: `true` if `other` is less than this value; otherwise, `false`.
    public func isLessThanOrEqualTo(_ other: Angle) -> Bool

    /// Returns a Boolean value indicating whether this instance should precede the
    /// given value in an ascending sort.
    ///
    /// This relation is a refinement of the less-than-or-equal-to operator
    /// (`<=`) that provides a total order on all values of the type, including
    /// noncanonical encodings, signed zeros, and NaNs. Because it is used much
    /// less frequently than the usual comparisons, there is no operator form of
    /// this relation.
    ///
    /// The following example uses `isTotallyOrdered(below:)` to sort an array of
    /// floating-point values, including some that are NaN:
    ///
    ///     var numbers = [2.5, 21.25, 3.0, .nan, -9.5]
    ///     numbers.sort { $0.isTotallyOrdered(below: $1) }
    ///     // numbers == [-9.5, 2.5, 3.0, 21.25, nan]
    ///
    /// The `isTotallyOrdered(belowOrEqualTo:)` method implements the total order
    /// relation as defined by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    ///
    /// - Parameter other: A floating-point value to compare to this value.
    /// - Returns: `true` if this value is ordered below `other` in a total
    ///   ordering of the floating-point type; otherwise, `false`.
    public func isTotallyOrdered(belowOrEqualTo other: Angle) -> Bool

    /// A Boolean value indicating whether this instance is normal.
    ///
    /// A *normal* value is a finite number that uses the full precision
    /// available to values of a type. Zero is neither a normal nor a subnormal
    /// number.
    public var isNormal: Bool { get }

    /// A Boolean value indicating whether this instance is finite.
    ///
    /// All values other than NaN and infinity are considered finite, whether
    /// normal or subnormal.
    public var isFinite: Bool { get }

    /// A Boolean value indicating whether the instance is equal to zero.
    ///
    /// The `isZero` property of a value `x` is `true` when `x` represents either
    /// `-0.0` or `+0.0`. `x.isZero` is equivalent to the following comparison:
    /// `x == 0.0`.
    ///
    ///     let x = -0.0
    ///     x.isZero        // true
    ///     x == 0.0        // true
    public var isZero: Bool { get }

    /// A Boolean value indicating whether the instance is subnormal.
    ///
    /// A *subnormal* value is a nonzero number that has a lesser magnitude than
    /// the smallest normal number. Subnormal values do not use the full
    /// precision available to values of a type.
    ///
    /// Zero is neither a normal nor a subnormal number. Subnormal numbers are
    /// often called *denormal* or *denormalized*---these are different names
    /// for the same concept.
    public var isSubnormal: Bool { get }

    /// A Boolean value indicating whether the instance is infinite.
    ///
    /// Note that `isFinite` and `isInfinite` do not form a dichotomy, because
    /// they are not total: If `x` is `NaN`, then both properties are `false`.
    public var isInfinite: Bool { get }

    /// A Boolean value indicating whether the instance is NaN ("not a number").
    ///
    /// Because NaN is not equal to any value, including NaN, use this property
    /// instead of the equal-to operator (`==`) or not-equal-to operator (`!=`)
    /// to test whether a value is or is not NaN. For example:
    ///
    ///     let x = 0.0
    ///     let y = x * .infinity
    ///     // y is a NaN
    ///
    ///     // Comparing with the equal-to operator never returns 'true'
    ///     print(x == Double.nan)
    ///     // Prints "false"
    ///     print(y == Double.nan)
    ///     // Prints "false"
    ///
    ///     // Test with the 'isNaN' property instead
    ///     print(x.isNaN)
    ///     // Prints "false"
    ///     print(y.isNaN)
    ///     // Prints "true"
    ///
    /// This property is `true` for both quiet and signaling NaNs.
    public var isNaN: Bool { return raidans.isNaN }

    /// A Boolean value indicating whether the instance is a signaling NaN.
    ///
    /// Signaling NaNs typically raise the Invalid flag when used in general
    /// computing operations.
    public var isSignalingNaN: Bool { return radians.isSignalingNaN }

    /// The classification of this value.
    ///
    /// A value's `floatingPointClass` property describes its "class" as
    /// described by the [IEEE 754 specification][spec].
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    public var floatingPointClass: FloatingPointClassification { return radians.floatingPointClass }
*/
    /// A Boolean value indicating whether the instance's representation is in
    /// the canonical form.
    ///
    /// The [IEEE 754 specification][spec] defines a *canonical*, or preferred,
    /// encoding of a floating-point value's representation. Every `Float` or
    /// `Double` value is canonical, but noncanonical values of the `Float80`
    /// type exist, and noncanonical values may exist for other types that
    /// conform to the `FloatingPoint` protocol.
    ///
    /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
    public var isCanonical: Bool
		  { return radians.isCanonical }
}

