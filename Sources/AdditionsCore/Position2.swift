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
    
    public init(x: Bool? = nil, y: Bool? = nil)
    {
        self.x = x
        self.y = y
    }
}

extension Position2: Hashable, Equatable, Codable {}

extension Position2: RawRepresentable
{
    public var rawValue: (Bool?, Bool?)
        { return (x, y) }
    
    public init?(rawValue: (Bool?, Bool?))
    {
        self.x = rawValue.0
        self.y = rawValue.1
    }
}

extension Position2
{
    public static let center = Position2(x: nil, y: nil)
    
    public static let minX = Position2(x: false, y: nil)
    public static let minY = Position2(x: nil, y: false)
    
    public static let maxX = Position2(x: true, y: nil)
    public static let maxY = Position2(x: nil, y: true)
    
    public static let minXminY = Position2(x: false, y: false)
    public static let minXmaxY = Position2(x: false, y: true)
    public static let maxXminY = Position2(x: true, y: false)
    public static let maxXmaxY = Position2(x: true, y: true)
    
    public static let allSides = [Position2.minX, .minY, .maxX, .maxY]
    public static let allCorners = [Position2.minXminY, .minXmaxY, .maxXminY, .maxXmaxY]
    public static let allValues = [Position2.center] + allSides + allCorners
}

extension Position2
{
    public var inverted: Position2
        { return Position2(x: x.map(!), y: y.map(!)) }
}
