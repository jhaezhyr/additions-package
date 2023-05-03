//
//  Dictionary Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/8/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//


public extension Dictionary
{
	//typealias Element = (key: Key, value: Value)

	/// Creates a new dictionary using the key/value pairs in the given sequence.
	/// If the given sequence has any duplicate keys, the result is `nil`.
    init?<S: Sequence>(keysAndValues: S) where S.Iterator.Element == (Key, Value)
	{
		self.init()
		for (k, v) in keysAndValues
		{
			guard self[k] == nil else { return nil }
			self[k] = v
		}
	}

	/// Creates a new dictionary using the key/value pairs in the given sequence,
	/// using a combining closure to determine the value for any duplicate keys.
    init<S: Sequence>(merging keysAndValues: S, combine: (Value, Value) throws -> Value) rethrows where S.Iterator.Element == Element
	{
		self.init()
		for (k, v) in keysAndValues
		{
			if let oldValue = self[k]
				{ self[k] = try combine(oldValue, v) }
			else
				{ self[k] = v }
		}
	}

	/// Merges the key/value pairs in the given sequence into the dictionary,
	/// using a combining closure to determine the value for any duplicate keys.
    mutating func merge<S: Sequence>(contentsOf other: S, combine: (Value, Value) throws -> Value) rethrows where S.Iterator.Element == Element
	{
		for (k, v) in other
		{
			if let oldValue = self[k]
				{ self[k] = try combine(oldValue, v) }
			else
				{ self[k] = v }
		}
	}

	/// Returns a new dictionary created by merging the key/value pairs in the 
	/// given sequence into the dictionary, using a combining closure to determine 
	/// the value for any duplicate keys.
    func merged<S: Sequence>(with other: S, combine:  (Value, Value) throws -> Value) rethrows -> [Key: Value] where S.Iterator.Element == Element
	{
		var new = self
		try new.merge(contentsOf: other, combine: combine)
		return new
	}
	
	/*
	/// Accesses the element with the given key, or the specified default value,
	/// if the dictionary doesn't contain the given key.
	subscript(key: Key, default defaultValue: Value) -> Value
	{
		get { return self[key] ?? defaultValue }
		set { self[key] = newValue }
	}
*/
}
