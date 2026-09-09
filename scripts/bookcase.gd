extends Node2D
class_name Bookcase

@export var section_tag_index : int #index for tag sprite region
@export var case_num : int #shelf number [1 = left, 2 = middle, 3 = right]

@onready var grid_container: GridContainer = $GridContainer

const Book_Scene : PackedScene = preload("uid://cj1wwxgpl60d5")

var spawned_books : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not spawned_books:
		spawned_books = true
		
		var bci_bc = get_tree().get_first_node_in_group("BookContainer")
		var col : int = grid_container.columns
		
		var shelf_spot : int = 0
		for s : Bookcase_Slot in grid_container.get_children():
			var b : Book = Book_Scene.instantiate()
			
			b.section_tag_val = section_tag_index
			b.shelf_location[0] = case_num
			@warning_ignore("integer_division")
			b.shelf_location[1] = (shelf_spot / col) + 1
			b.shelf_location[2] = (shelf_spot % col) + 1
			@warning_ignore("integer_division")
			test_add_tags(shelf_spot % col, shelf_spot / col, b)
			
			var red = randf_range(0.2,1.0)
			var green = randf_range(0.2,1.0)
			var blue = randf_range(0.2,1.0)
			
			bci_bc.add_child(b)
			#await get_tree().process_frame
			b.sprite_2d.modulate = Color(red,green,blue,1.0)
			if s.pos_to_slot != s.global_position + s.pos_offset:
				s.pos_to_slot = s.global_position + s.pos_offset
			b.add_tag_visuals()
			b.slot_book(s)
			shelf_spot += 1

func test_add_tags(val : int, stren : int, b : Book) -> void:
	if val == 0:
		b.add_tag(["normal"])
	elif val == 1:
		b.add_tag(["fire", stren + 1, true])
	elif val == 2:
		b.add_tag(["stone"])
	elif val == 3:
		b.add_tag(["water", stren + 1])
	elif val == 4:
		b.add_tag(["void", stren + 1])
