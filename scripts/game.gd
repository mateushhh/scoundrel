extends Node2D

var card_scene = preload("res://scenes/card.tscn")
var deck_scene = preload("res://scenes/deck.tscn")

const card_pos_x = 250
const card_pos_y = 300
const card_gap_x = 100
const deck_pos_x = 100
const deck_pos_y = 300
const weapon_pos_x = 400
const weapon_pos_y = 470
const weapon_gap_x = 20
const weapon_gap_y = 20

var deck: Deck
var cards: Array[Card] = [null, null, null, null]
var current_weapon_card: Card = null
var last_weapon_use_card: Card = null

var health: int = 20
var weapon: int = 0
var last_weapon_use_rank: int = 0
var last_weapon_use_suit: Card.Suit = Card.Suit.CLUBS

var game_over: bool = 0
var score: int = 0
var current_room: int = 1
var last_skipped_room: int = -1

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
	
	#Weapon and LastWeaponUse
	current_weapon_card = $Weapon
	current_weapon_card.visible = false
	last_weapon_use_card = $LastWeaponUse
	last_weapon_use_card.visible = false
	
	update()

func check_game_over():
	score = 0
	if deck_card_count() < 3:
		print("game over, you got to the end of the deck")
		game_over = 1
		score = health
		for card in cards:
			var card_rank = card.rank
			if(card != null and card.suit == Card.Suit.HEARTS):
				if(card.rank == 1):
					card_rank = 14
				score += card_rank
		for card in deck.cards:
			var card_rank = card.rank
			if(card.suit == Card.Suit.HEARTS):
				if(card.rank == 1):
					card_rank = 14
				score += card_rank
		print(score)
		
	if health <= 0:
		print("you died")
		game_over = 1
		for card in cards:
			if(card != null and card.colour == Card.Colour.BLACK):
				var card_rank = card.rank
				if(card.rank == 1):
					card_rank = 14
				score -= card_rank
		for card in deck.cards:
			var card_rank = card.rank
			if(card.colour == Card.Colour.BLACK):
				if(card.rank == 1):
					card_rank = 14
				score -= card_rank
		print(score)
	return

func update_visuals():
	var health_bar = $Control/HealthBar
	var health_value = $Control/HealthBar/HealthValue
	var room_label = $Control/RoomLabel
	var cards_deck_label = $Control/CardsDeckLabel
	
	health_bar.value = health
	health_value.text = str(health)
	room_label.text = "Room: " + str(current_room)
	cards_deck_label.text = str(deck_card_count()) + "/52"
	
	if weapon != 0:
	# Ace has power of 14 but in deck.gd Ace has rank 1
		if(weapon == 14):
			current_weapon_card.rank = 1
		else:
			current_weapon_card.rank = weapon
		current_weapon_card.visible = true
		
		if last_weapon_use_rank != 0:
			if(last_weapon_use_rank == 14):
				last_weapon_use_card.rank = 1
			else:
				last_weapon_use_card.rank = last_weapon_use_rank
			last_weapon_use_card.suit = last_weapon_use_suit
			last_weapon_use_card.visible = true
	
	for i in range(cards.size()):
		if cards[i]:
			cards[i].position = Vector2(card_pos_x + i * card_gap_x, card_pos_y)
	
	if game_over:
		$Control/GameOverLabel.visible = true

func update():
	check_game_over()
	update_visuals()

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
		if(card_rank == 1):
			card_rank = 14
		if(card.colour == Card.Colour.BLACK):
			if ((last_weapon_use_rank == 0) or (card_rank <= last_weapon_use_rank)):
				print("You've got hit (-", max(0, card_rank - weapon), "hp)")
				health -= max(0, card_rank - weapon)
				last_weapon_use_rank = card_rank
				last_weapon_use_suit = card.suit
			else:
				print("You've got hit (-", card_rank, "hp)")
				health -= card_rank
			health = max(0, health)
		elif(card.suit == Card.Suit.HEARTS):
			print("You've healed (+", card_rank, "hp)")
			health = min(20, health + card_rank) 
		elif(card.suit == Card.Suit.DIAMONDS):
			print("You've found a weapon (+", card_rank, "hitpower)")
			weapon = card_rank
			last_weapon_use_rank = 0
			last_weapon_use_card.visible = false
		cards[cards.find(card)] = null
		$".".remove_child(card)
	else:
		print("Only one card on the table, take cards from the deck")
	update()
	return

func _on_deck_clicked():	
	# taking 3 cards from the deck
	if ((table_card_count() == 1) and (deck_card_count() >= 3)) :
		for i in range(cards.size()):
			if cards[i] == null:
				var card = deck.pop_front()
				$".".add_child(card)
				cards[i] = card
				card.card_clicked.connect(_on_card_clicked)
		current_room += 1
		update()
	pass

func _on_run_button_pressed() -> void:
	if (last_skipped_room != current_room - 1) and (table_card_count() == 4):
		last_skipped_room = current_room
		for i in range(4):
			deck.push_back(cards[i])
			$".".remove_child(cards[i])
			cards[i] = deck.pop_front()
			$".".add_child(cards[i])
			cards[i].card_clicked.connect(_on_card_clicked)
		current_room += 1
		update()
	pass
