//
//  Array Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//



public extension Sequence
{
	/// Inserts `separator` between all elements in `array`.  Example:  `[0, 1, 2].intersperse(4) == [0, 4, 1, 4, 2]`.
	func interspersing(_ separator: Iterator.Element) -> [Iterator.Element]
	{
		return Array(alternate(self, sequence(first: separator, next: { _ in separator })))
	}


	/// Inserts the elements of `separator` between all elements in `array`.  Example:  `intercalate([5, 6], [0, 1, 2]) == [0, 5, 6, 1, 5, 6, 2]`.
	func intercalating<C: Collection>(_ separator: C) -> [Iterator.Element] where C.Iterator.Element == Self.Iterator.Element
	{
		var thisArray = Array(self)
		
		for i in (1 ..< thisArray.count).reversed()
		{
			thisArray.insert(contentsOf: separator, at: i)
		}
		
		return thisArray
	}

	
	
	/**
		Groups the elements of the receiver into sub-arrays, within which all the elements fulfill `keepTogether`.
		`keepTogether` is assumed to be transitive.  If `keepTogether(a,b))` and `keepTogether(b,c)`, then `keepTogether(a,c)`.
	*/
	func grouped(by keepTogether: (Iterator.Element, Iterator.Element) -> Bool) -> [[Iterator.Element]]
	{
		var groups:	[[Iterator.Element]] = []
		
		for element in self
		{
			// Figure the group to add this element to.
			let groupIndex:	Int
			
			if let existingGroupIndex = groups.firstIndex(where: { keepTogether($0[0], element) })
			{
				// If a group exists that this will fit into, use that.
				groupIndex = existingGroupIndex
			}
			else
			{
				// If no compatible group exists, make a new one.
				groupIndex = groups.count
				groups.append([])
			}
			
			groups[groupIndex].append(element)
		}
		
		return groups
	}
	
	/// Returns a dictionary where the keys are the groupings returned by
	/// the given closure and the values are arrays of the elements that
	/// returned each specific key.
	func grouped<Key: Hashable>(by grouping: (Iterator.Element) throws -> Key) rethrows -> [Key : [Iterator.Element]]
	{
		var groups: [Key : [Iterator.Element]] = [:]
		
		for element in self
		{
			let elementKey = try grouping(element)
			
			groups[elementKey, default: []].append(element)
		}
		
		return groups
	}
	
	
	/// MARK:  Type Queries
	
	/// Returns the first element of the required type.
	func first<T>(ofType type: T.Type) -> T?
	{
		return self.first(where: { $0 is T }) as? T
	}
	
	/// Returns `true` iff the sequence contains and instance of the required type.
	func contains<T>(instanceOf type: T.Type) -> Bool
	{
		return self.contains(where: { $0 is T })
	}
	
	/*
	// These functions all have functionality that can be easily accomplished through composition.
	
	/// Returns the first non-nil result by `transform`ing each element.
	func mappedFirst<T>(by transform: (Iterator.Element) -> T?) -> T?
		{ return self.lazy.flatMap(transform).first }
	*/
}

public extension Sequence where Iterator.Element: Equatable
{
	/**
		Groups the elements of the receiver into sub-arrays, within which all the elements are equal.
	*/
	func	grouped() -> [[Iterator.Element]]
	{
		return self.grouped(by: ==)
	}
}


extension Sequence where Iterator.Element: Sequence
{
	/// Flips the dimensions of the two-dimensional sequence.  Assumes subarrays have the same size.  Example:
	/// ```
	/// transpose([[0, 1], [2, 3], [4, 5]]) == [[0, 2, 4], [1, 3, 5]]
	/// ```
	///
	/// - Precondition:  Dimensions are equal among input rows.  Not like this:  `[[0, 1, 2], [3, 4]]`.
	
	public func	transposed() -> [[Iterator.Element.Iterator.Element]]
	{
		let array = self.map(Array.init)
		
		guard !array.isEmpty else { return [] }
		
		let s2Length = array[0].count
		let s2ArraysShareLength = array.dropFirst().reduce(true) { (flag, s2) in flag && (s2.count == s2Length) }
		guard s2ArraysShareLength else { fatalError() }
		
		return array[0].indices.map { s2Index in array.map { s2Array in s2Array[s2Index] } }
	}
}
