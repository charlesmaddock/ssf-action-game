extends VBoxContainer


export(NodePath) var inventory_node_path  


onready var item_slots = $ItemSlots
onready var inventory_node = get_node(inventory_node_path)


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.openBuildingContainer:
		var items = data.items
		inventory_node.show_upper_inventory_node(self, true)
		for i in item_slots.get_child_count():
			var item_slot = item_slots.get_child(i)
			item_slot.set_visible(i < data.capacity)
			
			if i < items.size():
				item_slot.create_item(items[i])
			else:
				item_slot.free_item()
