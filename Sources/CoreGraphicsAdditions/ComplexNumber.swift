//
//  Complex Math.swift
//  Additions
//
//  Created by Braeden Hintze on 1/31/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphics


/// A structure that represents a complex number, in the form of a + bi, where (a,b) is represented by (r,i).
public struct ComplexNumber<Base: NumberType & ExpressibleByFloatLiteral & FloatMathematical & Codable>
{
	// TODO: Remove `Base: NumberType & ExpressiblyByFloatLiteral` when Conditional Conformance comes.
	// MARK:  Properties
	
	/// Real part
	public var r: Base
	/// Imaginary part
	public var i: Base
	
	var conjugate: ComplexNumber
		{ return ComplexNumber(r, -i) }
	
	var norm: Base
		{ return (r*r + i*i).squareRoot() }
	
	var magnitude: Base
	{
		get { return (r*r + i*i).squareRoot() }
		set
		{
			let mag = magnitude
			assert(mag != 0, "Can't set non-directional complex number's magnitude")
			let ratio = newValue / mag
			
			self *= ComplexNumber(ratio)
		}
	}
	
	
	
	// MARK:  Struct Vars
	
	public static var i:	ComplexNumber
		{ return ComplexNumber(0, 1) }
	
	// MARK:  Initialization
	
	public init(_ real: Base = 0, _ imaginary: Base = 0)
	{
		r = real
		i = imaginary
	}
}

// TODO: Reapply this when Conditional Conformance comes.
extension ComplexNumber: ExpressibleByFloatLiteral// where Base: ExpressibleByFloatLiteral
{
	public init(floatLiteral value: Base.FloatLiteralType)
		{ self.init(Base.init(floatLiteral: value), 0) }
}


extension ComplexNumber: CustomStringConvertible
{
	public var description:	String
		{ return "\(r) + i*\(i)" }
}

// TODO: Reapply this when Conditional Conformance comes.
extension ComplexNumber// where Base: NumberType
{
	var angle: Angle
	{
		get
		{
			if (r > 0) // Quadrants 1 and 4
			{
			//	asin y/r = theta
				return asin(numericCast(i / magnitude) as CGFloat)
			}
			else // Quadrants 2 and 3
			{
				let raw: Angle = asin(numericCast(i / magnitude) as CGFloat)
				
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
			let radius = magnitude
			
			r = radius * Base.cos(numericCast(newValue.radians) as Base)// run Candace run
			i = radius * Base.sin(numericCast(newValue.radians) as Base)
		}
	}
	
	public init(angle: Angle, magnitude: Base)
	{
		r = magnitude * Base.cos(numericCast(angle.radians))
		i = magnitude * Base.sin(numericCast(angle.radians))
	}
}


extension ComplexNumber: ArithmeticSummable, ArithmeticFactorable, ArithmeticNegatable, ArithmeticShiftable, ArithmeticScalable, Equatable
{
	public typealias ArithmeticScalar = Base
	public typealias ArithmeticShift = Base
	public func arithmeticInverse() -> ComplexNumber<Base>
	{
		/*
			1 / (a + bi)
			1 / (a + bi) * (a - bi) / (a - bi)
			(a - bi) / (a*a - b*b*i^2)
			(a - bi) / (a*a + b*b)
		*/
		
		let denominator = r*r + i*i
		let real = r / denominator
		let imaginary = -i / denominator
		
		return ComplexNumber(real, imaginary)
	}


	// MARK:  Complex Operators

	public static func == (lh: ComplexNumber<Base>, rh: ComplexNumber<Base>) -> Bool
	{
		return (lh.r == rh.r) && (rh.i == lh.i)
	}

	/// `a+bi + c+di == (a+c)+(b+d)i`
	public static func + (lh: ComplexNumber<Base>, rh: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		return ComplexNumber(lh.r + rh.r, lh.i + rh.i)
	}

	/// `-(a+bi) == (-a)+(-b)i`
	public static prefix func - (x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		return ComplexNumber(-x.r, -x.i)
	}

	/// `(a+bi) * (c+di) == (ac-bd)+(ad+cb)i`
	public static func	* (lh: ComplexNumber<Base>, rh: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		/*
		(a + bi) * (c + di)
		ac + adi + cbi + bd*ii
		ac + adi + cbi - bd
		(ac - bd) + (ad + cb)i
		*/
		
		let real = lh.r*rh.r - lh.i*rh.i
		let imaginary = lh.r*rh.i + lh.i*rh.r
		
		return ComplexNumber(real, imaginary)
	}


	/// `a+bi + c == (a+c)+bi`
	public static  func + (lh: ComplexNumber<Base>, rh: Base) -> ComplexNumber<Base>
	{
		return ComplexNumber(lh.r + rh, lh.i)
	}

	/// `(a+bi) * c == (ac)+(bc)i
	public static func * (lh: ComplexNumber<Base>, rh: Base) -> ComplexNumber<Base>
	{
		return ComplexNumber(lh.r * rh, lh.i * rh)
	}


	// MARK:  Complex - Base Operators

	public static func	== (lh: ComplexNumber<Base>, rh: Base) -> Bool
	{
		return (lh.i == 0) ? (lh.r == rh) : false
	}
}

// FIXME: When Conditional Conformance comes, make this `ApproximatelyEquatable`.
extension ComplexNumber/*: ApproximatelyEquatable*/ where Base: ApproximatelyEquatable
{
	public static func ≈≈ (lh: ComplexNumber<Base>, rh: ComplexNumber<Base>) -> Bool
		{ return (lh.r ≈≈ rh.r) && (rh.i ≈≈ lh.i) }
	
	public static func ≈≈ (lh: ComplexNumber<Base>, rh: Base) -> Bool
		{ return (lh.i ≈≈ 0) && (lh.r ≈≈ rh) }
	
	public static func ≈≈ (lh: Base, rh: ComplexNumber<Base>) -> Bool
		{ return rh ≈≈ lh }

	public static func !≈ (lh: ComplexNumber<Base>, rh: Base) -> Bool
		{ return !(lh ≈≈ rh) }

	public static func !≈ (lh: Base, rh: ComplexNumber<Base>) -> Bool
		{ return !(lh ≈≈ rh) }
}

// MARK:  Complex Functions

// TODO: Finish the FloatMathematical conformance.
extension ComplexNumber//: FloatMathematical
{
	public static func sqrt(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// z = c + di;	√z = a + bi
		
		let r = x.r
		let i = x.i
		let magnitude = x.magnitude
		let real = ((magnitude + r) / 2 as Base).squareRoot()
		let imaginaryMagnitude = ((magnitude - r) / 2 as Base).squareRoot()
		let imaginary = imaginaryMagnitude.signed(i.sign)
		
		return ComplexNumber(real, imaginary)
	}


	/// `a^(b+ic) == (e^b)*(cos(c) + i*sin(c))`
	public static func	exp(_ power: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// e^(πi) = -1
		// e^(ic) = cos(c) + i(sin(c))
		// a^(b+ic) = (a^b)*(cos(c*ln(a)) + i*sin(c*ln(a)))
		
		let b = power.r
		let c = power.i
		let aToTheB = Base.exp(b)
		let real = aToTheB * Base.cos(c)
		let imaginary = aToTheB * Base.sin(c)
		
		return ComplexNumber(real, imaginary)
	}

	/// `a^(b+ic) == (a^b)*(cos(c*ln(a)) + i*sin(c*ln(a)))`
	public static func	pow(_ a: Base, _ exp: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// e^(πi) = -1
		// e^(ic) = cos(c) + i(sin(c))
		// a^(b+ic) = (a^b)*(cos(c*ln(a)) + i*sin(c*ln(a)))
		
		let b = exp.r
		let c = exp.i
		let aToTheB = Base.pow(a, b)
		let lnOfA = Base.log(a)
		let real = aToTheB * Base.cos(c * lnOfA)
		let imaginary = aToTheB * Base.sin(c * lnOfA)
		
		return ComplexNumber(real, imaginary)
	}

	/// `(a+bi)^(c+di) = (a*a + b*b)^((c+di)/2 * e^(i(c+di)arg(a+ib)))`
	public static func	pow(_ x: ComplexNumber<Base>, _ power: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// (a+bi)^(c+di) = (a*a + b*b)^((c+di)/2 * e^(i(c+di)arg(a+ib)))
		
		let a = x.r
		let b = x.i
		
		return pow(a*a + b*b, power/2 * exp(ComplexNumber.i*power*arg(x)))
	}

	public static func	pow(_ a: ComplexNumber<Base>, _ exp: Int) -> ComplexNumber<Base>
	{
		if (exp >= 0)
		{
			var answer = ComplexNumber<Base>(1)
			
			for _ in 0 ..< exp
				{ answer *= a }
			
			return answer
		}
		else
		{
			var answer = ComplexNumber<Base>(1)
			
			for _ in 0 ..< -exp
				{ answer *= a }
			
			return 1.0 / answer
		}
	}

	/// `(a+bi)^c = (a*a + b*b)^(c/2 * e^(ic*arg(a+ib)))`
	public static func	pow(_ x: ComplexNumber<Base>, _ power: Base) -> ComplexNumber<Base>
	{
		// (a+bi)^c = (a*a + b*b)^(c/2 * e^(ic*arg(a+ib)))
		// (a+bi)^c = √(a*a + b*b)^(c * e^(ic*arg(a+ib))
		
		let argument = ComplexNumber.i * power * ComplexNumber.arg(x)
		return ComplexNumber.pow(x.magnitude, ComplexNumber.exp(argument) * power)
	}


	public static func sin(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// sin(a+bi) = sin(a)*cosh(b) + i*cos(a)*sinh(b)
		
		let a = x.r
		let b = x.i
		return ComplexNumber(Base.sin(a)*Base.cosh(b), Base.cos(a)*Base.sinh(b))
	}


	public static func cos(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// cos(a+bi) = cos(a)*cosh(b) - i*sin(a)*sinh(b)
		
		let a = x.r
		let b = x.i
		return ComplexNumber(Base.cos(a)*Base.cosh(b), Base.sin(a)*Base.sinh(b))
	}


	public static func tan(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{
		// tan(a+bi)
		// ( tan(a) + i tanh(b) ) / ( 1 - i tan(a) tanh(b))
		// ( sech^2(b)tan(a) + sec 2(a)tanh(b) i ) / (1 + tan 2(a)tanh 2(b))
		
		let a = x.r
		let b = x.i
		return ComplexNumber(Base.tan(a), Base.tanh(b)) / ComplexNumber(1, -Base.tan(a)*Base.tanh(b))
	}

	/// The complex argument, calculated by `arg(a+bi) == atan(b/a)`.
	public static func arg(_ x: ComplexNumber<Base>) -> Base
	{
		return Base.atan(x.i/x.r)
	}
}

/// if `x > 0`, then `√(-x) == i*√x`
public func complexSqrt<T>(_ x: T) -> ComplexNumber<T>
{
	// i = √-1
	if (x < 0)
		{ return ComplexNumber(0, sqrt(-x)) }
	else
		{ return ComplexNumber(sqrt(x), 0) }
}


public func	abs<T>(_ x: ComplexNumber<T>) -> T
	{ return x.magnitude }

public func sqrt<Base>(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.sqrt(x) }
public func	exp<Base>(_ power: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.exp(power) }
public func pow<Base>(_ a: Base, _ exp: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.pow(a, exp) }
public func	pow<Base>(_ x: ComplexNumber<Base>, _ power: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.pow(x, power) }
public func pow<Base>(_ a: ComplexNumber<Base>, _ exp: Int) -> ComplexNumber<Base>
	{ return ComplexNumber.pow(a, exp) }
public func pow<Base>(_ x: ComplexNumber<Base>, _ power: Base) -> ComplexNumber<Base>
	{ return ComplexNumber.pow(x, power) }
public func sin<Base>(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.sin(x) }
public func	cos<Base>(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.cos(x) }
public func	tan<Base>(_ x: ComplexNumber<Base>) -> ComplexNumber<Base>
	{ return ComplexNumber.tan(x) }
public func arg<Base>(_ x: ComplexNumber<Base>) -> Base
	{ return ComplexNumber.arg(x) }

