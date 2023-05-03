import CoreGraphics


// MARK:  - CGFloat Usage

extension CGFloat
{
	public static func		* (l: CGFloat, r: Int) -> CGFloat
		{ return l * CGFloat(r) }

	public static func		* (l: CGFloat, r: Float) -> CGFloat
		{ return l * CGFloat(r) }

	public static func		* (l: CGFloat, r: Double) -> CGFloat
		{ return l * CGFloat(r) }


	public static func		/ (l: CGFloat, r: Int) -> CGFloat
		{ return l / CGFloat(r) }

	public static func		/ (l: CGFloat, r: Float) -> CGFloat
		{ return l / CGFloat(r) }

	public static func		/ (l: CGFloat, r: Double) -> CGFloat
		{ return l / CGFloat(r) }


	public static func		*= (l: inout CGFloat, r: Int)
		{ l = l * CGFloat(r) }

	public static func		*= (l: inout CGFloat, r: Float)
		{ l = l * CGFloat(r) }

	public static func		*= (l: inout CGFloat, r: Double)
		{ l = l * CGFloat(r) }


	public static func		/= (l: inout CGFloat, r: Int)
		{ l = l / CGFloat(r) }

	public static func		/= (l: inout CGFloat, r: Float)
		{ l = l / CGFloat(r) }

	public static func		/= (l: inout CGFloat, r: Double)
		{ l = l / CGFloat(r) }
}

