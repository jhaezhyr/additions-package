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

let kUNONumberCardCount		= 60
let kUNOWildCardCount		= 10
let kUNODrawCardCount		= 10
let kUNOSkipCardCount		= 10
let kUNOReverseCardCount	= 10

let kUNOCardCount			= kUNONumberCardCount + kUNOWildCardCount + kUNODrawCardCount + kUNOSkipCardCount + kUNOReverseCardCount

let kUNOCardsDealt			= 7


// MARK:  Type Definitions
/**
 **  typealias NewType = OldType
 **
 **/

enum UNOCardValue
{
	case number(Int)
	case draw(Int)
	case wildDraw(Int)
	case reverse
	case skip
}


enum UNOCardColor: Int
{
	case	red		= 0,
			green,
			blue,
			yellow
	
	static var all: [UNOCardColor]
		{ return [.red, .green, .blue, .yellow] }
}


enum UNODrawSource
{
	case deck, discard
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

protocol UNOGameController
{
	
}


class UNOCard: Equatable
{
	let value:		UNOCardValue
	var color:		UNOCardColor
	
	var owner:		Deck<UNOCard>!
	
	
	/**
	 **
	 **
	 **/
	init(	value	newValue:	UNOCardValue,
			color	newColor:	UNOCardColor,
			owner	newOwner:	Deck<UNOCard>!	)
	{
		value = newValue
		color = newColor
		owner = newOwner
	}
	
	
	/**
	 **
	 **
	 **/
	func	canLandOnCard(_ newCard: UNOCard) -> Bool
	{
		switch (newCard.value)
		{
			case .wildDraw(_):
				return true
			default:
			//	return ((newCard.color == self.color) ||
			//			(newCard.value == self.value)	)
				if (newCard.color == self.color)
				{
					return true
				}
			//	else if (newCard.value == self.value)
			//	{
			//		return true
			//	}
				else
				{
					return false
				}
			//	return	newCard.color == self.color ? true :
			//			newCard.value == self.value ? true :
			//				false
			//	if (newCard.color == .Yellow)
			//	{
			//		return true
			//	}
		}
	}
	
	
	/**
	 **
	 **
	 **/
	func	canLandOnStack(_ stack: Deck<UNOCard>) -> Bool
	{
		if !stack.isEmpty
		{
			return canLandOnCard(stack[0])
		}
		else
		{
			return true
		}
	}
}


class UNOGame
{
	var players:	[UNOPlayer]	= []
	var deck:		Deck<UNOCard>
	var discard:	Deck<UNOCard>
	
	
	init()
	{
		var cards = [UNOCard]()
		
		for _ in 1...kUNONumberCardCount
		{
			cards.append(UNOCard(	value: .number(Int.random(1...9)),
										color: UNOCardColor.all.random(),
										owner: nil	)	)
		}
		
		for _ in 1...kUNOWildCardCount
		{
			cards.append(UNOCard(	value: .wildDraw(Bool.random() ? 0 : 4),
									color: .red,
									owner: nil	)	)
		}
		
		for _ in 1...kUNODrawCardCount
		{
			cards.append(UNOCard(	value: .draw(2),
									color: UNOCardColor.all.random(),
									owner: nil	)	)
		}
		
		for _ in 1...kUNOSkipCardCount
		{
			cards.append(UNOCard(	value: .skip,
									color: UNOCardColor.all.random(),
									owner: nil	)	)
		}
		
		for _ in 1...kUNOReverseCardCount
		{
			cards.append(UNOCard(	value: .reverse,
									color: UNOCardColor.all.random(),
									owner: nil	)	)
		}
		
		deck = Deck<UNOCard>(cards, style: .deck)
		discard = Deck<UNOCard>([], style: .discard)
		
		
		deck.shuffle()
	}
	
	
	/**
	 **
	 **
	 **/
	func	start()
	{
		for player in players
		{
			player.hand.draw(count: kUNOCardsDealt, from: deck)
		}
		
		discard.drawOne(from: deck)
	}
}

func	== (l: UNOCard, r: UNOCard) -> Bool
{
	return (l === r)
}

/*
class UNOStack
{
	private var cards:		[UNOCard]	= []
	
	var count:		Int
		{ return cards.count }
	
	
	subscript(value: Int) -> UNOCard
	{
		get { return cards[value] }
	}
	
	
	func	popToStack(_ newZone: UNOStack) -> UNOCard
	{
		return moveIndex(0, toZone: newZone)
	}
	
	
	func	moveIndex(_ index: Int, toZone: UNOStack) -> UNOCard
	{
		let card = cards.remove(at: 0)
		
		toZone.cards.insert(card, at: 0)
		card.owner = toZone
		
		return card
	}
	
	
	func	shuffle()
	{
		for i in 0 ..< count
		{
			let swapIndex	= Int.random(0, count - 1)
			let thisCard	= cards[i]
			
			cards[i] = cards[swapIndex]
			cards[swapIndex] = thisCard
		}
	}
}*/


class UNOPlayer
{
	var game:		UNOGame!	= nil
	var hand:		Deck<UNOCard>	= Deck<UNOCard>([], style: .hand)
	
	
	/**
	 **
	 **
	 **/
	init(game newGame: UNOGame)
	{
		game = newGame
	}
	
	
	/**
	 **
	 **
	 **/
	func	beginTurn()
	{
	//	scheduleFunctionCall(takeTurn(), 0.5 + CGFloat.random(0.0, 1.0))
	}
	
	
	/**
	 **
	 **
	 **/
	func	takeTurn()
	{
		let possible	= playableCards()
		
		if !possible.isEmpty
		{
			play(bestCard(possible))
		}
		else
		{
			let source	= drawSource()
			
			if source == .deck
			{
				let newCard	= deckDraw()
				
				if cardIsPossible(newCard)
				{
					play(newCard)
				}
				else
				{
					keep(newCard)
				}
			}
			else if source == .discard
			{
				keep(discardDraw())
			}
		}
	}
	
	
	/**
	 **
	 **
	 **/
	func	playableCards() -> [UNOCard]
	{
		var result: [UNOCard] = []
		
		for thisCard in hand
		{
			if thisCard.canLandOnStack(game.discard)
			{
				result.append(thisCard)
			}
		}
		
		return result
	}
	
	
	/**
	 **
	 **
	 **/
	func	cardIsPossible(_ card: UNOCard) -> Bool
	{
		return card.canLandOnStack(game.discard)
	}
	
	
	/**
	 **
	 **
	 **/
	func	keep(_ card: UNOCard)
	{
		
	}
	
	
	/**
	 **
	 **
	 **/
	func	play(_ card: UNOCard)
	{
		hand.discard(card, to: game.discard)
	}
	
	
	/**
	 **
	 **
	 **/
	func	drawSource() -> UNODrawSource
	{
		return .deck
	}
	
	
	/**
	 **
	 **
	 **/
	func	deckDraw() -> UNOCard
	{
		guard let drawnCard = hand.drawOne(from: game.deck) else
			{ fatalError("We need more programming here.") }
		return drawnCard
	}
	
	
	/**
	 **
	 **
	 **/
	func	discardDraw() -> UNOCard
	{
		guard let drawnCard = hand.drawOne(from: game.discard) else
			{ fatalError("We need more programming here.") }
		return drawnCard
	}
	
	
	/**
	 **
	 **
	 **/
	func	bestCard(_ cardList: [UNOCard]) -> UNOCard
	{
		return cardList.random()
	}
	
	/**
	 **
	 **
	 **/
	func	update()
	{
		
	}
}


class UNOUser: UNOPlayer
{
	
}


