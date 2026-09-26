extends Node2D
class_name Codex

@onready var codex_button_container: CodexButtonContainer = $CodexButtonContainer
@onready var search: Button = $Search
@onready var search_results: RichTextLabel = $SearchResults


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_codex_tabs(tab_names : Array[String], subject : String):
	for sub_name in tab_names:
		codex_button_container.add_codex_button(subject, sub_name)


func _on_search_pressed() -> void:
	var books = get_tree().get_first_node_in_group("Game")._on_search_for_books()
	
	search_results.clear()
	search_results.add_text("Results for Subjects: ")
	for sub in get_tree().get_first_node_in_group("Game").searching_subjects:
		search_results.add_text(sub + "   ")
	search_results.newline()
	search_results.newline()
	if books.size() == 0:
		search_results.add_text("No Matches")
		return
	var book_count : int = 0
	var texture = preload("uid://u31bbtas2n1i")
	var current_sect = books[0].section_tag_val
	var just_looped : bool = false
	for location : Book in books:
		if location.section_tag_val != current_sect:
			current_sect = location.section_tag_val
			search_results.newline()
			if not just_looped:
				search_results.newline()
				search_results.newline()
			book_count = -1
		just_looped = false
		search_results.add_image(texture, 8, 8, Color.WHITE, INLINE_ALIGNMENT_CENTER, location.section_tag_sprite.region_rect, "Section Tag")
		search_results.add_text(location.location_label.text + "            ")
		book_count += 1
		if book_count == 0: book_count += 1
		elif book_count % 3 == 0:
			search_results.newline()
			search_results.newline()
			just_looped = true
