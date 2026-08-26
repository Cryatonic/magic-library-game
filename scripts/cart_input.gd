extends Node2D
class_name CartInput

signal click_book(book : Book)

@onready var book_cart: BookCart = $BookCart


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	pass


func _on_book_area_on_click() -> void:
	pass # Replace with function body.
