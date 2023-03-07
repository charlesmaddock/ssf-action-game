extends HBoxContainer


onready var crafting_button: Button = $CraftButton


var item_scene = load("res://item/Item.tscn")
var crafting_items = []
var crafting_result_slot = null


func _ready():
	crafting_button.connect("craft_items", self, "_on_craft_items")
	
	for child in get_children():
		if child.get("is_crafting_slot"):
			child.connect("placed_item", self, "_on_placed_item")
			child.connect("removed_item", self, "_on_removed_item")


func _on_craft_items(requested_amount: int):
	var ingredients_request = []
	for item in crafting_items:
		ingredients_request.append({"id": item.id, "amount": item.amount })
	API.craft_item(ingredients_request, requested_amount)


func _on_placed_item(item: Item) -> void:
	if crafting_items.find(item) == -1:
		crafting_items.append(item)
		check_craft_result()


func _on_removed_item(item: Item) -> void:
	crafting_items.erase(item)
	check_craft_result()


func check_craft_result() -> void:
	var ingredients_request = []
	for item in crafting_items:
		ingredients_request.append({"id": item.id, "amount": item.amount })
	
	if ingredients_request.size() == 0:
		crafting_button.clear_preview(false)
	else:
		API.request_craft_preview(ingredients_request)
