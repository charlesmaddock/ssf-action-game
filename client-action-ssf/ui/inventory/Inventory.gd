extends Control


onready var inventory_backdrop = $InventoryBackdrop
onready var item_grid: GridContainer = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/ItemsGrid"
onready var item_grid_vbox: VBoxContainer = $HBoxContainer/VBoxContainer
onready var upper_inventory = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/UpperInventory"

const INVENTORY_WIDTH = 8
const INVENTORY_HEIGHT = 4

var item_slot_scene = load("res://ui/inventory/ItemSlot.tscn")


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	
	for child in item_grid.get_children():
		child.queue_free()
	
	item_grid.columns = INVENTORY_WIDTH
	
	for i in (INVENTORY_WIDTH * INVENTORY_HEIGHT):
		var item_slot = item_slot_scene.instance()
		item_grid.add_child(item_slot)
	
	toggle_visible()


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.inventoryContents:
		for itemData in data.items:
			add_item({"id": itemData.id, "type": itemData.type, "amount": itemData.amount})
	elif event == WsEvents.addItemInv:
		add_item({"id": data.id, "type": data.type, "amount": data.amount})


func add_item(item_data: Dictionary):
	var first_available_slot_index = -1
	var added_to_stack = false
	
	# Add to stack if already exists 
	for item_slot_i in item_grid.get_child_count():
		var item_slot = item_grid.get_child(item_slot_i)
		if item_slot.get_item() == null && first_available_slot_index == -1:
			first_available_slot_index = item_slot_i
		elif item_slot.get_item_id() == item_data.id:
			item_slot.set_item(item_data)
			added_to_stack = true
	
	if added_to_stack == false:
		item_grid.get_child(first_available_slot_index).set_item(item_data)


func _input(event):
	if Input.is_action_just_pressed("open_inventory") && Client.ui_interaction_mode == Client.UIInteractionModes.GAMEPLAY:
		toggle_visible()


func toggle_visible():
	var show_inventory = !inventory_backdrop.visible
	inventory_backdrop.visible = show_inventory
	upper_inventory.visible = show_inventory
	if show_inventory:
		item_grid_vbox.alignment = VBoxContainer.ALIGN_CENTER
		for item_slot in item_grid.get_children():
			item_slot.set_visible(true)
	else:
		item_grid_vbox.alignment = VBoxContainer.ALIGN_END
		for item_slot_i in item_grid.get_child_count():
			var is_hot_bar_slot = item_slot_i >= item_grid.get_child_count() - INVENTORY_WIDTH
			item_grid.get_child(item_slot_i).set_visible(is_hot_bar_slot)
	
