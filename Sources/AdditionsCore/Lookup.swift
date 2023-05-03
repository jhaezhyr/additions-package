//
//  Lookup.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/17.
//  Copyright © 2017 Braeden Hintze. All rights reserved.
//


/// Used as the key to a lookup-table array.
///
/// Keys must have rawValues that fill a range of 0 ..< n.
///	````
///		enum Color: Int
///		{
///			// Raw values start at 0, increasing with no gaps.
///			case red = 0, blue = 1, green = 2, yellow = 3
///			static var all: [Color] { return [Color.red, .blue, .green, .yellow] }
///		}
///
///		var costs = Lookup(key: Color.self, [])
/// ````
/// Only operates with correct constraints in Swift 4.
public protocol LookupKey: RawRepresentable where RawValue == Int
{
	/// Returns all possible values of the type.  The array does not need to be sorted by `rawValue`s.
	static var all: [Self] { get }
}


public typealias Lookup<Enum, Value> = Array<Value>


public extension Lookup
{
	init<K: LookupKey, S: Sequence>(key: K.Type, _ values: S)
		where S.Iterator.Element == Iterator.Element
	//	, K.RawValue == Int
	{
		self.init(values)
	}
	
	subscript<K: LookupKey>(key: K) -> Iterator.Element
	//	where K.RawValue == Int
	{
		get { return self[key.rawValue] }
		set { self[key.rawValue] = newValue }
	}
}
