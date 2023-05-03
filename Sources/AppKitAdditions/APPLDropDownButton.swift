//
//  NSDropDownButton.swift
//  Additions
//
//  Created by Braeden Hintze on 6/25/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import AppKit


class APPLDropDownButton: NSButton
{
	var popUpCell:	NSPopUpButtonCell?
	
	var usesMenu:	Bool
	{
		get { return popUpCell != nil }
		set
		{
			if (popUpCell == nil) && (newValue)
			{
				popUpCell = NSPopUpButtonCell(textCell: "", pullsDown: true)
				popUpCell!.preferredEdge = NSRectEdge.maxY
			}
			else if (popUpCell != nil) && (!newValue)
			{
				popUpCell = nil
			}
		}
	}
	
	func	runPopUp(_ event: NSEvent)
	{
		menu?.insertItem(withTitle: "", action: nil, keyEquivalent: "", at: 0)
		popUpCell?.menu = menu
		popUpCell?.performClick(withFrame: bounds, in: self)
		
		setNeedsDisplay()
	}
	
	override func mouseDown(with theEvent: NSEvent)
	{
		if usesMenu
		{
			runPopUp(theEvent)
			super.mouseDown(with: theEvent)
		}
		else
			{ super.mouseDown(with: theEvent) }
	}
}
