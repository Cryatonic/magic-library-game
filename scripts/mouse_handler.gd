extends Node
class_name MouseHandler

@warning_ignore("unused_signal")
signal hovering(hov_obj : Node, is_hover : bool)
@warning_ignore("unused_signal")
signal click(click_obj : Node)
signal deselect

var hovering_objs : Array[Node] = []
var clicked_obj : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and hovering_objs.size() != 0:
		var priority_hov_obj : Variant = hovering_objs[0]
		if hovering_objs.size() > 1:
			for obj in hovering_objs:
				if obj.process_priority > priority_hov_obj.process_priority:
					priority_hov_obj = obj
			#hovering_objs.pop_at(hovering_objs.find(priority_hov_obj))
		if priority_hov_obj.get_node("MouseHandle").is_clickable:
			if clicked_obj == null:
				emit_signal("click", priority_hov_obj)
				priority_hov_obj.emit_signal("on_click")
			else:
				priority_hov_obj.emit_signal("click_interaction", clicked_obj)
				clicked_obj.emit_signal("click_interaction", priority_hov_obj)
				emit_signal("deselect", clicked_obj)

func _on_hovering(hov_obj: Node, is_hover : bool) -> void:
	if is_hover:
		hovering_objs.append(hov_obj)
	else:
		hovering_objs.erase(hov_obj)

func _on_click(click_obj: Node) -> void:
	clicked_obj = click_obj

func _on_deselect(obj : Node) -> void:
	obj.emit_signal("on_deselect")
	clicked_obj = null
