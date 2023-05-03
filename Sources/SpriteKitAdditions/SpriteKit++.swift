//
//  File.swift
//  Sprite Kit Test
//
//  Created by Braeden Hintze on 6/9/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import SpriteKit
import SceneKit


public extension SKNode
{
	var scaleVector:		CGPoint
	{
		get { return CGPoint(x: xScale, y: yScale) }
		set
		{
			xScale = newValue.x
			yScale = newValue.y
		}
	}
}


extension SKNode
{
	/// Called when a the `contactDelegate` of `scene` recieves `didBeginContact()`.  Override to provide contact functionality.
	open func	didBeginContactWithNode(_ node: SKNode!) { }
	/// Called when a the `contactDelegate` of `scene` recieves `didEndContact()`.  Override to provide contact functionality.
	open func	didEndContactWithNode(_ node: SKNode!) { }
	/// Called when a the `contactDelegate` of `scene` recieves `didEndContact()`.  Override to provide contact functionality.
	open func	update(currentTime: TimeInterval, deltaTime: TimeInterval) { }
}


/// Sinces copy() returns an invalid physics body, this shall be used instead to implement physics body duplication.
public func	copyPhysicsBody(_ body: SKPhysicsBody) -> SKPhysicsBody
{
//	return unsafeBitCast(body.copy(), SKPhysicsBody.self)
//	return body.copy() as! SKPhysicsBody
	let pkAnyObject:	AnyObject			= body.copy() as AnyObject
	let rawPointer:		UnsafePointer<Any>	= unsafeBitCast(pkAnyObject, to: UnsafePointer<Any>.self)
	let skBody:			SKPhysicsBody		= unsafeBitCast(rawPointer, to: SKPhysicsBody.self)
	
	return skBody
}


public extension SKNode
{
	/// Duplicates the template `node`, along with all of its descending objects.
	public convenience init(node: SKNode)
	{
		self.init()
		fillOutFromNode(node)
	}
	
	
	@objc public func	fillOutFromNode(_ node: SKNode)
	{
		position = node.position
		zPosition = node.zPosition
		zRotation = node.zRotation
		xScale = node.xScale
		yScale = node.yScale
		speed = node.speed
		alpha = node.alpha
		isPaused = node.isPaused
		isHidden = node.isHidden
		isUserInteractionEnabled = node.isUserInteractionEnabled
		name = node.name
		userData = node.userData
		reachConstraints = node.reachConstraints
		
		// Constraints maintian references to their nodes.  This won't have any constraints, for now.
		if	#available(OSX 10.10, *), #available(iOS 8.0, *),
			let constraintList = node.constraints
		{
			var newConstraints:	[SKConstraint] = []
			
			for constraint in constraintList
			{
				newConstraints.append(constraint.copy() as! SKConstraint)
			}
		
			constraints = newConstraints
		}
		
		// * Children duplication * //
		for child in node.children 
		{
		//	let newChild = child.dynamicType(
			let newChild = child.clone()
			addChild(newChild)
		}
		
		if (node.physicsBody != nil)
		{
			physicsBody = copyPhysicsBody(node.physicsBody!)
		}
		
		if	#available(OSX 10.10, *), #available(iOS 8.0, *),
			let threedee = self as? SK3DNode
		{
			threedee.fillOutFrom3DNode(node)
		}
	}
	
	
	/// self.clone() should return an identical value to class.init(node: self).
	public func	clone() -> SKNode
	{
		let resultingNode	= copy() as! SKNode
		
		if (physicsBody != nil)
		{
			resultingNode.physicsBody = copyPhysicsBody(physicsBody!)
		}
		
		return resultingNode
	}
	
	
	public func	descendantNodeWithName(_ name: String) -> SKNode?
	{
		if let childNode = childNode(withName: name)
		{
			return childNode
		}
		else
		{
			for child in children
			{
				if let descendant = child.descendantNodeWithName(name)
				{
					return descendant
				}
			}
		}
		
		return nil
	}
	
	
	public func	replaceWithNode(_ node: SKNode?)
	{
		if let superNode = parent
		{
			let index = (superNode.children ).index(of: self)!
			
			if let newNode = node
			{
				superNode.insertChild(newNode, at: index)
			}
			
			removeFromParent()
		}
	}
	
	
	/// Returns all the descendants (children and children of children) of the receiver.
	public func		descendants() -> [SKNode]
	{
		var result: [SKNode]	= []
		
		for child in children 
		{
			result.append(child)
			result += child.descendants()
		}
		
		return result
	}
}


public extension SKSpriteNode
{
	public override func	fillOutFromNode(_ node: SKNode)
	{
		super.fillOutFromNode(node)
		
		if let spriteNode = node as? SKSpriteNode
		{
			texture = spriteNode.texture
			size = spriteNode.size
			color = spriteNode.color
			centerRect = spriteNode.centerRect
			blendMode = spriteNode.blendMode
			anchorPoint = spriteNode.anchorPoint
			
			if #available(OSX 10.10, *), #available(iOS 8.0, *)
			{
			    shader = spriteNode.shader
				normalTexture = spriteNode.normalTexture
				lightingBitMask = spriteNode.lightingBitMask
				shadowCastBitMask = spriteNode.shadowCastBitMask
				shadowedBitMask = spriteNode.shadowedBitMask
			}
		}
	}
}

@available(iOS 8.0, *)
@available(OSX 10.10, *)
public extension SK3DNode
{
	func	fillOutFrom3DNode(_ node: SKNode)
	{
		if let sceneNode = node as? SK3DNode
		{
			viewportSize = sceneNode.viewportSize
			sceneTime = sceneNode.sceneTime
			isPlaying = sceneNode.isPlaying
			loops = sceneNode.loops
			autoenablesDefaultLighting = sceneNode.autoenablesDefaultLighting
			
			scnScene = sceneNode.scnScene
			pointOfView = sceneNode.pointOfView
		}
	}
}


public protocol SKSizeable
{
	var size: CGSize { get }
}

extension SKSpriteNode: SKSizeable
	{  }

@available(iOS 8.0, *)
@available(OSX 10.10, *)
extension SK3DNode: SKSizeable
{
	public var size:	CGSize
		{ return viewportSize }
}

extension SKVideoNode: SKSizeable
	{  }




