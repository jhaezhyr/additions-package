//
//  String Extensions.swift
//  Additions
//
//  Created by Braeden Hintze on 6/26/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Foundation
import CollectionsAdditions


public extension String
{
	/// Separates the reciever into an array of substrings, dividing along any character contained in `dividers`.  Iff `insertDividers`, the dividing characters are included as elements in the resulting array.
    func	explodeByCharacter<T: Collection>(dividers: T, insertDividers: Bool = false) -> [String] where T.Iterator.Element == Character
	{
		var result:		[String] = []
		var building:	String = ""
		
		
		for char in self
		{
			if dividers.contains(char)
			{
				if (building != "")
				{
					result.append(building)
					building = ""
				}
				
				if insertDividers
					{ result.append(String(char)) }
			}
			else
			{
				building.append(char)
			}
		}
		
		if (building != "")
		{
			result.append(building)
		}
		
		return result
	}
	
	/// Splits the string using an array of given dividers.  Optionally, the appropriate divider can be reinserted into the resulting array.  Note that no element of `dividers` should fully include another (as in `["**", "*"]`).
	///
	/// Examples:
	/// - `"little-minded folks".split([" ", "-"]) == ["little", "minded", "folks"]`
	///	- `"little-minded folks".split([" ", "-"], insertDividers: true) == ["little", "-", "minded", " ", "folks"]`
    func split(_ dividers: [String], insertDividers: Bool = false) -> [String]
	{
		//let dividers = dividers.sort { $0.0.characterCount < $0.1.characterCount }
		var result:	[String]	= [self]
		
		for div in dividers
		{
			var newResult	= [String]()
			
			for el in result
			{
				var lastIndex = el.startIndex
				
				// Repeatedly look for an instance of this `div` within this `el`.  For each one, add the text we know doesn't contain it (before the instance), and optionally the divider itself.
				while let range = el.range(of: div, range: lastIndex ..< el.endIndex)
				{
					// Insert the text preceding this instance.
					let coveredString = el[lastIndex ..< range.lowerBound]
					newResult.append(String(coveredString))
					
					// Optionally insert the divider here, too.
					if insertDividers
						{ newResult.append(div) }
					
					lastIndex = range.upperBound
				}
				
				let tail = el[lastIndex ..< el.endIndex]
				newResult.append(String(tail))
			}
			
			result = newResult
		}
		
		return result
	}
	
	/*
	
	public subscript(index: Int) -> Character
	{
		get { return self[startIndex.advancedBy(index)] }
		set(newValue)
		{
			let abstract = self.startIndex.advancedBy(index)
			
			self.insert(newValue, atIndex: abstract)
			self.removeAtIndex(self.startIndex.advancedBy(index+1))
		}
	}*/
}


//
//  String Extensions.swift
//  Text Stringer
//
//  Created by Braeden Hintze on 1/2/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//


public let kTitleCaseExempt = ["a", "in", "for", "to", "an", "of", "at", "by", "and", "but", "yet", "on", "per", "or", "nor", "from", "with", "into", "onto", "as"]
public let kSentenceEnd = [".", "!", "?", "‽"] as [Character]


public extension Character
{
	var uppercase:		Character
	{
		return Character(String(self).uppercased())
	}
	
	var lowercase:		Character
	{
		return Character(String(self).lowercased())
	}
	
	var isWhitespace:	Bool
	{
		let whitespace = CharacterSet.whitespaces
		return whitespace.contains(UnicodeScalar(String(self).utf16.first!)!)
	}
	
	var isNewline:		Bool
	{
		let endline = CharacterSet.newlines
		return endline.contains(UnicodeScalar(String(self).utf16.first!)!)
	}
	
	var isSentenceEnd:	Bool
	{
		return isNewline || kSentenceEnd.contains(self)
	}
	
	var isAlphanumeric:	Bool
	{
		let endline = CharacterSet.alphanumerics
		return endline.contains(UnicodeScalar(String(self).utf16.first!)!)
	}
}


public extension String
{
/*	public subscript(index: Index) -> Character
	{
		get { return self[index] }
		set
		{
			let prefix = self[startIndex ..< index]
			let postfix = self[self.index(after: index)...]
			self = prefix + String(newValue) + postfix
		}
	}*/
	
    var isWhitespace:	Bool
	{
		for c in self
		{
			if c.isWhitespace
				{ return true }
		}
		
		return false
	}
	
    var isWhiteOrFiller:Bool
	{
		for c in self
		{
			if c.isWhitespace || c.isNewline
				{ return true }
		}
		
		return false
	}
	
    var sentenceCase:	String
	{
		var result = lowercased()
		var sentenceWillBegin = true
		
		for i in indices
		{
			let character = result[i]
			
			if character.isSentenceEnd
			{
				sentenceWillBegin = true
			}
			else if character.isAlphanumeric && sentenceWillBegin
			{
				result.replaceSubrange(i...i, with: [character.uppercase])
				// NOTE:  The below line will not run because of the compiler's inability to sort out between Swift.String.subscript.get and Additions.String.subscript.get, when it's defined.
				//result[i] = character.uppercase
				sentenceWillBegin = false
			}
		}
		
		return result
	}
	
    var titleCase:		String
	{
		var result = capitalized(with: Locale.current)
		
		for word in kTitleCaseExempt
		{
			result = result.replacingOccurrences(of: word, with: word, options: [.caseInsensitive, .widthInsensitive])
		}
		
		return result
	}
	
    func	correctCaseWithWords(_ reference: [String], mustBeWholeWord: Bool = true) -> String
	{
		var result = self
		let characters = self
		
		for word in reference
		{
	//		result.range
		//	result = result.stringByReplacingOccurrencesOfString(word, withString: word, options: [.CaseInsensitiveSearch, .WidthInsensitiveSearch])
			let candidates = result.lowercased().rangesOfSubstring(word.lowercased())
			// If we need to filter out non-whole-word instances, go ahead.
			let ranges = !mustBeWholeWord ? candidates : candidates.filter
			{
				// If this instance of the string is preceded by a letter or number, it's not a whole word.
				if ($0.lowerBound != result.startIndex)
				{
					// If it's preceded alphanumerically, it's not a whole word, and need not be replaced.
					if result[characters.index(before: $0.lowerBound)].isAlphanumeric
						{ return false }
				}
				
				// If this instance of the string is succeeded by a letter or number, it's not a whole word.
				if ($0.upperBound != result.endIndex)
				{
					// If it's succeeded alphanumerically, it's not a whole word, and need not be replaced.
					if result[characters.index(after: $0.lowerBound)].isAlphanumeric
						{ return false }
				}
				
				// If it's still valid, we can replace it.
				return true
			}
			
			// Itteration-safe because the new strings have the same length as the ranges.
			ranges.forEach
				{ result.replaceSubrange($0, with: word) }
		}
		
		return result
	}
	
    func	removeTrailingWhitespace() -> String
	{
		var result = self
		var i = result.index(before: result.endIndex)
		
		while (i >= result.startIndex)
		{
			if (result[i].isWhitespace || result[i].isNewline)
				{ result.remove(at: i) }
			else
				{ return result }
			
			i = result.index(before: i)
		}
		
		return result
	}
	
	
	/// Returns a `String` after removing all consecutive whitespace characters and newlines beginning the `String`.
    func	removeLeadingWhitespace() -> String
	{
		/// The first index in the string that isn't whitespace or a newline.
		var nonWhiteIndex:	String.Index? = nil
		
		for (i, char) in zip(indices, self)
		{
			if (char.isWhitespace) || (char.isNewline)
				{ continue }
			else
			{
				nonWhiteIndex = i
				break
			}
		}
		
		if let ind = nonWhiteIndex
			{ return String(self[ind...]) }
		else
			{ return "" }
	}
}

extension String
{
	// NOTE
	/// Finds all the ranges of a substring in the receiver.  If multiple iterations of the substring overlap, `findOverlappingRanges` must be true to return all the valid ranges.  Unfortunately, the overlapping technology isn't up and running yet.
	public func rangesOfSubstring(_ target: String, findOverlappingRanges: Bool = false) -> [Range<String.Index>]
	{
		assert(!target.isEmpty, "Cannot find ranges of empty substring.")
		
		guard !findOverlappingRanges else
			{ fatalError() }
		
		let characters = self
		
		var result:					[Range<Index>] = []
		
		var rangeStart:				Index?
		var currentSubstringIndex:	Index	= target.startIndex
		
		// currentSubstringIndex is the index character we currently are searching for in the target.  When we haven't started discovering an instance, this will remain as `target.startIndex`.
		
		// With only one pass, the complexity is close to O(n).
		for (i, char) in zip(characters.indices, characters)
		{
			// No matter how far we are into the range, check to see if we can't continue it.
			if (char != target[currentSubstringIndex])
			{
				rangeStart = nil
				currentSubstringIndex = target.startIndex
			}
			// This isn't an else clause because we just changed `currentSubstringIndex`.  We might be starting a new range!
			if (char == target[currentSubstringIndex])
			{
				// Record this character as the start of this possible range.
				rangeStart = i
				
				// Advance the index to keep it in sync with the string we're searching.
				currentSubstringIndex = characters.index(after: currentSubstringIndex)
				
				// Hey, we just advanced through the end of the substring!
				if (currentSubstringIndex == target.endIndex)
				{
					// Add it.
					result <<= rangeStart! ..< currentSubstringIndex
					// Reset the range.
					rangeStart = nil
					currentSubstringIndex = target.startIndex
				}
			}
		}
		
		return result
	}
	
	
    func robHudsonRangesOfString(_ findStr: String, ignoresCase: Bool = false) -> [Range<String.Index>]
	{
		assert(!findStr.isEmpty, "Cannnot find ranges of empty substring.")
		
		let searchString = ignoresCase ? self.lowercased() : self
		let findString = ignoresCase ? findStr.lowercased() : findStr
		
        var result = [Range<String.Index>]()
        var startInd = searchString.startIndex
		
        // check first that the first character of search string exists
        if searchString.contains(findString.first!)
		{
            // if so set this as the place to start searching
            startInd = searchString.firstIndex(of: findString.first!)!
        }
        else
		{
            // if not return empty array
            return result
        }
		
		let myLength = searchString.count
        var i = searchString.distance(from: searchString.startIndex, to: startInd)
        while i <= myLength - findString.count
		{
            if searchString[searchString.index(searchString.startIndex, offsetBy: i) ..< searchString.index(searchString.startIndex, offsetBy: i + findString.count)] == findString
			{
                result.append(searchString.index(searchString.startIndex, offsetBy: i) ..< searchString.index(searchString.startIndex, offsetBy: i + findString.count))
                i += findString.count
            }
            else
			{
                i += 1
            }
        }
        return result


// Light-weight Swift smart quote implementation
// By Rob Hudson
// 5/11/2015
 // try further optimisation by jumping to next index of first search character after every find
    }
}

extension String
{
	/// The number of characters.  Equal to `characters.count`
	public var characterCount:		Int
	{
		return count
	}
	
	/// Returns a String.Index that corresponds to the Int-index:
	/// let str = "Hello World!"
	/// let ind = str.characterIndex(5)
	/// str[ind] == "o"
	public func	characterIndex(_ x: Int) -> String.Index
	{
		return index(startIndex, offsetBy: x)
	}
	
	/// Returns a String.Index that corresponds to the Int-index:
	///		let str = "Hello World!";
	///		let ran = str.characterIndexRange(5...7);
	///		str[ran] == "orl";
	public func	characterIndexRange(_ x: Range<Int>) -> Range<String.Index>
	{
		let myStart = characterIndex(x.lowerBound)
		return myStart ..< index(myStart, offsetBy: x.upperBound - x.lowerBound)
	}
	
	
	public func intIndex(_ x: String.Index) -> Int
	{
		return distance(from: startIndex, to: x)
	}
	
	
	public func intIndexRange(_ x: Range<String.Index>) -> CountableRange<Int>
	{
		let myStart = intIndex(x.lowerBound)
		let myEnd = intIndex(x.upperBound)
		return myStart ..< myEnd//Range(start: myStart, length: characters.distance(from: x.lowerBound, to: x.upperBound))
	}
}

extension String
{
	public func usingSmartQuotes() -> String
	{
		var string = self
		
		string = replaceDumbQuote("'", string: string, leftQuote: "‘", rightQuote: "’")
		string = replaceDumbQuote("\"", string: string, leftQuote: "“", rightQuote: "”")
		
		return string
	}

	fileprivate func replaceDumbQuote(_ dumbQuote: Character, string s: String, leftQuote: String, rightQuote: String) -> String
	{
		var string = s
		let characters = s
		var characterSet = CharacterSet.whitespacesAndNewlines
		characterSet.insert(charactersIn: "([{:<=")
		
		while let characterIndex = string.firstIndex(of: dumbQuote)
		{
			let characterPosition = string.distance(from: string.startIndex, to: characterIndex)
			
			var prevChar: Character
			if characterPosition != 0
				{ prevChar = string[characters.index(before: characterIndex)] }
			else
				{ prevChar = " " as Character }
			
			var smartQuote: String
			if characterSet.contains(UnicodeScalar((String(prevChar) as NSString).character(at: 0))!)
				{ smartQuote = leftQuote }
			else
				{ smartQuote = rightQuote }
			
			let range = characterIndex ..< characters.index(before: characterIndex)
			string = string.replacingCharacters(in: range, with: smartQuote)
		}

		return string
	}
}

