extends Node2D
class_name Codex

@onready var codex_button_container: CodexButtonContainer = $CodexButtonContainer

@onready var sub_creature_types : Array[String] = ["Aberration", "Beast", "Construct", 
"Elemental", "Undead", "Unholy"]
#get_tree().get_first_node_in_group("Game").subject_creature_types
@onready var sub_characteristics : Array[String] = ["Aquatic", "Dangerous", "Flaming",
"Flying", "Friendly", "Hostile", "Intelligent", "Magical"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sub in sub_creature_types:
		codex_button_container.add_codex_button("creature", sub)
	for sub in sub_characteristics:
		codex_button_container.add_codex_button("char", sub)
	await get_tree().process_frame
	#codex_button_container.size.x = (codex_button_container.get_node("VScrollBar/GridContainer").get_child(0).size.x * 2) + 12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
