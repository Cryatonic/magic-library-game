extends ScrollContainer
class_name CodexButtonContainer

@onready var creatures_grid: GridContainer = $TabContainer/CreaturesBar/CreaturesGrid
@onready var char_grid: GridContainer = $TabContainer/CharacteristicsBar/CharGrid
var c_b_scene : PackedScene = preload("uid://dbufbigy43tt1")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_codex_button(type : String, codex_text : String):
	var c_b : CodexButton = c_b_scene.instantiate()
	c_b.button_text = codex_text
	
	if type == "creature":
		creatures_grid.add_child(c_b)
	elif type == "char":
		char_grid.add_child(c_b)
