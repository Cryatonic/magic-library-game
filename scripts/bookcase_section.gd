extends Node2D
class_name Bookcase_Section

@export var input_position : Vector2
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = input_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		position = Vector2.ZERO
	else:
		position = input_position
