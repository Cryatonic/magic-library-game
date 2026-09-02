extends Node2D
class_name TagVisuals

@onready var tag_sprite: Sprite2D = $TagSprite
var sprite_region_offset : float = 0.0
var tag_n : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func determine_offset(tag_name : String) -> void:
	match tag_name:
		"fire": 
			sprite_region_offset = 0.0
			tag_n = "fire"
		"stone": 
			sprite_region_offset = tag_sprite.get_rect().size.x
			tag_n = "stone"
		"water": 
			sprite_region_offset = tag_sprite.get_rect().size.x * 2
			tag_n = "water"
		"void": 
			sprite_region_offset = tag_sprite.get_rect().size.x * 3
			tag_n = "void"
		
func select_sprite() -> void:
	tag_sprite.region_rect.position.x = sprite_region_offset
