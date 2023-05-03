//
//  ObjectSet.swift
//  Additions
//
//  Created by Braeden Hintze on 5/30/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

/*
public struct ObjectSet<Element: AnyObject>: Hashable, CollectionType, ArrayLiteralConvertible
{
	private var base: Set<ObjectWrapper<Element>>
	public typealias Index = ObjectSetIndex<Element>
	
	private init(_ set: Set<ObjectWrapper<Element>>)
		{ base = set }
	
	/// Create an empty set with at least the given number of
    /// elements worth of storage.  The actual capacity will be the
    /// smallest power of 2 that's >= `minimumCapacity`.
    public init(minimumCapacity: Int)
		{ base = .init(minimumCapacity: minimumCapacity) }
	
    /// The position of the first element in a non-empty set.
    ///
    /// This is identical to `endIndex` in an empty set.
    ///
    /// - Complexity: Amortized O(1) if `self` does not wrap a bridged
    ///   `NSSet`, O(N) otherwise.
    public var startIndex: ObjectSetIndex<Element>
		{ return ObjectSetIndex(base.startIndex) }
	
    /// The collection's "past the end" position.
    ///
    /// `endIndex` is not a valid argument to `subscript`, and is always
    /// reachable from `startIndex` by zero or more applications of
    /// `successor()`.
    ///
    /// - Complexity: Amortized O(1) if `self` does not wrap a bridged
    ///   `NSSet`, O(N) otherwise.
    public var endIndex: ObjectSetIndex<Element>
		{ return ObjectSetIndex(base.endIndex) }
	
    /// Returns `true` if the set contains a member.
	
    public func contains(member: Element) -> Bool
		{ return base.contains(ObjectWrapper(member)) }
	
    /// Returns the `Index` of a given member, or `nil` if the member is not
    /// present in the set.
	
    public func indexOf(member: Element) -> ObjectSetIndex<Element>?
	{
		guard let index = base.indexOf(ObjectWrapper(member)) else { return nil }
		return ObjectSetIndex(index)
	}
	
    /// Insert a member into the set.
    public mutating func insert(member: Element)
		{ base.insert(ObjectWrapper(member)) }
	
	/// Remove the member from the set and return it if it was present.
    public mutating func remove(member: Element) -> Element?
	{
		guard let member = base.remove(ObjectWrapper(member)) else { return nil }
		return member.object
	}
	
    /// Remove the member referenced by the given index.
    public mutating func removeAtIndex(index: ObjectSetIndex<Element>) -> Element
		{ return base.removeAtIndex(index.base).object }
	
    /// Erase all the elements.  If `keepCapacity` is `true`, `capacity`
    /// will not decrease.
    public mutating func removeAll(keepCapacity keepCapacity: Bool = false)
		{ return base.removeAll(keepCapacity: keepCapacity) }
	
    /// Remove a member from the set and return it.
    ///
    /// - Requires: `count > 0`.
    public mutating func removeFirst() -> Element
		{ return base.removeFirst().object }
	
    /// The number of members in the set.
    ///
    /// - Complexity: O(1).
    public var count: Int
		{ return base.count }
	
    /// Access the member at `position`.
    ///
    /// - Complexity: O(1).
    public subscript (position: ObjectSetIndex<Element>) -> Element
		{ return base[position.base].object }
	
    /// Returns a generator over the members.
    ///
    /// - Complexity: O(1).
    public func generate() -> ObjectSetGenerator<Element>
		{ return ObjectSetGenerator(base.generate()) }
	
    public init(arrayLiteral elements: Element...)
		{ base = Set(elements.lazy.map { ObjectWrapper($0) }) }
	
    /// Create an empty `Set`.
    public init()
		{ base = Set() }
	
    /// Create a `Set` from a finite sequence of items.
    public init<S : SequenceType where S.Generator.Element == Element>(_ sequence: S)
		{ base = Set(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns `true` if the set is a subset of a finite sequence as a `Set`.
    
    public func isSubsetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool
		{ return base.isSubsetOf(sequence.lazy.map { ObjectWrapper($0) }) }
	
	/// Returns `true` if the set is a subset of a finite sequence as a `Set`
    /// but not equal.
    
    public func isStrictSubsetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool
		{ return base.isStrictSubsetOf(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns `true` if the set is a superset of a finite sequence as a `Set`.
    
    public func isSupersetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool
		{ return base.isSupersetOf(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns `true` if the set is a superset of a finite sequence as a `Set`
    /// but not equal.
    
    public func isStrictSupersetOf<S : SequenceType>(sequence: S) -> Bool where S.Generator.Element == Element
		{ return base.isStrictSupersetOf(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns `true` if no members in the set are in a finite sequence as a `Set`.
    
    public func isDisjointWith<S : SequenceType>(sequence: S) -> Bool where S.Generator.Element == Element
		{ return base.isDisjointWith(sequence.lazy.map { ObjectWrapper($0) }) }
    /// Returns a new `Set` with items in both this set and a finite sequence.
	
    
    public func union<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> ObjectSet<Element>
		{ return ObjectSet(base.union(sequence.lazy.map { ObjectWrapper($0) })) }
	
    /// Inserts elements of a finite sequence into this `Set`.
    public mutating func unionInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S)
		{ base.unionInPlace(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns a new set with elements in this set that do not occur
    /// in a finite sequence.
    
    public func subtract<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> ObjectSet<Element>
		{ return ObjectSet(base.subtract(sequence.lazy.map { ObjectWrapper($0) })) }
	
    /// Removes all members in the set that occur in a finite sequence.
    public mutating func subtractInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S)
		{ base.subtractInPlace(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns a new set with elements common to this set and a finite sequence.
    
    public func intersect<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> ObjectSet<Element>
		{ return ObjectSet(base.intersect(sequence.lazy.map { ObjectWrapper($0) })) }
	
    /// Removes any members of this set that aren't also in a finite sequence.
    public mutating func intersectInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S)
		{ base.intersectInPlace(sequence.lazy.map { ObjectWrapper($0) }) }
	
    /// Returns a new set with elements that are either in the set or a finite
    /// sequence but do not occur in both.
    
    public func exclusiveOr<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> ObjectSet<Element>
		{ return ObjectSet(base.exclusiveOr(sequence.lazy.map { ObjectWrapper($0) })) }
	
    /// For each element of a finite sequence, removes it from the set if it is a
    /// common element, otherwise adds it to the set. Repeated elements of the
    /// sequence will be ignored.
    public mutating func exclusiveOrInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S)
		{ base.exclusiveOrInPlace(sequence.lazy.map { ObjectWrapper($0) }) }
	
    public var hashValue: Int
		{ return base.hashValue }
	
    /// `true` if the set is empty.
    public var isEmpty: Bool
		{ return base.isEmpty }
	
    /// The first element obtained when iterating, or `nil` if `self` is
    /// empty.  Equivalent to `self.generate().next()`.
    public var first: Element?
		{ return base.first?.object }
}

private struct ObjectWrapper<T: AnyObject>: Hashable
{
	private let object:		T
	private var address:	UInt
		{ return ObjectIdentifier(object).uintValue }
	private var hashValue:	Int
		{ return unsafeBitCast(address, Int.self) }
	
	init(_ object: T)
		{ self.object = object }
}

public struct ObjectSetIndex<Element: AnyObject>: ForwardIndexType, Comparable
{
	private typealias ObjectBase = SetIndex<ObjectWrapper<Element>>
	private let base:	ObjectBase
	
	private init(_ base: ObjectBase)
		{ self.base = base }
	
	
	/// Returns the next consecutive value after `self`.
    ///
    /// - Requires: The next value is representable.
    public func successor() -> ObjectSetIndex<Element>
		{ return ObjectSetIndex(base.successor()) }
}

public struct ObjectSetGenerator<Element: AnyObject>: GeneratorType
{
	private var base:	SetGenerator<ObjectWrapper<Element>>
	
	private init(_ base: SetGenerator<ObjectWrapper<Element>>)
	{
		self.base = base
	}
	
	/// Advance to the next element and return it, or `nil` if no next
    /// element exists.
    ///
    /// - Requires: No preceding call to `self.next()` has returned `nil`.
    public mutating func next() -> Element?
	{
		guard let n = base.next() else { return nil }
		return n.object
	}
}

extension ObjectSet: CustomStringConvertible, CustomDebugStringConvertible
{
	public var description: String
		{ return base.description }
	public var debugDescription: String
		{ return "Object" + base.debugDescription }
}

extension ObjectSet {
    /// If `!self.isEmpty`, return the first key-value pair in the sequence of
    /// elements, otherwise return `nil`.
    ///
    /// - Complexity: Amortized O(1)
    public mutating func popFirst() -> Element?
		{ return base.popFirst()?.object }
}


private func == <T> (lh: ObjectWrapper<T>, rh: ObjectWrapper<T>) -> Bool
	{ return lh.address == rh.address }

public func == <T> (lh: ObjectSetIndex<T>, rh: ObjectSetIndex<T>) -> Bool
	{ return lh.base == rh.base }

public func < <T> (lh: ObjectSetIndex<T>, rh: ObjectSetIndex<T>) -> Bool
	{ return lh.base < rh.base }

public func == <T> (lh: ObjectSet<T>, rh: ObjectSet<T>) -> Bool
	{ return lh.base == rh.base }

*/

