//
//  Substring (pre-Swift 4).swift
//  Additions
//
//  Created by Braeden Hintze on 2/11/17.
//  Copyright © 2017 Braeden Hintze. All rights reserved.
//

#if swift(>=4)

#else

public struct Substring: BidirectionalCollection
{
	public var slice: BidirectionalSlice<String.CharacterView>
	
	public typealias Index = String.CharacterView.Index
	public typealias SubSequence = Substring
	public typealias Indices = DefaultBidirectionalIndices<BidirectionalSlice<String.CharacterView>>
	
	init(_ slice: BidirectionalSlice<String.CharacterView>)
	{
		self.slice = slice
	}
	
	public init(_ string: String)
	{
		self.init(BidirectionalSlice(base: string, bounds: string.indexRange))
	}
	
	public var indices: Indices
		{ return slice.indices }
	public var startIndex: String.CharacterView.Index
		{ return slice.startIndex }
	public var endIndex: String.CharacterView.Index
		{ return slice.endIndex }
	
	public subscript(_ id: Index) -> Character
		{ return slice[id] }
	public subscript(_ range: Range<Index>) -> Substring
		{ return Substring(slice[range]) }
	
	public func index(after i: String.CharacterView.Index) -> String.CharacterView.Index
		{ return slice.index(after: i) }
	
	public func index(before i: String.CharacterView.Index) -> String.CharacterView.Index
		{ return slice.index(before: i) }
}

extension Substring: CustomStringConvertible, CustomDebugStringConvertible, ExpressibleByStringLiteral
{
	public var description: String
		{ return String(self) }
	public var debugDescription: String
		{ return "Substring(\(String(self))" }
	
	public init(stringLiteral value: String)
		{ self.init(value) }
	public init(unicodeScalarLiteral value: UnicodeScalarType)
		{ self.init(String(value) ?? "") }
	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType)
		{ self.init(String(value) ?? "") }
}


public extension String
{
	init(_ substring: Substring)
	{
		self.init(substring.slice.base[substring.indexRange])
	}
	
	subscript(sub range: Range<Index>) -> Substring
	{
		get { return Substring(BidirectionalSlice(base: characters, bounds: range)) }
		set
		{
			replaceSubrange(range, with: newValue)
		}
	}
}

#endif
