//
//  Array.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//


extension Array
{
	/// Creates an array of a given count, repeatedly calling `elementCreator()` to create each item in the array.
    public init(count: Int, elementCreator: () -> Element)
	{
        self = (0 ..< count).map { _ in elementCreator() }
    }
}

public extension RangeReplaceableCollection where Element: AnyObject
{
	@discardableResult
	mutating func remove(object: Element) -> Element?
	{
		if let index = self.index(ofObject: object)
			{ return self.remove(at: index) }
		else
			{ return nil }
	}
}

public extension RangeReplaceableCollection
{
	@discardableResult
	mutating func	removeFirst(by predicate: (Iterator.Element) throws -> Bool) rethrows -> Iterator.Element?
	{
		guard let index = try firstIndex(where: predicate) else { return nil }
		return self.remove(at: index)
	}
	
	
	@discardableResult
	mutating func	removeAll(by shouldBeRemoved: (Iterator.Element) throws -> Bool) rethrows -> [Iterator.Element]
	{
		var result: [Iterator.Element] = .init()
		
		for i in indices.reversed()
		{
			if try shouldBeRemoved(self[i])
				{ result <<= self.remove(at: i) }
		}
		
		return result
	}
}


public extension RangeReplaceableCollection where Iterator.Element: Equatable
{
	@discardableResult
	mutating func	remove(_ e: Iterator.Element) -> Iterator.Element?
	{
		guard let ind = firstIndex(where: { e == $0 }) else { return nil }
		return self.remove(at: ind)
	}
}

public extension Sequence where Iterator.Element: Equatable
{
	/// Returns `self`, replacing all instances of `target` with `replacement`.
	func	finding(_ target: Iterator.Element, replacingWith replacement: Iterator.Element) -> [Iterator.Element]
	{
		return self.map { ($0 == target) ? replacement : $0 }
	}
	
	/// Returns `self`, replacing all instances of `target` with `replacement`.
	func	finding(_ isTarget: (Iterator.Element) -> Bool, replacingWith replacement: Iterator.Element) -> [Iterator.Element]
	{
		return self.map { isTarget($0) ? replacement : $0 }
	}
}



/// Returns `list`, after removing all elements of `obj`.

public func - <U: Equatable, V: Sequence> (list: [U], other: V) -> [U] where V.Iterator.Element == U
{
	// Include only items that aren't contained in `other`.
	return list.filter
		{ return !other.contains($0) }
}


/// Removes all elements of `obj` from `list`.
public func	-= <U: Equatable, V: Sequence> (list: inout [U], obj: V) where V.Iterator.Element == U
{
	list = list - obj
}


/// Returns `lhs` after appending `rhs`.

public func << <T> (lhs: [T], rhs: T) -> [T]
{
	var result = lhs
	result <<= rhs
	return result
}


/// A wrapper for `lhs.append(rhs)`.
public func	<<= <T> (lhs: inout [T], rhs: T)
{
	lhs.append(rhs)
}


/// Returns `lhs` after removing `rhs`.

public func >> <T: Equatable> (lhs: [T], rhs: T) -> [T]
{
	var result = lhs
	result >>= rhs
	return result
}


/// A wrapper for `lhs.removeElement(rhs)`.
public func	>>= <T: Equatable> (lhs: inout [T], rhs: T)
{
	_ = lhs.remove(rhs)
}




