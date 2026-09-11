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
@onready var mouse_handle: MouseHandle = $MouseHandle
@onready var tag_visuals_marker: Marker2D = $BookLabel/TagVisualsMarker

var showing_spine : bool = false
var flip_button_x_offset : Array[int] = [-16, -4]
var base_click_area_dimensions : Array[Vector2] = [Vector2(160,300), Vector2(20,0)] #size, position
var spine_click_area_dimensions : Array[Vector2] = [Vector2(80,300), Vector2(0,0)] #size, position
@export var section_tag_val : int = 0
@export var shelf_location : Array[int] = [0,0,0] #bookcase number; shelf number; shelf position
var previous_glob_pos : Vector2
var pos_to_go : Vector2

@export var tags : Array[Array] = []
var tag_sprite_offset : int = 12

var slot : Node = null
var slot_facing : float = 0.0

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

#func _input(_event: InputEvent) -> void:
	#if _event.is_action_pressed("debug"):
		#print(slot)

func flip_book(show_spine : bool = false) -> void:
	if show_spine:
		sprite_2d.region_rect.position.x = sprite_2d.region_rect.size.x
		flip_book_button.position.x = flip_button_x_offset[1]
		book_label.visible = show_spine
		global_position = get_tree().get_first_node_in_group("GameCam").global_position
		set_deferred("scale", scales[3])
		change_mouse_click_area(1.0)
		
		MHandler.emit_signal("toggle_all", false)
		
		for obj in $"../../".get_node("BookContainer").get_children():
			if obj != self and obj is Book:
				obj.flip_book_button.disabled = true
	else:
		sprite_2d.region_rect.position.x = 0.0
		flip_book_button.position.x = flip_button_x_offset[0]
		book_label.visible = show_spine
		global_position = previous_glob_pos
		#if slot != null:
			#curr_scale = scales[slot.slotted_book_mod]
		set_deferred("scale", curr_scale)
		change_mouse_click_area()
		
		MHandler.emit_signal("toggle_all", true)
		for obj in $"../../".get_node("BookContainer").get_children():
			if obj != self and obj is Book:
				obj.flip_book_button.disabled = false
		
func move_book(pos : Vector2 = previous_glob_pos):
	kill_tween()
	pos_to_go = pos
	tween.tween_property(self, "global_position", pos_to_go, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	moving = true
	set_book_scale(0)
	#sprite_2d.z_index = 1
	
func kill_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
func set_book_scale(val : int) -> void:
	curr_scale = scales[val]
	set_deferred("scale", curr_scale)

func change_mouse_click_area(s_f : float = slot_facing) -> void:
	var m_h = mouse_handle.get_node("CollisionShape2D")
	if s_f == 0:
		m_h.shape.size = base_click_area_dimensions[0]
		m_h.position = base_click_area_dimensions[1]
	else:
		m_h.shape.size = spine_click_area_dimensions[0]
		m_h.position = spine_click_area_dimensions[1]

func _on_button_pressed() -> void:
	showing_spine = !showing_spine
	flip_book(showing_spine)

func _on_finished_moving() -> void:
	moving = false
	sprite_2d.z_index = 0
	change_mouse_click_area()
	if slot != null:
		set_book_scale(slot.slotted_book_mod)
		sprite_2d.region_rect.position.x = slot_facing

func _on_on_deselect() -> void:
	flip_book_button.disabled = true
	if not moving:
		sprite_2d.z_index = 0
	if slot != null and not moving:
		set_book_scale(slot.slotted_book_mod)
		sprite_2d.region_rect.position.x = slot_facing
		change_mouse_click_area()
	else:
		set_book_scale(0)

func _on_on_click() -> void:
	set_book_scale(1)
	change_mouse_click_area(0)
	sprite_2d.z_index = 1
	sprite_2d.region_rect.position.x = 0
	flip_book_button.disabled = false
	
	populate_cart_slot_with_tags(slot, true)

func _on_click_interaction(_click_obj: Node) -> void:
	if _click_obj is BaseSlot:
		if _click_obj is CartSlot:
			var able_to_slot : bool = true
			for each in tags:
				for t in _click_obj.effective_tags:
					able_to_slot = THandler.book_slot_tag_interactions(each[0], t)
					if not able_to_slot:
						MHandler.emit_signal("do_not_deselect")
						return
		
		slot_book(_click_obj)
	elif _click_obj is Book:
		#pass
		if _click_obj == self:
			populate_cart_slot_with_tags(slot)
	else:
		populate_cart_slot_with_tags(slot, true)
		slot = null
		slot_facing = 0

func slot_book(s : BaseSlot) -> void:
	if s is CartSlot:
		if not populate_cart_slot_with_tags(s):
			return
	slot = s
	move_book(s.pos_to_slot)
	if s.side_slot:
		slot_facing = sprite_2d.region_rect.size.x
	else:
		slot_facing = 0

func add_tag(tag : Array) -> void:
	tags.append(tag)
	
func remove_tag(tag : Variant) -> void:
	var tag_index : int = -1
	if tag is String:
		for tag_name in tags:
			if tag_name[0] == tag:
				tag_index = tags.find(tag_name)
	elif tag is Array:
		tag_index = tags.find(tag)
		
	tags.pop_at(tag_index)

func populate_cart_slot_with_tags(s : BaseSlot, delete : bool = false) -> bool:
	if s == null:
		return true
	if s is not CartSlot:
		return true
	
	s.parent_cart.add_or_remove_book(self, delete)
	if s.parent_cart.fill_slots_w_tags(s, tags, delete):
		return true
	s.parent_cart.add_or_remove_book(self, !delete)
	return false

func add_tag_visuals() -> void:
	var visuals_array : Array[String] = []
	for each in tags:
		if each.size() == 1:
			visuals_array.append(each[0])
		else:
			for num in each[1]:
				visuals_array.append(each[0])
		THandler.add_tag_visual(self, tag_visuals_marker.global_position, "BookLabel/TagVisualsMarker", visuals_array, tag_sprite_offset)
