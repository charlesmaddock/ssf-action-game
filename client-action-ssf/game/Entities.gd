extends YSort




var high_detail_entity_scene = preload("res://entities/Player.tscn")
var low_detail_entity_scene = preload("res://entities/LowDetailEntity.tscn")
var entity_data = {}
var my_entity = null
var high_detail_render_distance = pow(Constants.TILE_DIM.x * 30, 2)


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary) -> void:
	match event:
		WsEvents.spawnEntity:
			if entity_data.has(data.id):
				printerr("Already added this entity! ", data)
				return
			
			entity_data[data.id] = data
			
			var spawn_pos = Vector2(data.movementComponent.x, data.movementComponent.y)
			var entity = create_entity(data, false, Client.is_mine(data.id), spawn_pos)
			
			if Client.is_mine(data.id):
				my_entity = entity
				set_process(true)
				Events.emit_signal("follow_w_camera", entity)
			
		WsEvents.despawnEntity:
			entity_data.erase(data.id)
			remove_entity_w_id(data.id)
			
			if Client.is_mine(data.id):
				my_entity = null
				set_process(false)


func get_my_entity():
	return my_entity


func get_entity(id: String):
	for entity in get_children():
		if entity.has_method("get_id"):
			if entity.get_id() == id:
				return entity


func _process(delta):
	if get_child_count() > 100:
		high_detail_render_distance = pow(Constants.TILE_DIM.x * 30, 2)
	else:
		high_detail_render_distance = pow(Constants.TILE_DIM.x * 100, 2)
	
	for entity in get_children():
		if entity.get_id() != my_entity.get_id():
			update_level_of_detail(entity)


func update_level_of_detail(entity):
	
	if entity.global_position.distance_squared_to(my_entity.global_position) < high_detail_render_distance:
		if entity.is_high_detail_entity == false && entity_data.has(entity.get_id()):
			var data = entity_data[entity.get_id()]
			var pos = remove_entity_w_id(entity.get_id())
			create_entity(data, true, true, pos)
	else:
		if entity.is_high_detail_entity == true && entity_data.has(entity.get_id()):
			var data = entity_data[entity.get_id()]
			var pos = remove_entity_w_id(entity.get_id())
			create_entity(data, true, false, pos)


func create_entity(data: Dictionary, update_LOD: bool, high_detail: bool, pos: Vector2):
	var entity_scene 
	if Client.is_mine(data.id) || high_detail == true:
		entity_scene = high_detail_entity_scene
	else:
		entity_scene = low_detail_entity_scene
	
	var entity = entity_scene.instance()
	add_child(entity)
	entity.set_entity_data(data, pos)
	
	return entity


func remove_entity_w_id(id: String) -> Vector2:
	for entity in get_children():
		if entity.has_method("get_id"):
			if entity.get_id() == id:
				entity.queue_free()
				return entity.global_position
	
	return Vector2.ZERO
