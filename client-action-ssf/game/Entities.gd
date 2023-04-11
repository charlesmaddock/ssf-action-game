extends YSort


var projectile_scene = load("res://entities/Projectile.tscn")
var high_detail_entity_scene = load("res://entities/Entity.tscn")
var low_detail_entity_scene = load("res://entities/LowDetailEntity.tscn")

var entity_data = {}
var my_entity = null
var high_detail_render_distance = pow(Constants.TILE_DIM.x * 30, 2)
var LOD_check_iteration = 0
var LOD_segment_amount = 20


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
			var entity = create_entity(data, false, true, spawn_pos)
			
			if Client.is_mine(data.id):
				my_entity = entity
				set_process(true)
				Events.emit_signal("follow_w_camera", entity)
			
		WsEvents.despawnEntity:
			yield(get_tree().create_timer(1), "timeout")
			entity_data.erase(data.id)
			remove_entity_w_id(data.id)
			
			if Client.is_mine(data.id):
				my_entity = null
				set_process(false)
		WsEvents.attacked:
			if data.ranged == true:
				var attacker = get_entity(data.attackerId)
				var attacked = get_entity(data.attackedId)
				if attacker != null && attacked  != null:
					var projectile = projectile_scene.instance()
					add_child(projectile)
					projectile.fire(attacker, attacked, data.success)


func get_my_entity():
	return my_entity


func get_entity(id: String):
	for entity in get_children():
		if entity.has_method("get_id"):
			if entity.get_id() == id:
				return entity


func _process(delta):
	return
	
	LOD_check_iteration += 1
	var segement = LOD_check_iteration % LOD_segment_amount
	
	if get_child_count() > 100:
		high_detail_render_distance = pow(Constants.TILE_DIM.x * 30, 2)
		LOD_segment_amount = 10
		
	elif get_child_count() > 200:
		high_detail_render_distance = pow(Constants.TILE_DIM.x * 10, 2)
		LOD_segment_amount = 20
	else:
		high_detail_render_distance = pow(Constants.TILE_DIM.x * 1000, 2)
		LOD_segment_amount = 2
	
	var bottom_range = segement * (get_child_count() / LOD_segment_amount)
	var top_range = (segement + 1) * (get_child_count() / LOD_segment_amount)
	if segement == LOD_segment_amount:
		top_range = get_child_count()
	
	for entity_index in range(bottom_range, top_range):
		if is_instance_valid(get_child(entity_index)):  
			if get_child(entity_index).get_id() != my_entity.get_id():
				update_level_of_detail(get_child(entity_index))


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
