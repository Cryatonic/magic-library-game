extends Node2D
class_name Book

signal finished_moving
@warning_ignore("unused_signal")
signal on_deselect
@warning_ignore("unused_signal")
signal on_click()
@warning_ignore("unused_signal")
signal click_interaction(_click_obj : Node)

@onready var flip_book_button: Button = $BookSprite/FlipBookButton
@onready var sprite_2d: Sprite2D = $BookSprite
@onready var book_label: Node2D = $BookLabel
@onready var section_tag_sprite: Sprite2D = $BookLabel/SectionTagSprite
@onready var location_label: Label = $BookLabel/SectionTagSprite/LocationLabel

var showing_spine : bool = false
var flip_button_x_offset : Array[int] = [-16, -4]
@export var section_tag_val : int = 0
@export var shelf_location : Array[int] = [0,0,0] #bookcase number; shelf number; shelf position
var previous_glob_pos : Vector2
var pos_to_go : Vector2

var slot : CartSlot = null

var moving : bool = false

var tween : Tween

var scales : Array[Vector2] = [Vector2(1.0,1.0), Vector2(1.2,1.2),
Vector2(0.85,0.85),Vector2(4.0,4.0)] #normal, selected, slotted, zoomed
var curr_scale : Vector2 = scales[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	section_tag_sprite.region_rect.position.x = section_tag_val * section_tag_sprite.region_rect.size.x
	location_label.text = str(shelf_location[0]) + "-" + str(shelf_location[1]) + "-" + str(shelf_location[2])
	previous_glob_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if global_position == pos_to_go and moving:
		emit_signal("finished_moving")
	if not showing_spine:
		previous_glob_pos = global_position

func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("debug"):
		print(slot)

func flip_book(show_spine : bool = false) -> void:
	if show_spine:
		sprite_2d.region_rect.position.x = sprite_2d.region_rect.size.x
		flip_book_button.position.x = flip_button_x_offset[1]
		book_label.visible = show_spine
		global_position = Vector2.ZERO
		set_deferred("scale", scales[3])
		
		get_tree().get_first_node_in_group("MouseHandler").emit_signal("toggle_all", false)
		
		for obj in $"../../".get_node("BookContainer").get_children():
			if obj != self and obj is Book:
				obj.flip_book_button.disabled = true
	else:
		sprite_2d.region_rect.position.x = 0
		flip_book_button.position.x = flip_button_x_offset[0]
		book_label.visible = show_spine
		global_position = previous_glob_pos
		set_deferred("scale", curr_scale)
		
		get_tree().get_first_node_in_group("MouseHandler").emit_signal("toggle_all", true)
		for obj in $"../../".get_node("BookContainer").get_children():
			if obj != self and obj is Book:
				obj.flip_book_button.disabled = false
		
func move_book(pos : Vector2 = previous_glob_pos):
	kill_tween()
	pos_to_go = pos
	tween.tween_property(self, "global_position", pos_to_go, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	moving = true
	set_book_scale(0)
	sprite_2d.z_index = 1
	
func kill_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
func set_book_scale(val : int) -> void:
	curr_scale = scales[val]
	set_deferred("scale", curr_scale)

func _on_button_pressed() -> void:
	showing_spine = !showing_spine
	flip_book(showing_spine)

func _on_finished_moving() -> void:
	moving = false
	sprite_2d.z_index = 0
	if slot != null:
		set_book_scale(2)

func _on_on_deselect() -> void:
	if slot != null and not moving:
		set_book_scale(2)
	else:
		set_book_scale(0)

func _on_on_click() -> void:
	set_book_scale(1)

func _on_click_interaction(_click_obj: Node) -> void:
	if _click_obj is CartSlot:
		slot = _click_obj
	elif _click_obj is Book:
		pass
	else:
		slot = null
