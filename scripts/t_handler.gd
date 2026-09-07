extends Node
class_name TagHandler

var tag_visual_scene : PackedScene = preload("uid://3ayavar6b37h")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func slot_tag_interactions(slot :  CartSlot) -> void:
	var num_tags = slot.effective_tags.size()
	
	if num_tags < 2: return
	
	for t in range(0, num_tags):
		pass

func add_tag_visual(slot : CartSlot, tags : Array[String]) -> void:
	var tag_num : int = 0
	
	for tag : String in tags:
		#var dup_tag : bool = false
		#for eff_tag in slot.effective_tags:
			#if tag == eff_tag:
				#dup_tag = true
				#break
		#if dup_tag:
			#break
		if tag == "normal": break
		var tag_vis : TagVisuals = tag_visual_scene.instantiate()
		slot.get_node("TagSpriteContainer").add_child(tag_vis)
		
		tag_vis.determine_offset(tag)
		tag_vis.select_sprite()
		var sprite_offset : int = 60
		match tags.size():
			1:
				tag_vis.global_position = slot.global_position
			2:
				match tag_num:
					0: 
						tag_vis.global_position = slot.global_position - Vector2(sprite_offset,0)
						tag_num += 1
					1:
						tag_vis.global_position = slot.global_position + Vector2(sprite_offset,0)
			3:
				match tag_num:
					0: 
						tag_vis.global_position = slot.global_position + Vector2(-sprite_offset,-sprite_offset)
						tag_num += 1
					1:
						tag_vis.global_position = slot.global_position + Vector2(sprite_offset,-sprite_offset)
						tag_num += 1
					2:
						tag_vis.global_position = slot.global_position + Vector2(-sprite_offset,sprite_offset)
						tag_num += 1
					3:
						tag_vis.global_position = slot.global_position + Vector2(sprite_offset,sprite_offset)
			4:
				match tag_num:
					0: 
						tag_vis.global_position = slot.global_position + Vector2(-sprite_offset,-sprite_offset)
						tag_num += 1
					1:
						tag_vis.global_position = slot.global_position + Vector2(sprite_offset,-sprite_offset)
						tag_num += 1
					2:
						tag_vis.global_position = slot.global_position + Vector2(-sprite_offset,sprite_offset)
						tag_num += 1
					3:
						tag_vis.global_position = slot.global_position + Vector2(sprite_offset,sprite_offset)

func remove_tag_visual(slot : CartSlot, tag_name : String) -> void:
	for t : TagVisuals in slot.get_node("TagSpriteContainer").get_children():
		if t.tag_n == tag_name:
			t.queue_free()
			

func book_slot_tag_interactions(tag_one : String, tag_two : String) -> bool:
	match tag_one:
		"normal": return normal_bs_tag_interactions(tag_two)
		"fire": return fire_bs_tag_interactions(tag_two)
		"stone": return stone_bs_tag_interactions(tag_two)
		"water": return water_bs_tag_interactions(tag_two)
		"void": return void_bs_tag_interactions(tag_two)
	return true

func normal_bs_tag_interactions(tag : String) -> bool:
	if tag != "normal": return false
	return true
func fire_bs_tag_interactions(tag : String) -> bool:
	if tag == "fire" or tag == "stone": return true
	return false
func stone_bs_tag_interactions(tag : String) -> bool:
	if tag == "water" or tag == "void": return false
	return true
func water_bs_tag_interactions(tag : String) -> bool:
	if tag == "water": return true
	return false
func void_bs_tag_interactions(_tag : String) -> bool:
	return false
