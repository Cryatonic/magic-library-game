extends Node2D
class_name BookArea

@warning_ignore("unused_signal")
signal on_deselect
@warning_ignore("unused_signal")
signal on_click()
@warning_ignore("unused_signal")
signal click_interaction(_click_obj : Node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_click_interaction(_click_obj: Variant) -> void:
	if _click_obj is Book:
		_click_obj.move_book(get_global_mouse_position())

func _on_on_click() -> void:
	MHandler.emit_signal("deselect", self)

func _on_on_deselect() -> void:
	pass # Replace with function body.
