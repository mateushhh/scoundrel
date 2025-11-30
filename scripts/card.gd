extends Sprite2D

class Card:
	enum Suit {HEARTS, DIAMONDS, CLUBS, SPADES}
	
	@export var suit: Suit = Suit.SPADES:
		set(value):
			suit = value
			update_visuals()
	
	@export var rank: int = 7:
		set(value):
			rank = value
			update_visuals()
	
	func update_visuals():
		return
