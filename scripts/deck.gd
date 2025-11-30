extends Node2D

var card_scene = preload("res://scenes/card.tscn")
@export var cards = []

func _ready() -> void:
	print("Creating Deck")
	$".".remove_child($Card)
	for suit in Card.Suit.values():
		for rank in range(1,14):
			var card = card_scene.instantiate()
			#$".".add_child(card)
			card.setup(suit, rank)
			card.face_up = false
			#card.z_index = cards.size() + 1
			cards.append(card)
			print(suit, " ", rank)
	print("Deck Created size: ", cards.size())
	return

func update_visuals():
	for i in range(cards.size()):
		var card = cards[i]
		card.face_up = false
		card.z_index = i+1

func shuffle() -> void:
	cards.shuffle()
	update_visuals()
	print("Deck Shuffled")

func push_front(card: Card) -> void:
	cards.push_front(card);
	update_visuals()
	print("Added ", card.suit, "-", card.rank, " at the beginning of the array")
	
func push_back(card: Card) -> void:
	cards.push_back(card);
	update_visuals()
	print("Added ", card.suit, "-", card.rank, " at the end of the array")

func pop_front() -> Card:
	var card = cards.pop_front();
	card.face_up = true
	card.z_index = 2
	update_visuals()
	print("Removed ", card.suit, "-", card.rank, " from the end of the array")
	return card

func pop_back() -> Card:
	var card = cards.pop_back();
	card.face_up = true
	card.z_index = 2
	update_visuals()
	print("Removed ", card.suit, "-", card.rank, " from the beginning of the array")
	return card

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")):
		print("deck clicked")
