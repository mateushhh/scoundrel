extends Node2D
class_name Deck

signal deck_clicked

var card_scene = preload("res://scenes/card.tscn")
var cards: Array[Card] = []

func _ready() -> void:
	print("Creating Deck")
	for suit in Card.Suit.values():
		for rank in range(1,14):
			var card = card_scene.instantiate()
			cards.append(card)
			card.setup(suit, rank)
			card.face_up = false
			#print(suit, " ", rank)
	print("Deck Created size: ", cards.size())
	return

func shuffle() -> void:
	cards.shuffle()
	print(cards)
	print("Deck Shuffled")

#func action():
#	print("Action: Deck")
#	return

func push_front(card: Card) -> void:
	cards.push_front(card);
	card.face_up = false
	print("Added ", Card.Suit.find_key(card.suit), "-", card.rank, " at the beginning of the array")
	
func push_back(card: Card) -> void:
	cards.push_back(card);
	card.face_up = false
	print("Added ", Card.Suit.find_key(card.suit), "-", card.rank, " at the end of the array")

func pop_front() -> Card:
	var card: Card = cards.pop_front();
	if(card == null):
		return null
	card.face_up = true
	print("Removed ", Card.Suit.find_key(card.suit), "-", card.rank, " from the beginning of the array")
	return card

func pop_back() -> Card:
	var card = cards.pop_back();
	if(card == null):
		return null
	card.face_up = true
	print("Removed ", Card.Suit.find_key(card.suit), "-", card.rank, " from the end of the array")
	return card

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")):
		#action()
		deck_clicked.emit()
		viewport.set_input_as_handled()
