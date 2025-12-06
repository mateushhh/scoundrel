extends Node2D

var card_scene = preload("res://scenes/card.tscn")
var deck_scene = preload("res://scenes/deck.tscn")

const card_pos_x = 200
const card_pos_y = 250
const card_gap_x = 100
const deck_pos_x = 100
const deck_pos_y = 100

var deck: Deck
var cards: Array[Card] = [null, null, null, null]
var health: int = 20
var weapon: int = 0
var last_weapon_use: int = 0

func _ready() -> void:
	#Remove placeholders from the scene
	var placeholder_children = [$Deck, $Card, $Card2, $Card3, $Card4]
	for child in placeholder_children:
		remove_child(child)
	
	deck = deck_scene.instantiate()
	$".".add_child(deck)
	deck.shuffle()
	deck.position = Vector2(deck_pos_x, deck_pos_y)
	deck.deck_clicked.connect(_on_deck_clicked)
	
	#Starting 4 cards
	for i in range(cards.size()):
		var card = deck.pop_front()
		$".".add_child(card)
		cards[i] = card
		card.card_clicked.connect(_on_card_clicked)
	update_visuals()

func update_visuals():
	var health_bar = $Control/HealthBar
	var health_value = $Control/HealthBar/HealthValue
	health_bar.value = health
	health_value.text = str(health)
	
	for i in range(cards.size()):
		if cards[i]:
			cards[i].position = Vector2(card_pos_x + i * card_gap_x, card_pos_y)

func table_card_count() -> int:
	var count = 0
	for i in range(cards.size()):
		if cards[i]:
			count += 1
	return count

func deck_card_count() -> int:
	var count = 0
	for i in range(deck.cards.size()):
		if deck.cards[i]:
			count += 1
	return count

func _on_card_clicked(card: Card):
	#print("clicked card: ", card.colour, " ", card.suit, " ", card.rank)
	
	if(table_card_count() > 1):
		var card_rank = card.rank
		if(card.rank == 1):
			card_rank = 14
		if(card.colour == Card.Colour.BLACK):
			print("You've got hit (-", card_rank, "hp)")
			if ((last_weapon_use == 0) or (card_rank < last_weapon_use)):
				health -= max(0, card_rank - weapon)
			else:
				health -= card_rank
			health = max(0, health)
		elif(card.suit == Card.Suit.HEARTS):
			print("You've healed (+", card_rank, "hp)")
			health = min(20, health + card_rank) 
		elif(card.suit == Card.Suit.DIAMONDS):
			print("You've found a weapon (+", card_rank, "hitpower)")
			weapon = card_rank
			last_weapon_use = 0
		cards[cards.find(card)] = null
		$".".remove_child(card)
	else:
		print("Only one card on the table, take cards from the deck")
	update_visuals()
	return

func _on_deck_clicked():	
	# taking 3 cards from the deck
	if ((table_card_count() == 1) and (deck_card_count() >=3)) :
		for i in range(cards.size()):
			if cards[i] == null:
				var card = deck.pop_front()
				$".".add_child(card)
				cards[i] = card
				card.card_clicked.connect(_on_card_clicked)
	update_visuals()
	pass
