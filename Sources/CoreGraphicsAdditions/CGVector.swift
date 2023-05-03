//
//  CGVector.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphics


public extension CGVector
{
    init(_ point: CGPoint)
	{
		self.init(dx: point.x, dy: point.y)
	}
	
    init(radius: CGFloat, radians: CGFloat)
	{
		self.init(radius: radius, angle: Angle(radians))
	}
    init(radius: CGFloat, degrees: CGFloat)
	{
		self.init(radius: radius, radians: radian(from: degrees))
	}
    init(radius: CGFloat, angle a: Angle)
	{
		self.init(dx: radius * cos(a),dy: radius * sin(a))
	}
	
	
    var magnitude:	CGFloat
	{
		get { return sqrt(dx*dx + dy*dy) }
		set
		{
			let ratio			= newValue / magnitude
			
			dx *= ratio
			dy *= ratio
		}
	}
	/// The angle of the vector in radians, within the interval (-π, π].
    var angle:		Angle
	{
		get
		{
			if (dx > 0) // Quadrants 1 and 4
			{
			//	asin y/r = theta
				return asin(dy/magnitude)
			}
			else // Quadrants 2 and 3
			{
				let raw:	Angle = asin(dy/magnitude)
				
				if (raw < 0) // Lower half of circle, excluding 180°.
				{
					// d = raw + π/2
					// return -π/2 - d
					
					return -π - raw
				}
				else // Upper half and 180°.
				{
					// d = π/2 - raw
					// return π/2 + d
					
					return π - raw
				}
			}
		}
		
		set
		{
			let radius	= magnitude
			
			dx = radius * cos(newValue)
			dy = radius * sin(newValue)
		}
	}
	
	/**
	 **
	 **
	 **/
    func		inverse() -> CGVector
	{
		return CGVector(dx:  1/dx,
						dy:  1/dy )
	}
	
	
	/**
	 **
	 **
	 **/
    subscript(id: Int) -> CGFloat
	{
		switch id
		{
			case 0:
				return dx
			case 1:
				return dy
			default:
				fatalError("Cannot access the \(id)th element of a 2D CGVector")
		}
	}
	
	
    var description:	String
		{ return "(\(dx), \(dy))" }
	
    var debugDescription:	String
		{ return "dx: \(dx), dy: \(dy)" }
}


/**
 **
 **
 **/
public func			== (l: CGVector, r: CGVector) -> Bool
{
	return (l.dx == r.dx &&
			l.dy == r.dy	)
}


/**
 **
 **
 **/
public func			+ (l: CGVector, r: CGVector) -> CGVector
{
	return CGVector(	dx:  l.dx + r.dx,
						dy:	l.dy + r.dy	)
}


/**
 **
 **
 **/
public func			* (l: CGVector, r: CGVector) -> CGVector
{
	return CGVector(	dx:  l.dx * r.dx,
						dy:	l.dy * r.dy	)
}


/**
 **
 **
 **/
public func			% (l: CGVector, r: CGVector) -> CGVector
{
	return CGVector(	dx:  l.dx.truncatingRemainder(dividingBy: r.dx),
						dy:	l.dy.truncatingRemainder(dividingBy: r.dy)	)
}


/**
 **
 **
 **/
public func			+ (l: CGVector, r: CGFloat) -> CGVector
{
	return CGVector(	dx:  l.dx + r,
						dy:	l.dy + r	)
}


/**
 **
 **
 **/
public func			% (l: CGVector, r: CGFloat) -> CGVector
{
	return CGVector(	dx:  l.dx.truncatingRemainder(dividingBy: r),
						dy:	l.dy.truncatingRemainder(dividingBy: r)	)
}


/**
 **
 **
 **/
public prefix func		- (v: CGVector) -> CGVector
{
	return CoreGraphics.CGVector.init(	dx:  -v.dx,
						dy:	-v.dy	)
}


public func			* (l: CGVector, r: Int) -> CGVector
{
	return CGVector(	dx:  l.dx * r,
					dy:	l.dy * r	)
}
public func			* (l: CGVector, r: Double) -> CGVector
{
	return CGVector(	dx:  l.dx * r,
					dy:	l.dy * r	)
}
public func			* (l: CGVector, r: Float) -> CGVector
{
	return CGVector(	dx:  l.dx * r,
					dy:	l.dy * r	)
}
public func			* (l: CGVector, r: CGFloat) -> CGVector
{
	return CGVector(	dx:  l.dx * r,
					dy:	l.dy * r	)
}


public func			/ (l: CGVector, r: Int) -> CGVector
{
	return CGVector(	dx:  l.dx / r,
					dy:	l.dy / r	)
}
public func			/ (l: CGVector, r: Double) -> CGVector
{
	return CGVector(	dx:  l.dx / r,
					dy:	l.dy / r	)
}
public func			/ (l: CGVector, r: Float) -> CGVector
{
	return CGVector(	dx:  l.dx / r,
					dy:	l.dy / r	)
}
public func			/ (l: CGVector, r: CGFloat) -> CGVector
{
	return CGVector(	dx:  l.dx / r,
					dy:	l.dy / r	)
}


public func	- (lh: CGVector, rh: CGVector) -> CGVector
{
	return lh + -rh
}

public func	/ (lh: CGVector, rh: CGVector) -> CGVector
{
	return lh * rh.inverse()
}

public func	+= (lh: inout CGVector, rh: CGVector)
{
	lh = lh + rh
}

public func	-= (lh: inout CGVector, rh: CGVector)
{
	lh = lh - rh
}

public func	*= (lh: inout CGVector, rh: CGVector)
{
	lh = lh * rh
}

public func	/= (lh: inout CGVector, rh: CGVector)
{
	lh = lh / rh
}


public func	- (lh: CGVector, rh: CGFloat) -> CGVector
{
	return lh + -rh
}

public func	+= (lh: inout CGVector, rh: CGFloat)
{
	lh = lh + rh
}

public func	-= (lh: inout CGVector, rh: CGFloat)
{
	lh = lh - rh
}


public func	*= (lh: inout CGVector, rh: Int)
{
	lh = lh * rh
}

public func	*= (lh: inout CGVector, rh: Float)
{
	lh = lh * rh
}

public func	*= (lh: inout CGVector, rh: Double)
{
	lh = lh * rh
}

public func	*= (lh: inout CGVector, rh: CGFloat)
{
	lh = lh * rh
}


public func	/= (lh: inout CGVector, rh: Int)
{
	lh = lh / rh
}

public func	/= (lh: inout CGVector, rh: Float)
{
	lh = lh / rh
}

public func	/= (lh: inout CGVector, rh: Double)
{
	lh = lh / rh
}

public func	/= (lh: inout CGVector, rh: CGFloat)
{
	lh = lh / rh
}
