extends BaseSlot
class_name Bookcase_Slot

func _on_on_click() -> void:
	MHandler.emit_signal("deselect", self)


func _on_click_interaction(_click_obj: Node) -> void:
	pass
	#if _click_obj is Book:
		#_click_obj.move_book(global_position + Vector2(0,12))


func _on_on_deselect() -> void:
	pass # Replace with function body.
