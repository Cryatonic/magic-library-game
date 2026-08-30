extends BaseSlot
class_name CartSlot

#@warning_ignore("unused_signal")
#signal on_click
#@warning_ignore("unused_signal")
#signal click_interaction(_click_obj : Node)
#@warning_ignore("unused_signal")
#signal on_deselect

#@onready var cart_input : CartInput = $"../../../"

@onready var slot_sprite: Sprite2D = $SlotSprite

var mouse_hover : bool = false
var opacity_when_hovered : int = 95
	
func _on_mouse_handle_mouse_entered() -> void:
	mouse_hover = true
	slot_sprite.self_modulate.a8 = opacity_when_hovered

func _on_mouse_handle_mouse_exited() -> void:
	mouse_hover = false
	slot_sprite.self_modulate.a8 = 0

func _on_on_click() -> void:
	MHandler.emit_signal("deselect", self)

func _on_click_interaction(_click_obj: Node) -> void:
	pass
	#if _click_obj is Book:
		#_click_obj.move_book(global_position)

func _on_on_deselect() -> void:
	pass
