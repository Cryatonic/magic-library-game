extends ScrollContainer
class_name CodexButtonContainer

@onready var grid_container: GridContainer = $VScrollBar/GridContainer
var c_b_scene : PackedScene = preload("uid://dbufbigy43tt1")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_codex_button(codex_text : String):
	var c_b : CodexButton = c_b_scene.instantiate()
	c_b.button_text = codex_text
	
	grid_container.add_child(c_b)
