extends Node2D
class_name Codex

@onready var codex_button_container: CodexButtonContainer = $CodexButtonContainer

@onready var subject_creature_types : Array[String] = ["Aberration", "Beast", "Construct", 
"Elemental", "Undead", "Unholy"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sub in subject_creature_types:
		codex_button_container.add_codex_button(sub)
	await get_tree().process_frame
	codex_button_container.size.x = (codex_button_container.get_node("VScrollBar/GridContainer").get_child(0).size.x * 2) + 12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
