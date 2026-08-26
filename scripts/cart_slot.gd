extends Control
class_name CartSlot

@warning_ignore("unused_signal")
signal on_click
@warning_ignore("unused_signal")
signal click_interaction(_click_obj : Node)
@warning_ignore("unused_signal")
signal on_deselect

#@onready var cart_input : CartInput = $"../../../"

@onready var slot_sprite: Sprite2D = $SlotSprite

var mouse_hover : bool = false
var opacity_when_hovered : int = 95

var held_book : Book = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mouse_hover and slot_sprite.self_modulate.a8 != opacity_when_hovered:
		slot_sprite.self_modulate.a8 = opacity_when_hovered
	elif slot_sprite.self_modulate.a8 == opacity_when_hovered and not mouse_hover:
		slot_sprite.self_modulate.a8 = 0
	
func add_book(book : Book) -> void:
	held_book = book
	
func remove_book() -> void:
	held_book = null

func _on_mouse_handle_mouse_entered() -> void:
	mouse_hover = true

func _on_mouse_handle_mouse_exited() -> void:
	mouse_hover = false

func _on_on_click() -> void:
	get_tree().get_first_node_in_group("MouseHandler").emit_signal("deselect", self)

func _on_click_interaction(_click_obj: Node) -> void:
	if _click_obj is Book:
		_click_obj.move_book(global_position)
		#_click_obj.slot = self

func _on_on_deselect() -> void:
	pass
