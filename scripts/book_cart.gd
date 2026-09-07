extends Node2D
class_name BookCart

@onready var cart_grid: GridContainer = $CartGrid
var slots_array : Array[Array] #slots_array[] = row/x; slots_array[][] = column/y
var held_books : Array[Book] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("integer_division")
	for c in range(0, cart_grid.get_child_count() / cart_grid.columns):
		slots_array.append([])
	for s in range(0, slots_array.size()):
		for index in range(0, cart_grid.columns):
			#print((s * (slots_array.size() + 1)) + index)
			slots_array[s].append(cart_grid.get_child((s * (slots_array.size() + 1)) + index))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func fill_slots_w_tags(start_slot : CartSlot, tags : Array, remove : bool = false) -> bool:
	var slot_pos = find_slot_array_val(start_slot)
	if slot_pos == [-1,-1]:
		print("Sumting wong.")
		return false
	
	var able_to_slot : bool = true
	var slots_to_affect : Array[Array]
	for n in range(0,tags.size()):
		#slots_to_affect.append(tags[n])
		slots_to_affect.append([])
	
	for t in range(0, tags.size()):
		var size : int = 0
		var diagonals : bool = false
		if tags[t].size() > 1:
			size = tags[t][1]
		if tags[t].size() > 2:
			diagonals = tags[t][2]
			
		var x_range = [slot_pos[0] - size, slot_pos[0] + size]
		if x_range[0] < 0:
			x_range[0] = 0
		if x_range[1] > slots_array.size() - 1:
			x_range[1] = slots_array.size() - 1
		var y_range = [slot_pos[1] - size, slot_pos[1] + size]
		if y_range[0] < 0:
			y_range[0] = 0
		if y_range[1] > slots_array[0].size() - 1:
			y_range[1] = slots_array[0].size() - 1
		
		if diagonals:
			for x in range(x_range[0], x_range[1]+1):
				for y in range(y_range[0], y_range[1]+1):
					slots_to_affect[t].append(slots_array[x][y])
					#add_or_remove_tag(slots_array[x][y], tag, remove)
		else:
			slots_to_affect[t].append(slots_array[slot_pos[0]][slot_pos[1]])
			#add_or_remove_tag(slots_array[slot_pos[0]][slot_pos[1]], tag, remove)
			for x in range(x_range[0], x_range[1]+1):
				if x != slot_pos[0]:
					slots_to_affect[t].append(slots_array[x][slot_pos[1]])
					#add_or_remove_tag(slots_array[x][slot_pos[1]], tag, remove)
			for y in range(y_range[0], y_range[1]+1):
				if y != slot_pos[1]:
					slots_to_affect[t].append(slots_array[slot_pos[0]][y])
					#add_or_remove_tag(slots_array[slot_pos[0]][y], tag, remove)
		if remove: continue
		for book : Book in held_books:
			for slot : CartSlot in slots_to_affect[t]:
				if book.slot == slot:
					for tag in tags:
						for slot_tag in slot.effective_tags:
							able_to_slot = THandler.book_slot_tag_interactions(tag[0], slot_tag)
							if not able_to_slot:
								MHandler.emit_signal("do_not_deselect")
								return false
	#if not able_to_slot:
		#return false
	for t in range(0, tags.size()):
		for s in range(0, slots_to_affect[t].size()):
			add_or_remove_tag(slots_to_affect[t][s], tags[t], remove)
	return true
	
func find_slot_array_val(slot : CartSlot) -> Array[int]:
	for x in range(0, slots_array.size()):
		for y in range(0, slots_array[x].size()):
			if slots_array[x][y] == slot:
				return [x,y]
	return [-1,-1]

func add_or_remove_tag(slot : CartSlot, tag : Array, remove : bool = false):
	if remove:
		slot.remove_tag(tag)
	else:
		slot.add_tag(tag)
	
	slot.determine_effective_tags()
	THandler.slot_tag_interactions(slot)
	#slot.determine_effective_tags()
	
func add_or_remove_book(book : Book, remove : bool = false) -> void:
	if remove:
		var book_index = held_books.find(book)
		if book_index == -1: return
		held_books.pop_at(book_index)
	else:
		held_books.append(book)
