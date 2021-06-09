//
//  New Sequences.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//



/// Returns a sequence that alternates elements between `s1` and `s2`.
///
/// The sequence terminates as soon as either sequence has a "turn" and cannot provide an element.
///
/// `alternate([1,2,3,4,5],[6,7,8])` outputs "1, 6, 2, 7, 3, 8, 4"
public func alternate<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> Alternate2Sequence<S1, S2> where S1.Iterator.Element == S2.Iterator.Element
{
	return Alternate2Sequence(s1: s1, s2: s2)
}


/// A sequence that alternates elements between two sequences.  Created using `alternate(_:_:)
///
/// The sequence terminates as soon as either sequence has a "turn" and cannot provide an element.
///
/// `alternate([1,2,3,4,5],[6,7,8])` outputs "1, 6, 2, 7, 3, 8, 4"

public struct Alternate2Sequence<S1: Sequence, S2: Sequence>: Sequence, IteratorProtocol where S1.Iterator.Element == S2.Iterator.Element
{
	public typealias Element = S1.Iterator.Element
	
	var s1: S1.Iterator
	var s2: S2.Iterator
	var useS1 = true
	
	init(s1: S1, s2: S2)
	{
		// NOTE:  Is this safe?
		self.s1 = s1.makeIterator()
		self.s2 = s2.makeIterator()
	}
	
	public mutating func next() -> Element?
	{
		// in `alternate([1,2],[3]), it should end up with [1,3,2].
		// If either sequence returns `nil`, then that ends the sequence.
		
		defer { useS1 = !useS1 }
		return useS1 ? s1.next() : s2.next()
	}
}


///
public struct PairPermutationSequence<S: Sequence>: IteratorProtocol, Sequence
{
	public typealias Element = (S.Element, S.Element)
	
	let source: S
	let includeIdentityPairs: Bool
	
	var firstIterator: AnyIterator<(offset: Int, element: S.Element)>
	var currentFirstIndex: Int
	var currentFirstItem: S.Element
	var secondIterator: S.Iterator
	
	public init(for source: S, includingIdentityPairs: Bool = false)
	{
		self.source = source
		self.includeIdentityPairs = includingIdentityPairs
		
		if includeIdentityPairs
			{ self.firstIterator = AnyIterator(source.enumerated().dropLast(0).makeIterator()) }
		else
			{ self.firstIterator = AnyIterator(source.enumerated().dropLast().makeIterator()) }
		
		let (i, first) = firstIterator.next()!
		self.currentFirstIndex = i
		self.currentFirstItem = first
		
		secondIterator = source.dropFirst(includeIdentityPairs ? i : i+1).makeIterator()
	}
	
	public mutating func next() -> (S.Element, S.Element)?
	{
		let second: S.Element
		
		if let candidate = secondIterator.next()
		{
			second = candidate
		}
		else
		{
			guard let (i, chosen) = firstIterator.next() else { return nil }
			self.currentFirstIndex = i
			self.currentFirstItem = chosen
			
			self.secondIterator = source.dropFirst(includeIdentityPairs ? i : i+1).makeIterator()
			
			second = secondIterator.next()!
		}
		
		return (self.currentFirstItem, second)
	}
	
	public func makeIterator() -> PairPermutationSequence<S>
		{ return self }
	
	/*
		// Replicates this behavior
	
		for (i, first) in source.enumerated().dropLast()
		{
			for second in source.dropFirst(i+1)
			{
				Yippee!  Do stuff!
			}
		}
	*/
}


#if swift(>=3.0)
// Not necessary here
#else
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

/// Returns a sequence formed from `first` and repeated lazy applications of
/// `next`.
///
/// The first element in the sequence is always `first`, and each successive
/// element is the result of invoking `next` with the previous element. The
/// sequence ends when `next` returns `nil`. If `next` never returns `nil`, the
/// sequence is infinite.
///
/// This function can be used to replace many cases that were previously handled
/// using C-style `for` loops.
///
/// Example:
///
///     // Walk the elements of a tree from a node up to the root
///     for node in sequence(first: leaf, next: { $0.parent }) {
///       // node is leaf, then leaf.parent, then leaf.parent.parent, etc.
///     }
///
///     // Iterate over all powers of two (ignoring overflow)
///     for value in sequence(first: 1, next: { $0 * 2 }) {
///       // value is 1, then 2, then 4, then 8, etc.
///     }
///
/// - Parameter first: The first element to be returned from the sequence.
/// - Parameter next: A closure that accepts the previous sequence element and
///   returns the next element.
/// - Returns: A sequence that starts with `first` and continues with every
///   value returned by passing the previous element to `next`.
///
/// - SeeAlso: `sequence(state:next:)`
public func sequence<T>(first: T, next: (T) -> T?) -> UnfoldSequence<T, (T?, Bool)> {
  // The trivial implementation where the state is the next value to return
  // has the downside of being unnecessarily eager (it evaluates `next` one
  // step in advance). We solve this by using a boolean value to disambiguate
  // between the first value (that's computed in advance) and the rest.
  return sequence(state: (first, true), next: { (state: inout (T?, Bool)) -> T? in
    switch state {
    case (let value, true):
      state.1 = false
      return value
    case (let value?, _):
      let nextValue = next(value)
      state.0 = nextValue
      return nextValue
    case (nil, _):
      return nil
    }
  })
}

/// Returns a sequence formed from `first` and repeated lazy applications of
/// `next`.
///
/// The first element in the sequence is always `first`, and each successive
/// element is the result of invoking `next` with the previous element. The
/// sequence ends when `next` returns `nil`. If `next` never returns `nil`, the
/// sequence is infinite.
///
/// This function can be used to replace many cases that were previously handled
/// using C-style `for` loops.
///
/// Example:
///
///     // Walk the elements of a tree from a node up to the root
///     for node in sequence(first: leaf, next: { $0.parent }) {
///       // node is leaf, then leaf.parent, then leaf.parent.parent, etc.
///     }
///
///     // Iterate over all powers of two (ignoring overflow)
///     for value in sequence(first: 1, next: { $0 * 2 }) {
///       // value is 1, then 2, then 4, then 8, etc.
///     }
///
/// - Parameter first: The first element to be returned from the sequence.
/// - Parameter next: A closure that accepts the previous sequence element and
///   returns the next element.
/// - Returns: A sequence that starts with `first` and continues with every
///   value returned by passing the previous element to `next`.
///
/// - SeeAlso: `sequence(state:next:)`
public func sequence<T>(optionalFirst first: T?, next: (T) -> T?) -> UnfoldSequence<T, (T?, Bool)> {
  // The trivial implementation where the state is the next value to return
  // has the downside of being unnecessarily eager (it evaluates `next` one
  // step in advance). We solve this by using a boolean value to disambiguate
  // between the first value (that's computed in advance) and the rest.
  return sequence(state: (first, true), next:
  {
  	(state: inout (T?, Bool)) -> T? in
	
    switch state {
    case (let value, true):
      state.1 = false
      return value
    case (let value?, _):
      let nextValue = next(value)
      state.0 = nextValue
      return nextValue
    case (nil, _):
      return nil
    }
  })
}

/// Returns a sequence formed from repeated lazy applications of `next` to a
/// mutable `state`.
///
/// The elements of the sequence are obtained by invoking `next` with a mutable
/// state. The same state is passed to all invocations of `next`, so subsequent
/// calls will see any mutations made by previous calls. The sequence ends when
/// `next` returns `nil`. If `next` never returns `nil`, the sequence is
/// infinite.
///
/// This function can be used to replace many instances of `AnyIterator` that
/// wrap a closure.
///
/// Example:
///
///     // Interleave two sequences that yield the same element type
///     sequence(state: (false, seq1.makeIterator(), seq2.makeIterator()), next: { iters in
///       iters.0 = !iters.0
///       return iters.0 ? iters.1.next() : iters.2.next()
///     })
///
/// - Parameter state: The initial state that will be passed to the closure.
/// - Parameter next: A closure that accepts an `inout` state and returns the
///   next element of the sequence.
/// - Returns: A sequence that yields each successive value from `next`.
///
/// - SeeAlso: `sequence(first:next:)`
public func sequence<T, State>(state: State, next: (inout State) -> T?)
  -> UnfoldSequence<T, State> {
  return UnfoldSequence(_state: state, _next: next)
}

/// The return type of `sequence(first:next:)`.
//public typealias UnfoldFirstSequence<T> = UnfoldSequence<T, (T?, Bool)>

/// A sequence whose elements are produced via repeated applications of a
/// closure to some mutable state.
///
/// The elements of the sequence are computed lazily and the sequence may
/// potentially be infinite in length.
///
/// Instances of `UnfoldSequence` are created with the functions
/// `sequence(first:next:)` and `sequence(state:next:)`.
///
/// - SeeAlso: `sequence(first:next:)`, `sequence(state:next:)`
public struct UnfoldSequence<Element, State> : Sequence, IteratorProtocol {
  public mutating func next() -> Element? {
    guard !_done else { return nil }
    if let elt = _next(&_state) {
        return elt
    } else {
        _done = true
        return nil
    }
  }

  internal init(_state: State, _next: (inout State) -> Element?) {
    self._state = _state
    self._next = _next
  }

  internal var _state: State
  internal let _next: (inout State) -> Element?
  internal var _done = false
}

#endif

