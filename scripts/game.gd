extends Node2D
class_name Game

@onready var game_cam: Camera2D = $GameCam
@onready var down_area: MouseHandle = $GameCam/DownArea
@onready var up_area: MouseHandle = $GameCam/UpArea
@onready var right_area: MouseHandle = $GameCam/RightArea
@onready var left_area: MouseHandle = $GameCam/LeftArea

@onready var book_cart: BookCart = $BookCart
@onready var bookcase_input: Node2D = $Bookcase_Input
@onready var codex: Codex = $Codex

@onready var sub_creature_types : Array[String] = ["Aberration", "Beast", "Construct", 
"Elemental", "Undead", "Unholy"]
@onready var sub_characteristics : Array[String] = ["Aquatic", "Dangerous", "Flaming",
"Flying", "Friendly", "Hostile", "Intelligent", "Magical"]
@onready var subjects_dict : Dictionary = {}

var searching_subjects : Array[String] = []

var tween : Tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.kill()
	codex.add_codex_tabs(sub_creature_types, "creature")
	codex.add_codex_tabs(sub_characteristics, "char")
	
	for sub in sub_creature_types:
		subjects_dict[sub] = []
	for sub in sub_characteristics:
		subjects_dict[sub] = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func move_cam(pos : Vector2):
	kill_tween()
	tween.tween_property(game_cam, "global_position", pos, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func kill_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _on_down_area_mouse_entered() -> void:
	if !tween.is_running():
		move_cam(book_cart.global_position)


func _on_up_area_mouse_entered() -> void:
	if !tween.is_running():
		move_cam(bookcase_input.global_position)


func _on_right_area_mouse_entered() -> void:
	if !tween.is_running():
		move_cam($Codex/CodexCenter.global_position)


func _on_left_area_mouse_entered() -> void:
	if !tween.is_running():
		move_cam(bookcase_input.global_position)
