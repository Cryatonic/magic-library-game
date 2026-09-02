extends BaseSlot
class_name CartSlot

@onready var slot_sprite: Sprite2D = $SlotSprite
@onready var parent_cart : BookCart = $"../../"

var held_tags : Array[Array] = []

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
	if _click_obj is Book:
		parent_cart.fill_slots_w_tags(self, _click_obj.tags)

func _on_on_deselect() -> void:
	pass

func add_tag(tag : Array) -> void:
	held_tags.append(tag)
	
func remove_tag(tag : Variant) -> void:
	var tag_index : int = -1
	if tag is String:
		for tag_name in held_tags:
			if tag_name[0] == tag:
				tag_index = held_tags.find(tag_name)
	elif tag is Array:
		tag_index = held_tags.find(tag)
		
	held_tags.pop_at(tag_index)
	
