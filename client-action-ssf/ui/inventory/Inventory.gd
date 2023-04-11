extends Control


onready var inventory_backdrop = $InventoryBackdrop
onready var item_grid: GridContainer = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/ItemsGrid"
onready var item_grid_vbox: VBoxContainer = $HBoxContainer/VBoxContainer
onready var upper_inventory = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/UpperInventory"
onready var upper_inventory_margin = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/Margin"
onready var crafting_container = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/UpperInventory/CraftingContainer"
onready var build_requirements = $"HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/UpperInventory/BuildRequirements"
onready var close_button = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/CloseButton/CloseButton


const INVENTORY_WIDTH = 9
const INVENTORY_HEIGHT = 4


var item_slot_scene = load("res://ui/inventory/ItemSlot.tscn")


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	Events.connect("open_inv_button_pressed", self, "_on_inv_open_button_pressed")
	
	for child in item_grid.get_children():
		child.queue_free()
	
	item_grid.columns = INVENTORY_WIDTH
	
	var hotbat_i = 0
	for i in (INVENTORY_WIDTH * INVENTORY_HEIGHT):
		var item_slot = item_slot_scene.instance()
		item_grid.add_child(item_slot)
		
		if i >= (INVENTORY_WIDTH * INVENTORY_HEIGHT) - INVENTORY_WIDTH:
			item_slot.set_hotbar(hotbat_i)
			hotbat_i += 1
	
	yield(get_tree(), "idle_frame")
	toggle_visible()


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.inventoryContents:
		for serialized_item in data.items:
			add_item(serialized_item)
	elif event == WsEvents.addItemInv:
		add_item(data)
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


func get_first_available_slot_or_stackable_slot(item_id: String) -> Dictionary:
	var first_available_slot_index = -1
	var item_slots = item_grid.get_children()
	
	# Add to stack if already exists
	for y in range(INVENTORY_HEIGHT - 1, -1, -1):
		for x in range(INVENTORY_WIDTH):
			var i = ((y * INVENTORY_WIDTH) + x) 
			var item_slot = item_slots[i]
			if item_slot.get_item() == null && !item_slot.is_crafting_slot && !item_slot.is_building_slot && first_available_slot_index == -1:
				first_available_slot_index = i
			elif item_slot.get_item_id() == item_id:
				return {"slot": item_slot, "added_to_stack": true}
		
	if first_available_slot_index == -1:
		printerr("Could find a slot")
	
	return {"slot": item_slots[first_available_slot_index], "added_to_stack": false}


func move_item_to_first_available(item: Item):
		item.hide_item_desc()
		
		var prev_item_slot = item.get_current_item_slot()
		var res = get_first_available_slot_or_stackable_slot(item.id)
		
		if prev_item_slot != null:
			prev_item_slot.remove_item(item)
		
		res.slot.place_item(item)
	

func add_item(serialized_item: Dictionary):
	var res = get_first_available_slot_or_stackable_slot(serialized_item.id)
	res.slot.create_item(serialized_item)


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
					item.set_amount(amount)


func _input(event):
	if Input.is_action_just_pressed("open_inventory") && Client.ui_interaction_mode != Client.UIInteractionModes.CHAT:
		show_upper_inventory_node(crafting_container)


func toggle_visible(vis: bool = !inventory_backdrop.visible):
	var show_inventory = vis
	Events.emit_signal("inventory_toggled", show_inventory)
	
	var ui_interaction_mode = Client.UIInteractionModes.UI if show_inventory == true else Client.UIInteractionModes.GAMEPLAY
	Client.set_ui_interaction_mode(ui_interaction_mode)
	
	inventory_backdrop.visible = show_inventory
	
	# Only show hotbar
	upper_inventory.visible = show_inventory
	upper_inventory_margin.visible = show_inventory
	close_button.visible = show_inventory
	
	if show_inventory:
		item_grid_vbox.alignment = VBoxContainer.ALIGN_CENTER
		for item_slot in item_grid.get_children():
			item_slot.set_visible(true)
	else:
		item_grid_vbox.alignment = VBoxContainer.ALIGN_END if WindowScaler.is_small_screen() else VBoxContainer.ALIGN_BEGIN
		for item_slot_i in item_grid.get_child_count():
			var is_hot_bar_slot = item_slot_i >= item_grid.get_child_count() - INVENTORY_WIDTH 
			item_grid.get_child(item_slot_i).set_visible(is_hot_bar_slot)


func show_upper_inventory_node(upper_inventory_node: Node, vis: bool = !inventory_backdrop.visible):
	toggle_visible(vis)
	
	for child in upper_inventory.get_children():
		child.set_visible(false)
	
	upper_inventory_node.set_visible(true)


func _on_CloseButton_button_down():
	toggle_visible()
