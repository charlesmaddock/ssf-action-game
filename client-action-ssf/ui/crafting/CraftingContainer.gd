extends HBoxContainer


export(NodePath) var inventory_node_path


onready var crafting_button: Button = $CraftButton
onready var inventory_node = get_node(inventory_node_path)

onready var craft_controls = $CraftControls

onready var failed_craft_info = $FailedCraftInfo
onready var failed_craft_info_label = $FailedCraftInfo/Label


var item_scene = load("res://item/Item.tscn")
var crafting_items = []
var crafting_result_slot = null


func _ready():
	Events.connect("inventory_toggled", self, "_on_inventory_toggled")
	API.connect("packet_received", self, "_on_packet_received")
	craft_controls.connect("craft_items", self, "_on_craft_items")
	
	for child in get_children():
		if child.get("is_crafting_slot"):
			child.connect("placed_item", self, "_on_placed_item")
			child.connect("removed_item", self, "_on_removed_item")
	
	show_failed_craft_info(false)


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.showCraftPreview:
		if data.type == -404:
			show_failed_craft_info(true, false)
		elif data.type == -426:
			show_failed_craft_info(true, true)
		else:
			show_craft_controls(data)
	if event == WsEvents.addItemInv:
		if data.crafted == true:
			show_failed_craft_info(false)


func show_craft_controls(serialized_item: Dictionary):
	failed_craft_info.set_visible(false)
	craft_controls.set_visible(true)
	craft_controls.show_controls(serialized_item)


func show_failed_craft_info(no_result: bool, need_more: bool = false):
	failed_craft_info.set_visible(true)
	craft_controls.set_visible(false)
	if need_more:
		failed_craft_info_label.text = "Need more"
	elif no_result:
		failed_craft_info_label.text = "No results"
	else:
		failed_craft_info_label.text = "Add items to make something"


func _on_inventory_toggled(vis: bool):
	send_items_back_to_inventory_slots()


func send_items_back_to_inventory_slots():
	for item in crafting_items:
		inventory_node.move_item_to_first_available(item)


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
		show_failed_craft_info(false)
	else:
		API.request_craft_preview(ingredients_request)
