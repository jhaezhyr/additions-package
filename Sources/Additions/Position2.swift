//
//  Position2.swift
//  Cabinet Zen
//
//  Created by Braeden Hintze on 12/12/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//


public struct Position2
{
	/// `true` if max, `false` if min, `nil` if this grip doesn't affect
	public var x: Bool?
	public var y: Bool?
	
	public static var minX: Position2 { return Position2(x: false, y: nil) }
	public static var minY: Position2 { return Position2(x: nil, y: false) }
	
	public static var maxX: Position2 { return Position2(x: true, y: nil) }
	public static var maxY: Position2 { return Position2(x: nil, y: true) }
	
	public static var minXminY: Position2 { return Position2(x: false, y: false) }
	public static var minXmaxY: Position2 { return Position2(x: false, y: true) }
	public static var maxXminY: Position2 { return Position2(x: true, y: false) }
	public static var maxXmaxY: Position2 { return Position2(x: true, y: true) }
	
	public var rawValue: (Bool?, Bool?)
		{ return (x, y) }
	
	public init(x: Bool?, y: Bool?)
	{
		self.x = x
		self.y = y
	}
	
	public init?(rawValue: (Bool?, Bool?))
	{
		self.x = rawValue.0
		self.y = rawValue.1
	}
	
	public var hashValue: Int
		{ return (x?.hashValue ?? 0) ^ (y?.hashValue ?? 0) }
	
	public static func == (lh: Position2, rh: Position2) -> Bool
		{ return lh.x == rh.x && lh.y == rh.y }
	
	public var inverted: Position2
		{ return Position2(x: x.map(!), y: y.map(!)) }
}


