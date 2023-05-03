//
//  Range Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//


public extension Range where Bound: Strideable
{
	/// Advances both the start and end of the range.
	func	advanced(by x: Bound.Stride) -> Range<Bound>
	{
		return lowerBound.advanced(by: x) ..< upperBound.advanced(by: x)
	}
	
	/// Returns the distance between the start and end.  Setting this extends or contracts the end of the range, keeping the start constant.
	var length:	Bound.Stride
	{
		get { return lowerBound.distance(to: upperBound) }
		set { self = lowerBound ..< lowerBound.advanced(by: newValue) }
	}
	
	init(start: Bound, length: Bound.Stride)
	{
		self = start ..< start.advanced(by: length)
	}
	
	init(end: Bound, length: Bound.Stride)
	{
		self = end.advanced(by: -length) ..< end
	}
}

public extension Collection
{
	var indexRange: Range<Index>
		{ return startIndex ..< endIndex }
}
