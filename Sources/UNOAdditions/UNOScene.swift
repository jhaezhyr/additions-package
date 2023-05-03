//
//  UNOScene.swift
//  Game Kit
//
//  Created by Braeden Hintze on 1/12/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Cocoa
import SceneKit
import Additions
//import TDKit


let kUNOSceneCameraPosition		= SCNVector3(x: 0, y: 3.3, z: -10)
let kUNOSceneCameraOrientation	= SCNQuaternion(x: 0, y: 0, z: 0, w: 1)

let kUNOSceneDeckPosition		= SCNVector3(x: 0, y: 0, z: 0)
let kUNOSceneDiscardPosition	= SCNVector3(x: 0, y: 0, z: 0)
let kUNOScenePlayerZonePosition = SCNVector3(x: 0, y: 0, z: 10)

let kUNOSceneCardSize			= SCNVector3(x: 0.6, y: 0.01, z: 1)



class UNOScene
{
	var scene:		SCNScene
	var tableNode:	SCNNode			= SCNNode()
	var deckNode:	SCNNode			= SCNNode()
	var discardNode:SCNNode			= SCNNode()
	var controller:	UNOController?	= nil
	
	
	init(scnScene: inout SCNScene?)
	{
		if (scnScene != nil)
		{
			scene = scnScene!
		}
		else
		{
			scnScene = SCNScene()
			scene = scnScene!
		}
		
		
		tableNode.name = "Table"
		tableNode.position = SCNVector3(x: 0, y: 0, z: 0)
		scene.rootNode.addChildNode(tableNode)
		
		deckNode.name = "Deck"
		deckNode.position = kUNOSceneDeckPosition
		tableNode.addChildNode(deckNode)
		
		discardNode.name = "Discard"
		discardNode.position = kUNOSceneDiscardPosition
		tableNode.addChildNode(discardNode)
	}
	
	
	func	registerController(controller nc: UNOController)
	{
		controller = nc
	}
	
	
	
}

