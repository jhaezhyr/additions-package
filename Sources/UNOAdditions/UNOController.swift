/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
*	Project																		*
* 																				*
* 		Example.swift															*
*																				*
*	This section allows for the description of whatever this header is for.		*
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

// MARK:  Header Files
/**
 **	 import SomeFramework
 **
 **/

import Cocoa
import Additions


// MARK:  Constants
/**
 **	 let kConstant = a_value
 **
 **/

let kUNONPCs	= 3
let kUNOUsers	= 1


// MARK:  Type Definitions
/**
 **  typealias NewType = OldType
 **
 **/


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

class UNOController: NSViewController, UNOGameController
{
	@IBOutlet var unoView:	UNOView!
	var game:		UNOGame!	= nil
	var turnOwner:	UNOPlayer!	= nil
	var gameThread:	Thread!	= nil
	var scene:		UNOScene!	= nil
	
	/**
	 **
	 **
	 **/
	override func	viewDidLoad()
	{
		game = UNOGame()
		
		for _ in 1...kUNONPCs
		{
			game.players.append(UNOPlayer(game: game))
		}
		
		for _ in 1...kUNOUsers
		{
			game.players.append(UNOUser(game: game))
		}
		
		scene = UNOScene(scnScene: &unoView.scene)
		
		unoView.sceneController = scene
		unoView.controller = self
		
		gameThread = Thread(	target:		self,
								selector:	#selector(UNOController.runGame(_:)),
								object:		nil	)
	}
	
	func			runGame(_ data: AnyObject)
	{
		game.start()
	}

	func	playerEndsTurn(_ player: UNOPlayer)
	{
		turnOwner = player
		
	}
	
	func	update()
	{
		for player in game!.players
		{
			player.update()
		}
	}
}




