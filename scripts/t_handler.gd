extends Node
class_name TagHandler

var tag_visual_scene : PackedScene = preload("uid://3ayavar6b37h")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
			
