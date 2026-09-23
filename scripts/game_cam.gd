extends Camera2D
class_name GameCam

@onready var down_area: MouseHandle = $DownArea
@onready var up_area: MouseHandle = $UpArea
@onready var right_area: MouseHandle = $RightArea
@onready var left_area: MouseHandle = $LeftArea
var moves_away_from_cart : int = 0

var location_dict : Dictionary[String, Variant] = {
	#"Counter": $"../".codex.global_position,
	#"Cart": $"../".book_cart.global_position,
	#"Bookcases": $"../".bookcase_input.global_position
}
var cam_dict : Dictionary[String, Array] = { #Focus; Down; Up; Right; Left
	#"Counter": [location_dict.get("Counter"), location_dict.get("Cart"), null, null, location_dict.get("Bookcases")],
	#"Cart": [location_dict.get("Cart"), null, location_dict.get("Bookcases"), null, null],
	#"Bookcases": [location_dict.get("Bookcases"), location_dict.get("Cart"), null, location_dict.get("Counter"), null]
}
var current_view : String = ""

var tween : Tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.kill()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func make_dicts() -> void:
	location_dict = {
		"Counter": $"../"/Codex/CodexCenter,
		"Cart": $"../".book_cart,
		"Bookcases": $"../".bookcase_input
	}
	
	cam_dict = { #Down; Up; Right; Left
		"Counter": [null, null, null, "Bookcases"],
		"Cart": [null, "Bookcases", null, null],
		"Bookcases": ["Cart", null, "Counter", null]
	}
	current_view = "Counter"
	move_to_scene(current_view)

func kill_tween() -> void:
	if tween: tween.kill()
	tween = create_tween()
	
func move_cam(pos : Variant) -> void:
	if pos == null: return
	
	kill_tween()
	tween.tween_property(self, "global_position", pos, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)


func _on_down_area_mouse_entered() -> void:
	if !tween.is_running():
		move_to_location(0)


func _on_up_area_mouse_entered() -> void:
	if !tween.is_running():
		move_to_location(1)


func _on_right_area_mouse_entered() -> void:
	if !tween.is_running():
		move_to_location(2)


func _on_left_area_mouse_entered() -> void:
	if !tween.is_running():
		move_to_location(3)

func move_to_location(index : int = 0) -> void:
	var view = cam_dict.get(current_view)[index]
	if view == null: return
	
	var location = location_dict.get(view)
	if location == null: return
	
	move_cam(location.global_position)
	move_cart(view)
	current_view = view
	hover_area_opacity()

func move_to_scene(scene : String) -> void:
	if scene == "" or scene == null: return
	if location_dict.get(scene) == null: return
	global_position = location_dict.get(scene).global_position
	move_cart(scene)
	hover_area_opacity()
	
func move_cart(new_view : String):
	var x_pos_delta = get_tree().get_first_node_in_group("Game").book_cart.global_position.x - location_dict.get(new_view).global_position.x
	get_tree().get_first_node_in_group("Game").book_cart.move_cart(x_pos_delta)
	
	moves_away_from_cart += 1
	if new_view == "Cart": 
		moves_away_from_cart = 0
		return
	if moves_away_from_cart > 1:
		if MHandler.clicked_obj is Book:
			MHandler.clicked_obj.slot_book(MHandler.clicked_obj.slot)
			MHandler.clicked_obj.slot.set_pos_to_slot()
			MHandler.clicked_obj.move_book(MHandler.clicked_obj.slot.pos_to_slot)
		MHandler.emit_signal("deselect", MHandler.clicked_obj)
	
	for loc in cam_dict:
		if loc == "Cart": cam_dict.get(loc)[1] = new_view
		elif loc == new_view: cam_dict.get(new_view)[0] = "Cart"
		else: cam_dict.get(loc)[0] = null
	
func hover_area_opacity() -> void:
	for dir in range(0,4):
		if cam_dict.get(current_view)[dir] == null:
			if dir == 0:
				$DownArea/Sprite.self_modulate.a8 = 24
			if dir == 1:
				$UpArea/Sprite.self_modulate.a8 = 24
			if dir == 2:
				$RightArea/Sprite.self_modulate.a8 = 24
			if dir == 3:
				$LeftArea/Sprite.self_modulate.a8 = 24
		else:
			if dir == 0:
				$DownArea/Sprite.self_modulate.a8 = 210
			if dir == 1:
				$UpArea/Sprite.self_modulate.a8 = 210
			if dir == 2:
				$RightArea/Sprite.self_modulate.a8 = 210
			if dir == 3:
				$LeftArea/Sprite.self_modulate.a8 = 210
