//
//  AppKit Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/20/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import CoreGraphics
import AppKit


public extension NSEvent
{
	static var leftArrowChar: Character		{ return Character(UnicodeScalar(NSLeftArrowFunctionKey)!) }
	static var rightArrowChar: Character	{ return Character(UnicodeScalar(NSRightArrowFunctionKey)!) }
	static var upArrowChar: Character		{ return Character(UnicodeScalar(NSUpArrowFunctionKey)!) }
	static var downArrowChar: Character		{ return Character(UnicodeScalar(NSDownArrowFunctionKey)!) }
	static var escapeChar: Character		{ return "\u{1b}" }
}


public extension NSColor
{
}


// MARK:  Globals
/**
 **  var gGlobal = initial_value
 **
 **/


// MARK:  -
/**
 **
 **
 **/

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
// MARK:  NSColor

/**
 **
 **
 **/
public func			+ (l: NSColor, r: NSColor) -> NSColor
{
	let x = l.usingColorSpace(NSColorSpace.genericRGB)!
	let y = r.usingColorSpace(NSColorSpace.genericRGB)!
	
	return NSColor(	red:	x.redComponent + y.redComponent,
					green:	x.greenComponent + y.greenComponent,
					blue:	x.blueComponent + y.blueComponent,
					alpha:	x.alphaComponent + y.alphaComponent	)
}


/**
 **
 **
 **/
public func			<< (l: NSColor, r: NSColor) -> NSColor
{
	var x = l.usingColorSpace(NSColorSpace.genericRGB)!
	let y = r.usingColorSpace(NSColorSpace.genericRGB)!
	
	x = NSColor(	red:	x.redComponent * x.alphaComponent * (1 - y.alphaComponent),
					green:	x.greenComponent * x.alphaComponent * (1 - y.alphaComponent),
					blue:	x.blueComponent * x.alphaComponent * (1 - y.alphaComponent),
					alpha:	x.alphaComponent * (1 - y.alphaComponent)	)
	
	x = x + NSColor(red:	y.redComponent * y.alphaComponent,
					green:	y.greenComponent * y.alphaComponent,
					blue:	y.blueComponent * y.alphaComponent,
					alpha:	y.alphaComponent	)
	
	return x
}


/**
 **
 **
 **/
public func			* (l: NSColor, r: CGFloat) -> NSColor
{
	let x = l.usingColorSpace(NSColorSpace.genericRGB)!
	
	return NSColor(	red:	x.redComponent * r,
					green:	x.greenComponent * r,
					blue:	x.blueComponent * r,
					alpha:	x.alphaComponent	)
}


/**
 **
 **
 **/
public prefix func		- (c: NSColor) -> NSColor
{
	let x = c.usingColorSpace(NSColorSpace.genericRGB)!
	
	return NSColor(	red:	1.0 - x.redComponent,
					green:	1.0 - x.greenComponent,
					blue:	1.0 - x.blueComponent,
					alpha:	x.alphaComponent	)
}


public func	- (lh: NSColor, rh: NSColor) -> NSColor
{
	return lh + -rh
}

public func	+= (lh: inout NSColor, rh: NSColor)
{
	lh = lh + rh
}

public func	-= (lh: inout NSColor, rh: NSColor)
{
	lh = lh - rh
}


public extension NSView
{
    func	getMouseInBounds() -> NSPoint?
	{
		let screenPoint = NSEvent.mouseLocation
		let windowPoint = window?.convertPointFromScreen(screenPoint)
		if windowPoint == nil
			{ return nil }
		// `fromView: nil` converts from the window's coordinates.
		let viewPoint = convert(windowPoint!, from: nil)
		
		return viewPoint
	}
}


public extension NSWindow
{
    func	convertPointToScreen(_ point: CGPoint) -> CGPoint
	{
		let windowRect = NSRect(origin: point, size: CGSize())
		let screenRect = convertToScreen(windowRect)
		
		return screenRect.origin
	}
	
	
    func	convertPointFromScreen(_ point: CGPoint) -> CGPoint
	{
		let screenRect = NSRect(origin: point, size: CGSize())
		let windowRect = convertFromScreen(screenRect)
		
		return windowRect.origin
	}
}
