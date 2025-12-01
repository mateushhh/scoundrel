extends Node2D

var card_scene = preload("res://scenes/card.tscn")
var deck_scene = preload("res://scenes/deck.tscn")

const card_pos_x = 200
const card_pos_y = 250
const card_gap_x = 100
const deck_pos_x = 100
const deck_pos_y = 100

var deck: Deck
var cards: Array[Card] = []
var health: int = 20
var weapon: int = 0
var last_weapon_use: int = 0

func _ready() -> void:
	var children = $".".get_children()
	for child in children:
		remove_child(child)
	
	deck = deck_scene.instantiate()
	$".".add_child(deck)
	deck.shuffle()
	deck.position = Vector2(deck_pos_x, deck_pos_y)
	deck.deck_clicked.connect(_on_deck_clicked)
	
	#Starting 4 cards
	for i in range(4):
		var card = deck.pop_front()
		$".".add_child(card)
		cards.append(card)
		card.card_clicked.connect(_on_card_clicked)
	
	update_visuals()

func update_visuals():
	var i = 0
	for card in cards:
		card.position = Vector2(card_pos_x + i * card_gap_x, card_pos_y)
		i+=1

func _on_card_clicked(card: Card):
	print("clicked card: ", card.colour, " ", card.suit, " ", card.rank)
	var card_rank = card.rank
	# Ace
	if(card.rank == 1):
		card_rank = 14
	if(card.colour == Card.Colour.BLACK):
		print("take ", card_rank, " dmg")
		if ((last_weapon_use == 0) or (card_rank < last_weapon_use)):
			health -= max(0, card_rank - weapon)
		else:
			health -= card_rank
	elif(card.suit == Card.Suit.HEARTS):
		print("heal ", card_rank, " hp")
		health = max(20, health + card_rank) 
	elif(card.suit == Card.Suit.DIAMONDS):
		print("add ", card_rank, " hitpower")
		weapon = card_rank
		last_weapon_use = 0
	$".".remove_child(card)
	return

func _on_deck_clicked():
	print("deck clicked")
	pass

func _process(delta: float) -> void:
	pass
