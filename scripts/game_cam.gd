extends Camera2D
class_name GameCam

@onready var down_area: MouseHandle = $DownArea
@onready var up_area: MouseHandle = $UpArea
@onready var right_area: MouseHandle = $RightArea
@onready var left_area: MouseHandle = $LeftArea

var location_dict : Dictionary[String, Vector2] = {
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
		"Counter": $"../"/Codex/CodexCenter.global_position,
		"Cart": $"../".book_cart.global_position,
		"Bookcases": $"../".bookcase_input.global_position
	}
	
	cam_dict = { #Down; Up; Right; Left
		"Counter": ["Cart", null, null, "Bookcases"],
		"Cart": [null, "Bookcases", null, null],
		"Bookcases": ["Cart", null, "Counter", null]
	}
	current_view = "Bookcases"

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
	
	move_cam(location)
	current_view = view
