extends YSort


var building_scene = load("res://buildings/Building.tscn")
var buildings_data = {}


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary) -> void:
	match event:
		WsEvents.spawnBuilding:
			if buildings_data.has(data.id):
				printerr("Already added this building! ", data)
				return
			
			buildings_data[data.id] = data
			
			create_building(data)
			
		WsEvents.despawnBuildings:
			for id in data.ids:
				buildings_data.erase(id)
				remove_building_w_id(id)
		
		WsEvents.updateBuildingState:
			var building = get_building(data.id)
			if building != null:
				building.set_state(data.state, data.madeOf)


func get_building(id: String):
	for building in get_children():
		if building.has_method("get_id"):
			if building.get_id() == id:
				return building


func remove_building_w_id(id: String) -> Vector2:
	for building in get_children():
		if building.has_method("get_id"):
			if building.get_id() == id:
				building.queue_free()
				return building.global_position
	
	return Vector2.ZERO


func create_building(building_data: Dictionary):
	var building = building_scene.instance()
	building.init(building_data)
	add_child(building)
