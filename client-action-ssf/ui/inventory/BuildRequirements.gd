extends VBoxContainer


export(NodePath) var inventory_node_path  


onready var building_name = $BuildingName
onready var building_requirements = $HBoxContainer/BuildRequirements
onready var build_button = $HBoxContainer/BuildButtons/Button


var inventory_node = null
var interacting_w_building_id = ""


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	Events.connect("inventory_toggled", self, "_on_inventory_toggled")
	inventory_node = get_node(inventory_node_path)


func _on_inventory_toggled(visible: bool):
	interacting_w_building_id = ""
	send_items_back_to_inventory_slots()


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.openBuildingCost:
		var building_cost = data.cost
		inventory_node.show_upper_inventory_node(self, true)
		building_name.text = BuildingConstants.building_data[int(data.type)].name
		
		interacting_w_building_id = data.id
		
		for i in building_requirements.get_child_count():
			var slot = building_requirements.get_child(i)
			slot.set_visible(i < building_cost.size())
			if i < building_cost.size():
				slot.init(building_cost[i].itemType, building_cost[i].amount)
	
	if event == WsEvents.updateBuildingState:
		if data.id == interacting_w_building_id && data.state == BuildingConstants.BuildingState.COMPLETE:
			inventory_node.toggle_visible(false)


func send_items_back_to_inventory_slots():
	for child in building_requirements.get_children():
		var item = child.get_item()
		if item != null:
			inventory_node.move_item_to_first_available(item)


func _on_Button_button_down():
	var added_items = []
	var my_player = Client.get_my_player()
	
	for child in building_requirements.get_children():
		var item = child.get_item()
		if item != null:
			added_items.append({"itemId": item.id, "amount": item.amount})
	
	API.add_to_construction_site(interacting_w_building_id, my_player.global_position, added_items)
	
	send_items_back_to_inventory_slots()
