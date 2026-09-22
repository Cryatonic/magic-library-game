extends Control
class_name BaseSlot

@warning_ignore("unused_signal")
signal on_click
@warning_ignore("unused_signal")
signal click_interaction(_click_obj : Node)
@warning_ignore("unused_signal")
signal on_deselect

@export var slotted_book_mod : int #Book scales index
@export var side_slot : bool #true if slotted w/ spine face

@export var pos_to_slot : Vector2
@export var pos_offset : Vector2 = Vector2.ZERO #any offset to global pos for slotting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	set_pos_to_slot()

func set_pos_to_slot() -> void:
	if pos_to_slot != global_position + pos_offset:
		pos_to_slot = global_position + pos_offset
