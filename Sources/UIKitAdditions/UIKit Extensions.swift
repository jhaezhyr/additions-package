/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
*	Project																		*
* 																				*
* 		Example.h																*
*																				*
*	This section allows for the description of whatever this header is for.		*
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

// MARK:  Header Files
/**
 **	 import SomeFramework
 **
 **/
import Darwin
import UIKit 


// MARK:  Constants
/**
 **	 let kConstant = a_value
 **
 **/


// MARK:  Type Definitions
/**
 **  typealias NewType = OldType
 **
 **/




public extension UIColor
{
	public var rgba:	(CGFloat, CGFloat, CGFloat, CGFloat)
	{
		var result: (CGFloat, CGFloat, CGFloat, CGFloat) = (1,1,1,1)
		
		getRed(&result.0, green: &result.1, blue: &result.2, alpha: &result.3)
		
		return result
	}
	
	/**
	 **
	 **
	 **/
	public func			inverse() -> UIColor
	{
		let old = rgba
		
		return UIColor(	red:	CGFloat(1.0) / old.0,
						green:	CGFloat(1.0) / old.1,
						blue:	CGFloat(1.0) / old.2,
						alpha:	old.3	)
	}
	
	
	/**
	 **
	 **
	 **/
	public func			opaque() -> UIColor
	{
		let old = rgba
		
		return UIColor(	red:	old.0,
						green:	old.1,
						blue:	old.2,
						alpha:	1.0	)
	}
	
	
	/**
	 **
	 **
	 **/
	public func			withAlpha(newAlpha: CGFloat) -> UIColor
	{
		let old = rgba
		
		return UIColor(	red:	old.0,
						green:	old.1,
						blue:	old.2,
						alpha:	newAlpha	)
	}
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
// MARK:  UIColor

/**
 **
 **
 **/
public func			+ (l: UIColor, r: UIColor) -> UIColor
{
	let lOld = l.rgba
	let rOld = r.rgba
	
	return UIColor(	red:	lOld.0 + rOld.0,
					green:	lOld.1 + rOld.1,
					blue:	lOld.2 + rOld.2,
					alpha:	lOld.3 + rOld.3	)
}


/**
 **
 **
 **/
public func			<< (l: UIColor, r: UIColor) -> UIColor
{
	let lOld = l.rgba
	let rOld = r.rgba
//	let back:	(CGFloat, CGFloat, CGFloat, CGFloat)
	let front:	(CGFloat, CGFloat, CGFloat, CGFloat)
	
/*	back = (	lOld.0 * lOld.3 * (1 - rOld.3),
				lOld.1 * lOld.3 * (1 - rOld.3),
				lOld.2 * lOld.3 * (1 - rOld.3),
				lOld.3 * (1 - rOld.3)	)
	*/
	front = (	rOld.0 * rOld.3,
				rOld.1 * rOld.3,
				rOld.2 * rOld.3,
				rOld.3	)
	
	return UIColor(	red:	lOld.0 + front.0,
					green:	lOld.1 + front.1,
					blue:	lOld.2 + front.2,
					alpha:	lOld.3 + front.3	)
}


/**
 **
 **
 **/
public func			* (l: UIColor, r: CGFloat) -> UIColor
{
	let lOld = l.rgba
	
	return UIColor(	red:	lOld.0 * r,
					green:	lOld.1 * r,
					blue:	lOld.2 * r,
					alpha:	lOld.3	)
}


/**
 **
 **
 **/
public prefix func		- (c: UIColor) -> UIColor
{
	let old = c.rgba
	
	return UIColor(	red:	1.0 - old.0,
					green:	1.0 - old.1,
					blue:	1.0 - old.2,
					alpha:	old.3	)
}


