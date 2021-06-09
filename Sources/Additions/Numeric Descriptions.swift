//
//  Numeric Descriptions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Foundation


extension Double
{
	public static var defaultFixedFractionalDigitRange			= 0...7
	public static var defaultFixedIntegerDigitRange				= 1...400
	public static var defaultFixedSignificantDigitRange			= 0...400
	public static var defaultScientificSignificantDigitRange	= 1...4
	public static var defaultScientificZeroCutOff				= 1.0e-8
	public static var defaultGeneralFixedPointRange				= -5...10
	
	static let sharedFormatter		= NumberFormatter()
	
	
	public func	descriptionWithFormatter(_ formatter: NumberFormatter) -> String
	{
		return formatter.string(from: NSNumber(value: self))!
	}
	
	/*
	// MARK:  Description Macros
	/// TODO:  Rework these!
	
	/// Returns a string with up to `digits` number of fractional digits.
	public func	roundTo(_ digits: Int) -> String
	{
		return self.fixedPointDescription(fractionalDigitRange: 0...digits)
	}
	
	/// Returns a string with a number of fractional digits within `fractionalRange`, using zeros to reach the minimum if necessary.  Also pads the whole number portion of the string with zeros to reach `minimumInteger` integer digits.
	public func	roundTo(_ fractionRange: Range<Int>, _ minimumInteger: Int = 0) -> String
	{
		return self.fixedPointDescription(	fractionalDigitRange:	fractionRange,
											integerDigitRange:		minimumInteger...minimumInteger	)
	}
	
	/// Returns a string with `digits` number of fractional digits, adding zeros as placeholders.
	public func	roundUpTo(_ digits: Int) -> String
	{
		return self.fixedPointDescription(fractionalDigitRange: digits...digits)
	}
	
	
	// MARK:  Fixed Point Descriptions
	
	public func	fixedPointDescription(	fractionalDigitRange	fractionDigit:		Range<Int>	= Double.defaultFixedFractionalDigitRange,
											integerDigitRange	integerDigit:		Range<Int>	= Double.defaultFixedIntegerDigitRange,
										significantDigitRange	significantDigit:	Range<Int>	= Double.defaultFixedSignificantDigitRange	) -> String
	{
		assert(fractionDigit.lowerBound >= 0, "Cannot get description with negative minimum fractional digits.")
		assert(integerDigit.lowerBound >= 0, "Cannot get description with negative minimum integer digits.")
		
		Double.sharedFormatter.numberStyle = .decimal
		
		// * Fractional digits. * //
		Double.sharedFormatter.minimumFractionDigits = fractionDigit.lowerBound
		if !fractionDigit.isEmpty
			{ Double.sharedFormatter.maximumFractionDigits = fractionDigit.upperBound - 1 }
		else
			{ Double.sharedFormatter.maximumFractionDigits = Int.max }
		
		// * Integer digits. * //
		Double.sharedFormatter.minimumIntegerDigits = integerDigit.lowerBound
		if !integerDigit.isEmpty
			{ Double.sharedFormatter.maximumIntegerDigits = integerDigit.upperBound - 1 }
		else
			{ Double.sharedFormatter.maximumIntegerDigits = Int.max }
		
		// * Significant digits. * //
		Double.sharedFormatter.minimumSignificantDigits = significantDigit.lowerBound
		if !significantDigit.isEmpty
			{ Double.sharedFormatter.maximumSignificantDigits = significantDigit.upperBound - 1 }
		else
			{ Double.sharedFormatter.maximumSignificantDigits = Int.max }
		
		
		return Double.sharedFormatter.string(from: NSNumber(self)) ?? "\(self)"
	}
	
	
	
	public func	newFixedPointDescription(fractionalDigitRange fractionDigit:		Range<Int> = 0...7, significatnDigitRange sig: Range<Int> = 0..<0) -> String
	{
		assert(fractionDigit.lowerBound >= 0, "Cannot get description with negative minimum fractional digits.")
		
		Double.sharedFormatter.numberStyle = .decimal
		
		// * Integer digits reset * //
		Double.sharedFormatter.minimumIntegerDigits = 0
		Double.sharedFormatter.maximumIntegerDigits = 256
		
		// * Significant digits reset * //
		Double.sharedFormatter.minimumSignificantDigits = 0
		Double.sharedFormatter.maximumSignificantDigits = 256
	/*	Double.sharedFormatter.minimumSignificantDigits = sig.startIndex
		if !sig.isEmpty
			{ Double.sharedFormatter.maximumSignificantDigits = sig.endIndex - 1 }
		else
			{ Double.sharedFormatter.maximumSignificantDigits = 256 }*/
		
		// * Fractional digits. * //
		Double.sharedFormatter.minimumFractionDigits = fractionDigit.lowerBound
		if !fractionDigit.isEmpty
			{ Double.sharedFormatter.maximumFractionDigits = fractionDigit.upperBound - 1 }
		else
			{ Double.sharedFormatter.maximumFractionDigits = 256 }
		
		
		return Double.sharedFormatter.string(from: NSNumber(self)) ?? "No"
	}
	
	
	// MARK:  Scientific Descriptions
	
	public func	scientificDescription(	significantDigits d:Range<Int>	= Double.defaultScientificSignificantDigitRange,
										zeroCutOff:			Double		= Double.defaultScientificZeroCutOff) -> String
	{
		let significantDigits = d
		assert(significantDigits.lowerBound >= 0, "Cannot get description with negative minimum significant digits.")
		
		
		Double.sharedFormatter.numberStyle = .scientific
		Double.sharedFormatter.minimumFractionDigits = 0
		Double.sharedFormatter.maximumFractionDigits = Int.max
		Double.sharedFormatter.minimumIntegerDigits = 0
		Double.sharedFormatter.maximumIntegerDigits = Int.max
		
		Double.sharedFormatter.minimumSignificantDigits = significantDigits.lowerBound
		if !significantDigits.isEmpty
			{ Double.sharedFormatter.maximumSignificantDigits = significantDigits.upperBound - 1 }
		else
			{ Double.sharedFormatter.maximumSignificantDigits = Int.max }
		
		if abs(self) < abs(zeroCutOff)
			{ return Double.sharedFormatter.string(from: 0) ?? "0" }
		else
			{ return Double.sharedFormatter.string(from: NSNumber(self)) ?? "\(self)" }
	}
	
	
	// MARK:  Generic Descriptions
	
	/// Work-in-progress.
	public func genericDescription(_ fixedPointRange:	Range<Int>	= Double.defaultGeneralFixedPointRange) -> String
	{
	/*	let digitSizeRaw = log10(abs(self))
		let digitSize:	Int
		
		if (digitSizeRaw > 0)
			{ digitSize = Int(floor(digitSizeRaw)) }
		else
			{ digitSize = Int(ceil(digitSizeRaw)) }*/
		
		return self.fixedPointDescription()
	}
	
	
	/// MARK:  Private Utilities
	
	public static func		integerDigits(_ x: Double) -> Int
	{
		let integerPart = trunc(abs(x))
		let orderOfMagnitude = ceil(log10(integerPart))
		return integerPart ≈≈ 0 ? 0 : Int(orderOfMagnitude)
	}*/
}


extension Int
{
	// MARK:  Base System Descriptions
	
/**
	Definition list
		A list of terms and their definitions.
	Format
		Terms left-justified, definitions indented underneath.

	:Field header:
		Field lists are spaced out a little more.

	:Another field: Field lists can start the body immediately, without a line break and indentation.
		Subsequent indented lines are treated as part of the body, too.
*/
	public func	hexDescription(	_ prefix:			Bool	= true,
								fillerDigits:	Bool	= false,
								uppercase:		Bool	= false	) -> String
	{
		let smallVersion = String(UInt(self), radix: 16, uppercase: uppercase)
		
		if fillerDigits
		{
			let extraZeros	= MemoryLayout<Int>.size*2 - smallVersion.characterCount
			let zeroString	= String(repeating: "0", count: extraZeros)
			
			return (prefix ? "0x" : "") + zeroString + smallVersion
		}
		else
		{
			return (prefix ? "0x" : "") + smallVersion
		}
	}
	
	
	public func binaryDescription(	prefix:	Bool	= true,
									fillerDigits:	Bool	= false,
									uppercase:		Bool	= false	) -> String
	{
		let smallVersion = String(UInt(self), radix: 2, uppercase: uppercase)
		
		if fillerDigits
		{
			let extraZeros	= MemoryLayout<Int>.size*8 - smallVersion.characterCount
			let zeroString	= String(repeating: "0", count: extraZeros)
			
			return (prefix ? "0b" : "") + zeroString + smallVersion
		}
		else
		{
			return (prefix ? "0b" : "") + smallVersion
		}
	}
	
	
	public func octalDescription(	_ uppercase:	Bool	= false,
									prefix:		Bool	= true	) -> String
	{
		return (prefix ? "0o" : "") + String(Int(self), radix: 2, uppercase: uppercase)
	}
	
	
	public func descriptionWithRadix(	_ radix:		Int,
										prefix:		String	= "",
										uppercase:	Bool	= false	) -> String
	{
		return prefix + String(Int(self), radix: radix, uppercase: uppercase)
	}
}


