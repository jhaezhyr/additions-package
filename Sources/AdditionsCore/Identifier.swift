//
//  Identifier.swift
//  Additions
//
//  Created by Braeden Hintze on 10/18/16.
//  Copyright © 2016 Braeden Hintze. All rights reserved.
//

/// A unique identifier for a class instance or metatype, parameterized to a type.
///
/// In Swift, only class instances and metatypes have unique identities. There
/// is no notion of identity for structs, enums, functions, or tuples.
public struct Identifier<T: AnyObject>: Hashable
{
	/// The object referenced by the identifier.
	public var referenced: T
	
	/// The identifier's hash value.
	///
	/// The hash value is not guaranteed to be stable across different
	/// invocations of the same program.  Do not persist the hash value across
	/// program runs.
	///
	/// - SeeAlso: `Hashable`
	public var hashValue: Int
		{ return ObjectIdentifier(referenced).hashValue }
	
	/// Creates an instance that uniquely identifies the given class instance.
	///
	/// The following example creates an example class `A` and compares instances
	/// of the class using their object identifiers and the identical-to
	/// operator (`===`):
	///
	///     class IntegerRef {
	///         let value: Int
	///         init(_ value: Int) {
	///             self.value = value
	///         }
	///     }
	///
	///     let x = IntegerRef(10)
	///     let y = x
	///
	///     print(Identifier(x) == Identifier(y))
	///     // Prints "true"
	///     print(x === y)
	///     // Prints "true"
	///
	///     let z = IntegerRef(10)
	///     print(Identifier(x) == Identifier(z))
	///     // Prints "false"
	///     print(x === z)
	///     // Prints "false"
	///
	/// - Parameter x: An instance of a class.
	public init(_ x: T)
	{
		referenced = x
	}
	
    /// Checks whether two identifiers reference the same object.
	public static func == <T> (lh: Identifier<T>, rh: Identifier<T>) -> Bool
	{
		return lh.referenced === rh.referenced
	}
}
