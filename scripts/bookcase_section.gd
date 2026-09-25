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
		set_deferred("scale", Vector2(1.0,1.0))
		for each in get_children():
			if each is not Bookcase: continue
			each.move_books(1.0, 0)
			each.set_books_clickable(true)
		for section : Bookcase_Section in $"../".get_children():
			if section == self: continue
			section.visible = false
			for each in section.get_children():
				if each is not Bookcase: continue
				each.set_books_visible(false)
	else:
		position = input_position
