//
//  CGSize.swift
//  Additions
//
//  Created by Braeden Hintze on 6/15/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

import CoreGraphics


extension CGSize: CustomStringConvertible { }
public extension CGSize
{
	/// Places x in width and y in height.
    init(_ point: CGPoint)
	{
		self.init(width: point.x, height: point.y)
	}
	
	
    func	inverse() -> CGSize
	{
		return CGSize(width: 1 / width, height: 1 / height)
	}
	
	
	/// Gives the width-to-height ratio (e.g. 16/9 for 1920x1080)
    var aspectRatio:	CGFloat
	{
		return width / height
	}
	
	
	var magnitude:	CGFloat
	{
		return sqrt(width*width + height*height)
	}
	
	
    var description:	String
		{ return "\(width) × \(height))" }
	
    var debugDescription:	String
		{ return "width: \(width), height: \(height))" }
}


/**
 **
 **
 **/
public func			== (l: CGSize, r: CGSize) -> Bool
{
	return (l.width == r.width &&
			l.height == r.height	)
}


/**
 **
 **
 **/
public func			+ (l: CGSize, r: CGSize) -> CGSize
{
	return CGSize(	width:  l.width + r.width,
						height:	l.height + r.height	)
}


/**
 **
 **
 **/
public func			* (l: CGSize, r: CGSize) -> CGSize
{
	return CGSize(	width:  l.width * r.width,
						height:	l.height * r.height	)
}


/// Modulates each element.
public func			% (l: CGSize, r: CGSize) -> CGSize
{
	return CGSize(	width:  l.width.truncatingRemainder(dividingBy: r.width),
						height:	l.height.truncatingRemainder(dividingBy: r.height)	)
}


/// Adds `r` to both elements.
public func			+ (l: CGSize, r: CGFloat) -> CGSize
{
	return CGSize(	width:  l.width + r,
						height:	l.height + r	)
}


/// Modulates each element by `r`.
public func			% (l: CGSize, r: CGFloat) -> CGSize
{
	return CGSize(	width:  l.width.truncatingRemainder(dividingBy: r),
						height:	l.height.truncatingRemainder(dividingBy: r)	)
}


/// Negates both elements.
public prefix func		- (v: CGSize) -> CGSize
{
	return CGSize(	width:  -v.width,
						height:	-v.height	)
}


/// Scales both elements by `r`.
public func			* (l: CGSize, r: Int) -> CGSize
{
	return CGSize(	width:  l.width * r,
					height:	l.height * r	)
}
/// Scales both elements by `r`.
public func			* (l: CGSize, r: Double) -> CGSize
{
	return CGSize(	width:  l.width * r,
					height:	l.height * r	)
}
/// Scales both elements by `r`.
public func			* (l: CGSize, r: Float) -> CGSize
{
	return CGSize(	width:  l.width * r,
					height:	l.height * r	)
}
/// Scales both elements by `r`.
public func			* (l: CGSize, r: CGFloat) -> CGSize
{
	return CGSize(	width:  l.width * r,
					height:	l.height * r	)
}


/// Divides both elements by `r`.
public func			/ (l: CGSize, r: Int) -> CGSize
{
	return CGSize(	width:  l.width / r,
					height:	l.height / r	)
}
/// Divides both elements by `r`.
public func			/ (l: CGSize, r: Double) -> CGSize
{
	return CGSize(	width:  l.width / r,
					height:	l.height / r	)
}
/// Divides both elements by `r`.
public func			/ (l: CGSize, r: Float) -> CGSize
{
	return CGSize(	width:  l.width / r,
					height:	l.height / r	)
}
/// Divides both elements by `r`.
public func			/ (l: CGSize, r: CGFloat) -> CGSize
{
	return CGSize(	width:  l.width / r,
					height:	l.height / r	)
}


public func	- (lh: CGSize, rh: CGSize) -> CGSize
{
	return lh + -rh
}

public func	/ (lh: CGSize, rh: CGSize) -> CGSize
{
	return lh * rh.inverse()
}

public func	+= (lh: inout CGSize, rh: CGSize)
{
	lh = lh + rh
}

public func	-= (lh: inout CGSize, rh: CGSize)
{
	lh = lh - rh
}

public func	*= (lh: inout CGSize, rh: CGSize)
{
	lh = lh * rh
}

public func	/= (lh: inout CGSize, rh: CGSize)
{
	lh = lh / rh
}


public func	- (lh: CGSize, rh: CGFloat) -> CGSize
{
	return lh + -rh
}

public func	+= (lh: inout CGSize, rh: CGFloat)
{
	lh = lh + rh
}

public func	-= (lh: inout CGSize, rh: CGFloat)
{
	lh = lh - rh
}


public func	*= (lh: inout CGSize, rh: Int)
{
	lh = lh * rh
}

public func	*= (lh: inout CGSize, rh: Float)
{
	lh = lh * rh
}

public func	*= (lh: inout CGSize, rh: Double)
{
	lh = lh * rh
}

public func	*= (lh: inout CGSize, rh: CGFloat)
{
	lh = lh * rh
}


public func	/= (lh: inout CGSize, rh: Int)
{
	lh = lh / rh
}

public func	/= (lh: inout CGSize, rh: Float)
{
	lh = lh / rh
}

public func	/= (lh: inout CGSize, rh: Double)
{
	lh = lh / rh
}

public func	/= (lh: inout CGSize, rh: CGFloat)
{
	lh = lh / rh
}
