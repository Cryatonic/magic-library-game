extends Node2D
class_name Bookcase_Section

@export var section_tag_index : int
@export var input_position : Vector2
@onready var button: Button = $Button
@onready var section_sprite: Sprite2D = $SectionSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = input_position
	section_sprite.region_rect.position.x = section_sprite.region_rect.size.x * section_tag_index
	for each in get_children():
		if each is not Bookcase: continue
		each.section_tag_index = section_tag_index


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_toggled(toggled_on: bool) -> void:
	$"../".focus_on_section(self, toggled_on)

func set_focus(toggle : String = "") -> void:
	if toggle == "": return
	
	if toggle == "focus":
		position = Vector2.ZERO
		set_deferred("scale", Vector2(1.0,1.0))
		for each in get_children():
			if each is not Bookcase: 
				each.visible = true
				continue
			each.move_books(1.0, 0)
			each.set_books_clickable(true)
	
	elif toggle == "hidden":
		visible = false
		for each in get_children():
			if each is not Bookcase: 
				each.visible = false
				continue
			each.set_books_clickable(false)
			each.set_books_visible(false)
	
	elif toggle == "unfocused":
		visible = true
		position = input_position
		set_deferred("scale", Vector2(0.4,0.4))
		if button.button_pressed == true: button.button_pressed = false
		for each in get_children():
			if each is not Bookcase: 
				each.visible = true
				continue
			each.move_books(0.4, 4)
			each.set_books_visible(true)
			each.set_books_clickable(false)
