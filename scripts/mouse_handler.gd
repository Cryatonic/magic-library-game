extends Node
class_name MouseHandler

@warning_ignore("unused_signal")
signal hovering(hov_obj : Node, is_hover : bool)
@warning_ignore("unused_signal")
signal click(click_obj : Node)
signal deselect(obj : Node)
@warning_ignore("unused_signal")
signal do_not_deselect

@warning_ignore("unused_signal")
signal toggle_all(t : bool)

var hovering_objs : Array[Node] = []
var clicked_obj : Node = null

var d_n_deselect : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and hovering_objs.size() != 0:
		var priority_hov_obj : Node = hovering_objs[0]
		if hovering_objs.size() > 1:
			for obj in hovering_objs:
				if obj.process_priority > priority_hov_obj.process_priority:
					priority_hov_obj = obj
			#hovering_objs.pop_at(hovering_objs.find(priority_hov_obj))
		if priority_hov_obj.has_node("MouseHandle"):
			if priority_hov_obj.get_node("MouseHandle").is_clickable:
				if clicked_obj == null:
					emit_signal("click", priority_hov_obj)
					#priority_hov_obj.emit_signal("on_click")
				else:
					priority_hov_obj.emit_signal("click_interaction", clicked_obj)
					if clicked_obj != priority_hov_obj:
						clicked_obj.emit_signal("click_interaction", priority_hov_obj)
					if not d_n_deselect:
						emit_signal("deselect", clicked_obj)
					d_n_deselect = false
	if Input.is_action_just_pressed("action") and clicked_obj is Book:
		clicked_obj.showing_spine = !clicked_obj.showing_spine
		clicked_obj.flip_book(clicked_obj.showing_spine)
		
	if Input.is_action_just_pressed("debug") and clicked_obj != null:
		if clicked_obj is Book:
			print(clicked_obj.tags)
			print(clicked_obj.subjects)

func _on_hovering(hov_obj: Node, is_hover : bool) -> void:
	if is_hover:
		hovering_objs.append(hov_obj)
	else:
		hovering_objs.erase(hov_obj)

func _on_click(click_obj: Node) -> void:
	clicked_obj = click_obj
	clicked_obj.emit_signal("on_click")

func _on_deselect(obj : Node) -> void:
	if obj == null: return
	obj.emit_signal("on_deselect")
	clicked_obj = null

func _on_toggle_all(t : bool) -> void:
	for mh in get_tree().get_nodes_in_group("MouseHandle"):
		mh.set_deferred("input_pickable", t)


func _on_do_not_deselect() -> void:
	d_n_deselect = true
