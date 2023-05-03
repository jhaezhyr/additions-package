//
//  Collection.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphicsAdditions




// MARK:  CollectionType

/*
// These functions all have functionality that can be easily accomplished through composition.

public extension Collection
{
	/// Returns the Int-index (offset) of any element passing `filter`.
	func intIndices(where myFilter: (Iterator.Element) throws -> Bool) rethrows -> [Int]
		{ return try self.enumerated().flatMap { try myFilter($0.element) ? Optional($0.offset) : nil } }
	
	/// Like `enumerated()`, instead returning the native indices, not offsets.
	func baseEnumerated() -> Zip2Sequence<Indices, Self>
		{ return zip(indices, self) }
	
	/// Returns the native indices of all elements that fulfill the filter
	func indices(where myFilter: (Iterator.Element) throws -> Bool) rethrows -> [Index]
		{ return try zip(indices, self).flatMap { try myFilter($0.1) ? Optional($0.0) : nil } }
}
*/

public extension Collection
{
	/// Equivalent to `self[index]` unless index is outside the valid range of the reciever, like negative numbers or too high of indices.
	func	element(at index: Index) -> Iterator.Element?
	{
	/// TODO:  Test.  Maybe "Fix!"
		// Only return `self[index]` if our index is within the range (neither < startIndex or >= endIndex)
		if indices.contains(index)//(index.distanceTo(startIndex) > 0) || (index.distanceTo(endIndex) <= 0)
			{ return self[index] }
		else
			{ return nil }
	}
}


public extension Collection where Self.Element: AnyObject
{
	/// Returns the index of object collection `object` in `source`, if it exists.
	func	index(ofObject sought: Element) -> Index?
	{
		for (i, thisObject) in zip(indices, self)
		{
			if thisObject === sought
				{ return i }
		}
		
		return nil
	}
	
	/// Checks object collection `source` for the existence of `object`.
	func	contains(object sought: Element) -> Bool
	{
		for thisObject in self
		{
			if thisObject === sought
				{ return true }
		}
		
		return false
	}
}


public extension MutableCollection where Index: UniformRandom
{
	/// Shuffles the collection.
	///
	/// Using the random functions defined in Additions, reorganizes the values in the collection evenly.  Each value in the old collection has an equal chance to land in any position in the new collection.
	/// Complexity is O(n), given that `swapAt(_:_:)` is O(1).
	mutating func shuffle()
	{
		for i in indices.reversed()
		{
			let j = Index.random(startIndex ... i)
			if (j != i)
				{ self.swapAt(i, j) }
		}
	}
	
	/// Returns a shuffled copy of the collection.
	///
	/// Requires that the collection is a value type.
	func shuffled() -> Self
	{
		var newOne = self
		newOne.shuffle()
		return newOne
	}
}



public protocol CollectionWrapper: Collection
{
	associatedtype Storage = Array<Iterator.Element>
	var storage: Storage { get }
}

public extension CollectionWrapper where
	Storage: Collection
{
	var count: Int
		{ return storage.count }
}

public extension CollectionWrapper where
	Storage: Collection,
	Iterator == Storage.Iterator
{
	func makeIterator() -> Iterator
		{ return storage.makeIterator() }
}

public extension CollectionWrapper where
	Storage: Collection,
	Index == Storage.Index
{
	func index(after i: Index) -> Index
		{ return storage.index(after: i) }
	var startIndex: Index
		{ return startIndex }
	var endIndex: Index
		{ return endIndex }

}

public extension CollectionWrapper where
	Storage: Collection
{
	// COMPILER FIXME
	var indices: Indices
		{ return storage.indices as! Indices }

}

public extension CollectionWrapper where
	Storage: Collection,
	Iterator.Element == Storage.Iterator.Element,
	Index == Storage.Index
{
	subscript(index: Index) -> Iterator.Element
		{ return storage[index] }

}
