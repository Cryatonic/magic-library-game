extends Node2D
class_name Game

@warning_ignore("unused_signal")
signal search_for_books

@onready var game_cam: Camera2D = $GameCam

@onready var book_cart: BookCart = $BookCart
@onready var bookcase_input: Node2D = $Bookcase_Input
@onready var codex: Codex = $Codex

@onready var sub_creature_types : Array[String] = ["Aberration", "Beast", "Construct", 
"Elemental", "Undead", "Unholy"]
@onready var sub_characteristics : Array[String] = ["Aquatic", "Dangerous", "Flaming",
"Flying", "Friendly", "Hostile", "Intelligent", "Magical"]
@onready var subjects_dict : Dictionary = {}

var searching_subjects : Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_cam.make_dicts()
	
	codex.add_codex_tabs(sub_creature_types, "creature")
	codex.add_codex_tabs(sub_characteristics, "char")
	
	for sub in sub_creature_types:
		subjects_dict[sub] = []
	for sub in sub_characteristics:
		subjects_dict[sub] = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_search_for_books() -> Array[String]:
	if searching_subjects.size() == 0:
		print("Empty.")
		return []
	
	var matching_books : Array[String] = []
	
	for book : Book in subjects_dict[searching_subjects[0]]:
		if compare_subjects(book):
			matching_books.append(book.location_label.text)
			
	
	#if matching_books.size() == 0:
		#print("No Matches")
		#return[]
	#for t : String in matching_books:
		#print(t)
	return matching_books

func compare_subjects(b : Book) -> bool:
	var m : bool
	
	for searching_sub in searching_subjects:
		m = false
		for book_sub in b.subjects:
			if book_sub == searching_sub:
				m = true
				break
		
		if not m:
			return m
	
	return m
