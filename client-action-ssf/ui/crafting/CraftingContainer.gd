extends HBoxContainer


var crafting_items = []


func _ready():
	for child in get_children():
		if child.get("is_crafting_slot"):
			if child.is_crafting_slot == true:
				child.connect("placed_item", self, "_on_placed_item")
				child.connect("removed_item", self, "_on_removed_item")


func _on_placed_item(item: Item) -> void:
	if crafting_items.find(item) == -1:
		crafting_items.append(item)
	
	print("crafting_items: ", crafting_items)


func _on_removed_item(item: Item) -> void:
	crafting_items.remove(item)
	
	print("crafting_items after remove: ", crafting_items)
	
