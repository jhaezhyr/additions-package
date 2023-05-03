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

import CoreGraphics
import Cocoa
import SceneKit


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

postfix operator ¬
infix   operator •
infix	operator ×


public protocol SCNVector: Value
{
	func			• (Self, Self) -> CGFloat
	postfix func	¬ (Self) -> CGFloat
	
	func			+ (Self, CGFloat) -> Self
	func			* (Self, CGFloat) -> Self
	func			% (Self, CGFloat) -> Self
	
	// * 0-based indexing * //
	subscript(Int) -> CGFloat { get }
}


//public struct SCNVector2
//{
//	var x: CGFloat
//	var y: CGFloat
//}
public typealias SCNVector2 = CGPoint


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
// MARK:  SCNVector Glue

/**
 **
 **
 **/
public func			- <T: SCNVector> (l: T, r: CGFloat) -> T
{
	return l + -r
}


/**
 **
 **
 **/
public func			/ <T: SCNVector> (l: T, r: CGFloat) -> T
{
	return l * (1 / r)
}


/**
 **
 **
 **/
public func			+ <T: SCNVector> (l: CGFloat, r: T) -> T
{
	return r + l
}


/**
 **
 **
 **/
public func			* <T: SCNVector> (l: CGFloat, r: T) -> T
{
	return r * l
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
// MARK:  SCNMatrix4

extension SCNMatrix4: Value
{
	/**
	 **
	 **
	 **/
	public func			inverse() -> SCNMatrix4
	{
		return SCNMatrix4Invert(self)
	}
	
	
	/**
	 **  subscript(_:_:) or [col, row]
	 **
	 **  1,1 to 4,4, column major indexing
	 **/
	public subscript(col: Int, row: Int) -> CGFloat
	{
		get
		{
			switch (col)
			{
				case 1:
					switch (row)
					{
						case 1:
							return m11
						case 2:
							return m12
						case 3:
							return m13
						case 4:
							return m14
						default:
							return 0
					}
				case 2:
					switch (row)
					{
						case 1:
							return m21
						case 2:
							return m22
						case 3:
							return m23
						case 4:
							return m24
						default:
							return 0
					}
				case 3:
					switch (row)
					{
						case 1:
							return m31
						case 2:
							return m32
						case 3:
							return m33
						case 4:
							return m34
						default:
							return 0
					}
				case 4:
					switch (row)
					{
						case 1:
							return m41
						case 2:
							return m42
						case 3:
							return m43
						case 4:
							return m44
						default:
							return 0
					}
				default:
					return 0
			}
		}
		
		set(newValue)
		{
			switch (col)
			{
				case 1:
					switch (row)
					{
						case 1:
							m11 = newValue
						case 2:
							m12 = newValue
						case 3:
							m13 = newValue
						case 4:
							m14 = newValue
						default:
							return
					}
				case 2:
					switch (row)
					{
						case 1:
							m21 = newValue
						case 2:
							m22 = newValue
						case 3:
							m23 = newValue
						case 4:
							m24 = newValue
						default:
							return
					}
				case 3:
					switch (row)
					{
						case 1:
							m31 = newValue
						case 2:
							m32 = newValue
						case 3:
							m33 = newValue
						case 4:
							m34 = newValue
						default:
							return
					}
				case 4:
					switch (row)
					{
						case 1:
							m41 = newValue
						case 2:
							m42 = newValue
						case 3:
							m43 = newValue
						case 4:
							m44 = newValue
						default:
							return
					}
				default:
					return
			}
		}
	}
	
	
	/**
	 **  subscript(_:) or [col]
	 **
	 **  Vector for a column in the matrix
	 **/
	public subscript(col: Int) -> SCNVector4
	{
		get
		{
			switch (col)
			{
				case 1:
					return SCNVector4(  x:	m11,
										y:	m12,
										z:	m13,
										w:	m14	)
				case 2:
					return SCNVector4(  x:	m21,
										y:	m22,
										z:	m23,
										w:	m24	)
				case 3:
					return SCNVector4(  x:	m31,
										y:	m32,
										z:	m33,
										w:	m34	)
				case 4:
					return SCNVector4(  x:	m41,
										y:	m42,
										z:	m43,
										w:	m44	)
				default:
					return SCNVector4(  x:	0,
										y:	0,
										z:	0,
										w:	0	)
			}
		}
		
		set(newValue)
		{
			switch (col)
			{
				case 1:
					m11 = newValue.x
					m12 = newValue.y
					m13 = newValue.z
					m14 = newValue.w
				case 2:
					m21 = newValue.x
					m22 = newValue.y
					m23 = newValue.z
					m24 = newValue.w
				case 3:
					m31 = newValue.x
					m32 = newValue.y
					m33 = newValue.z
					m34 = newValue.w
				case 4:
					m41 = newValue.x
					m42 = newValue.y
					m43 = newValue.z
					m44 = newValue.w
				default:
					return
			}
		}
	}
}


public func			== (l: SCNMatrix4, r: SCNMatrix4) -> Bool
{
	return SCNMatrix4EqualToMatrix4(l, r)
}


/**
 **
 **
 **/
public func			+ (var l: SCNMatrix4, let r: SCNMatrix4) -> SCNMatrix4
{
	for x in 1...4
	{
		for y in 1...4
		{
			l[x, y] += r[x, y]
		}
	}
	
	return l
}



/**
 **
 **
 **/
public func			* (l: SCNMatrix4, r: SCNMatrix4) -> SCNMatrix4
{
	return SCNMatrix4Mult(l, r)
}


/**
 **
 **
 **/
public func			% (l: SCNMatrix4, r: SCNMatrix4) -> SCNMatrix4
{
	return l
}


/**
 **
 **
 **/
public prefix func		- (m: SCNMatrix4) -> SCNMatrix4
{
	return m
}


/**
 **
 **
 **/
public func			* (var l: SCNMatrix4, let r: CGFloat) -> SCNMatrix4
{
	for x in 1...4
	{
		for y in 1...4
		{
			l[x, y] *= r
		}
	}
	
	return l
}


/**
 **
 **
 **/
public func			/ (l: SCNMatrix4, r: CGFloat) -> SCNMatrix4
{
	return l * (1 / r)
}


/**
 **
 **
 **/
public func			/ (l: CGFloat, r: SCNMatrix4) -> SCNMatrix4
{
	return l * r.inverse()
}


/**
 **
 **
 **/
public func			* (l: CGFloat, r: SCNMatrix4) -> SCNMatrix4
{
	return r * l
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
// MARK:  SCNVector2

extension SCNVector2: SCNVector
{
	/**
	 **
	 **
	 **/
	public func		inverse() -> CGPoint
	{
		return CGPoint(  x:  1/x,
							y:  1/y )
	}
	
	
	/**
	 **
	 **
	 **/
	public subscript(id: Int) -> CGFloat
	{
		switch id
		{
			case 0:
				return x
			case 1:
				return y
			default:
				return 0
		}
	}
}


/**
 **
 **
 **/
public func			• (l: CGPoint, r: CGPoint) -> CGFloat
{
	return (l.x * r.x +
			l.y * r.y   )
}


/**
 **
 **
 **/
public postfix func	¬ (v: CGPoint) -> CGFloat
{
	return sqrt(v.x * v.x +
				v.y * v.y	)
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
// MARK:  SCNVector3

extension SCNVector3: SCNVector, Printable
{
//	typealias	R = SCNVector3
	
	public func		inverse() -> SCNVector3
	{
		return SCNVector3(  x:  1/x,
							y:  1/y,
							z:  1/z )
	}
	
	
	public var	description: String
	{
		return "(\(x), \(y), \(z))"
	}
	
	
	/**
	 **
	 **
	 **/
	public subscript(id: Int) -> CGFloat
	{
		switch id
		{
			case 0:
				return x
			case 1:
				return y
			case 2:
				return z
			default:
				return 0
		}
	}
}


/**
 **
 **
 **/
public func			== (l: SCNVector3, r: SCNVector3) -> Bool
{
	return (l.x == r.x &&
			l.y == r.y &&
			l.z == r.z	)
}


/**
 **
 **
 **/
public func			+ (l: SCNVector3, r: SCNVector3) -> SCNVector3
{
	return SCNVector3(	x:  l.x + r.x,
						y:	l.y + r.y,
						z:	l.z + r.z	)
}


/**
 **
 **
 **/
public func			* (l: SCNVector3, r: SCNVector3) -> SCNVector3
{
	return SCNVector3(	x:  l.x * r.x,
						y:	l.y * r.y,
						z:	l.z * r.z	)
}


/**
 **
 **
 **/
public func			% (l: SCNVector3, r: SCNVector3) -> SCNVector3
{
	return SCNVector3(	x:  l.x % r.x,
						y:	l.y % r.y,
						z:	l.z % r.z	)
}


/**
 **
 **
 **/
public func			+ (l: SCNVector3, r: CGFloat) -> SCNVector3
{
	return SCNVector3(	x:  l.x + r,
						y:	l.y + r,
						z:	l.z + r	)
}


/**
 **
 **
 **/
public func			* (l: SCNVector3, r: CGFloat) -> SCNVector3
{
	return SCNVector3(	x:  l.x * r,
						y:	l.y * r,
						z:	l.z * r	)
}


/**
 **
 **
 **/
public func			% (l: SCNVector3, r: CGFloat) -> SCNVector3
{
	return SCNVector3(	x:  l.x % r,
						y:	l.y % r,
						z:	l.z % r	)
}


/**
 **
 **
 **/
public prefix func		- (v: SCNVector3) -> SCNVector3
{
	return SCNVector3(	x:  -v.x,
						y:	-v.y,
						z:	-v.z	)
}


/**
 **
 **
 **/
public func			• (l: SCNVector3, r: SCNVector3) -> CGFloat
{
	return (l.x * r.x +
			l.y * r.y +
			l.z * r.z   )
}


/**
 **
 **
 **/
public func			× (l: SCNVector3, r: SCNVector3) -> SCNVector3
{
	return SCNVector3(	x:	l.y*r.z - l.z*r.y,
						y:	l.z*r.x - l.x*r.z,
						z:	l.x*r.y - l.y*r.x	)
}


/**
 **
 **
 **/
public postfix func	¬ (v: SCNVector3) -> CGFloat
{
	return sqrt(v.x * v.x +
				v.y * v.y +
				v.z * v.z	)
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
// MARK:  SCNVector4

extension SCNVector4: SCNVector
{
//	typealias	R = SCNVector4
	
	public func		inverse() -> SCNVector4
	{
		return SCNVector4(  x:  1/x,
							y:  1/y,
							z:  1/z,
							w:  1/w )
	}
	
	
	/**
	 **
	 **
	 **/
	public subscript(id: Int) -> CGFloat
	{
		switch id
		{
			case 0:
				return x
			case 1:
				return y
			case 2:
				return z
			case 3:
				return w
			default:
				return 0
		}
	}
}


/**
 **
 **
 **/
public func			== (l: SCNVector4, r: SCNVector4) -> Bool
{
	return (l.x == r.x &&
			l.y == r.y &&
			l.z == r.z &&
			l.w == r.w	)
}


/**
 **
 **
 **/
public func			+ (l: SCNVector4, r: SCNVector4) -> SCNVector4
{
	return SCNVector4(	x:  l.x + r.x,
						y:	l.y + r.y,
						z:	l.z + r.z,
						w:	l.w + r.w )
}


/**
 **
 **
 **/
public func			* (l: SCNVector4, r: SCNVector4) -> SCNVector4
{
	return SCNVector4(	x:  l.x * r.x,
						y:	l.y * r.y,
						z:	l.z * r.z,
						w:	l.w * r.w	)
}


/**
 **
 **
 **/
public func			% (l: SCNVector4, r: SCNVector4) -> SCNVector4
{
	return SCNVector4(	x:  l.x % r.x,
						y:	l.y % r.y,
						z:	l.z % r.z,
						w:	l.w % r.w	)
}


/**
 **
 **
 **/
public func			+ (l: SCNVector4, r: CGFloat) -> SCNVector4
{
	return SCNVector4(	x:  l.x + r,
						y:	l.y + r,
						z:	l.z + r,
						w:	l.w + r )
}


/**
 **
 **
 **/
public func			* (l: SCNVector4, r: CGFloat) -> SCNVector4
{
	return SCNVector4(	x:  l.x * r,
						y:	l.y * r,
						z:	l.z * r,
						w:	l.w * r	)
}


/**
 **
 **
 **/
public func			% (l: SCNVector4, r: CGFloat) -> SCNVector4
{
	return SCNVector4(	x:  l.x % r,
						y:	l.y % r,
						z:	l.z % r,
						w:	l.w % r	)
}


/**
 **
 **
 **/
public prefix func		- (v: SCNVector4) -> SCNVector4
{
	return SCNVector4(	x:  -v.x,
						y:	-v.y,
						z:	-v.z,
						w:	-v.w	)
}


/**
 **
 **
 **/
public func			• (l: SCNVector4, r: SCNVector4) -> CGFloat
{
	var result: CGFloat = 0.0
	
	result += l.x * r.x
	result += l.y * r.y
	result += l.z * r.z
	result += l.w * r.w
	
	return result
}


/**
 **
 **
 **/
public postfix func	¬ (v: SCNVector4) -> CGFloat
{
	return sqrt(v.x * v.x +
				v.y * v.y +
				v.z * v.z +
				v.w * v.w	)
}


