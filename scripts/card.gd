extends Node2D
class_name Card

# Tilemap 
# ♥ - A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, Empty
# ♦ - A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, Reverse
# ♣ - A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, JokerR
# ♠ - A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, JokerB

signal card_clicked(card_instance)

const x_offset = 11
const y_offset = 2
const x_grid_offset = 65
const y_grid_offset = 65
enum Suit {HEARTS, DIAMONDS, CLUBS, SPADES}
enum Colour {RED, BLACK}

@onready var sprite: Sprite2D = $Sprite2D

var colour: Colour = Colour.RED
@export var suit: Suit = Suit.HEARTS:
	set(value):
		suit = value
		if (value==Suit.HEARTS or value==Suit.DIAMONDS):
			colour = Colour.RED
		else:
			colour = Colour.BLACK
		update_visuals()

@export var rank: int = 1:
	set(value):
		rank = value
		update_visuals()

@export var face_up: bool = true:
	set(value):
		face_up = value
		update_visuals()

func update_visuals():
	if(sprite == null):
		return
	
	var x: int
	var y: int
	var w: int = 42
	var h: int = 60
	
	if(face_up):
		x = x_offset + x_grid_offset * (rank-1)
		y = y_offset + y_grid_offset * (suit)
	else:
		x = x_offset + x_grid_offset * 13
		y = y_offset + y_grid_offset
	
	var region = Rect2(x,y,w,h)
	sprite.region_rect = region
	return

func setup(new_suit: Suit, new_rank: int):
	suit = new_suit
	rank = new_rank

#func action():
#	print("Action: ", Suit.find_key(suit), " ", rank)
#	return [suit, rank]

func _ready() -> void:
	update_visuals()

func _init() -> void:
	update_visuals()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")):
		card_clicked.emit(self)
		viewport.set_input_as_handled()
