extends Area2D
class_name MouseHandle

@warning_ignore("unused_signal")
signal clickable

@onready var parent = $"../"

@export var is_clickable : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	MHandler.emit_signal("hovering", parent, true)

func _on_mouse_exited() -> void:
	MHandler.emit_signal("hovering", parent, false)

func _on_clickable() -> bool:
	return is_clickable
