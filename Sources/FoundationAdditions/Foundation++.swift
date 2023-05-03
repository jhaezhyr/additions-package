//
//  Foundation Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Foundation


public extension URL
{
	var isDirectory:	Bool!
	{/*
		var value:	AnyObject?	= nil
		
		do
		{
			try getResourceValue(&value, forKey: URLResourceKey.isDirectoryKey)
			if let isDirectory = value as? NSNumber
			{
				return isDirectory.boolValue
			}
		}
		catch _ as NSError
			{ }
		
		return nil*/
		
		return (try? (self.resourceValues(forKeys: [.isDirectoryKey]).isDirectory))?.flatMap { $0 }
	}
	
	
	var typeIdentifier:	String!
	{
		return (try? (self.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier))?.flatMap { $0 }
	}
}

public extension String
{
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = range.lowerBound.samePosition(in: utf16view)!
        let to = range.upperBound.samePosition(in: utf16view)!
        return NSMakeRange(	utf16view.distance(from: utf16view.startIndex, to: from),
							utf16view.distance(from: from, to: to)		)
    }
}

public extension String
{
    func range(from nsRange: NSRange) -> Range<String.Index>?
	{
		let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location)//, limit: utf16.endIndex)
		let to16 = utf16.index(from16, offsetBy: nsRange.length)//, limit: utf16.endIndex)
        guard
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
}
