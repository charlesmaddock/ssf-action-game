extends Control


onready var inventory_backdrop = $InventoryBackdrop
onready var item_grid: GridContainer = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/ItemsGrid"
onready var item_grid_vbox: VBoxContainer = $HBoxContainer/VBoxContainer
onready var upper_inventory = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/UpperInventory"
onready var upper_inventory_margin = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/Margin"
onready var crafting_container = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/UpperInventory/CraftingContainer"


const INVENTORY_WIDTH = 9
const INVENTORY_HEIGHT = 4


var item_slot_scene = load("res://ui/inventory/ItemSlot.tscn")


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	Events.connect("open_inv_button_pressed", self, "_on_inv_open_button_pressed")
	
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
	elif event == WsEvents.removeItemInv:
		remove_item(data.id, data.amount)


func _on_inv_open_button_pressed():
	toggle_visible()


func get_all_slots() -> Array:
	var slots = []
	slots.append_array(item_grid.get_children())
	for child in crafting_container.get_children():
		if child.get("is_crafting_slot") != null:
			slots.append(child)
	
	return slots


func add_item(item_data: Dictionary):
	var first_available_slot_index = -1
	var added_to_stack = false
	var item_slots = get_all_slots()
	# Add to stack if already exists
	for i in item_slots.size():
		var item_slot_i = item_slots.size() - i - 1
		var item_slot = item_slots[item_slot_i]
		if item_slot.get_item() == null && !item_slot.is_crafting_slot && first_available_slot_index == -1:
			first_available_slot_index = item_slot_i
		elif item_slot.get_item_id() == item_data.id:
			item_slot.set_item(item_data)
			added_to_stack = true
	
	if added_to_stack == false:
		item_slots[first_available_slot_index].set_item(item_data)


func remove_item(id: String, amount: int):
	var all_slots = get_all_slots()
	for item_slot_i in all_slots.size():
		var item_slot: ItemSlot = all_slots[item_slot_i]
		var item: Item = item_slot.get_item()
		
		if item != null:
			
			if item.id == id:
				if amount >= item.amount:
					item_slot.free_item()
				else:
					item.init({"id": id, "type": item.type, "amount": amount}, false)

func _input(event):
	if Input.is_action_just_pressed("open_inventory") && Client.ui_interaction_mode != Client.UIInteractionModes.CHAT:
		toggle_visible()


func toggle_visible():
	var show_inventory = !inventory_backdrop.visible
	
	var ui_interaction_mode = Client.UIInteractionModes.UI if show_inventory == true else Client.UIInteractionModes.GAMEPLAY
	Client.set_ui_interaction_mode(ui_interaction_mode)
	
	inventory_backdrop.visible = show_inventory
	upper_inventory.visible = show_inventory
	upper_inventory_margin. visible = show_inventory
	
	if show_inventory:
		item_grid_vbox.alignment = VBoxContainer.ALIGN_CENTER
		for item_slot in item_grid.get_children():
			item_slot.set_visible(true)
	else:
		item_grid_vbox.alignment = VBoxContainer.ALIGN_END
		for item_slot_i in item_grid.get_child_count():
			var is_hot_bar_slot = item_slot_i >= item_grid.get_child_count() - INVENTORY_WIDTH
			item_grid.get_child(item_slot_i).set_visible(is_hot_bar_slot)
	


func _on_CloseInventoryButton_pressed():
	toggle_visible()
