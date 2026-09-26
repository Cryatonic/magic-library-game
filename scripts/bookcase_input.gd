extends Node2D
class_name Bookcase_Input

var focused_section : Bookcase_Section = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func focus_on_section(section : Bookcase_Section = null, toggle : bool = false) -> void:
	if toggle:
		focused_section = section
		for sec : Bookcase_Section in get_children():
			if sec == focused_section: sec.set_focus("focus")
			else: sec.set_focus("hidden")
	else: 
		focused_section = null
		for sec : Bookcase_Section in get_children():
			sec.set_focus("unfocused")
		
