extends Button
class_name CodexButton

@export var button_text : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = button_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().get_first_node_in_group("Game").searching_subjects.append(button_text)
	else:
		var index = get_tree().get_first_node_in_group("Game").searching_subjects.find(button_text)
		if index != -1:
			get_tree().get_first_node_in_group("Game").searching_subjects.pop_at(index)
