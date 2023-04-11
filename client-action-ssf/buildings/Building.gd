extends Sprite


var _id
var _type
var _made_of = []


func init(building_data: Dictionary):
	_id = building_data.id
	_type = building_data.type
	_made_of = building_data.madeOf
	
	global_position =  Vector2(building_data.x, building_data.y)
	
	texture = BuildingConstants.building_data[int(building_data.type)].texture
	
	var extents = Util.get_extents_from_texture(texture)
	$ActionIndicationArea.init_indication_area(extents, extents)
	
	offset = Constants.TILE_DIM - extents * 2 
	
	set_state(building_data.state, _made_of)


func get_id() -> String:
	return _id


func set_state(state: int, made_of_array: Array):
	var extents = Util.get_extents_from_texture(texture)
	if state == BuildingConstants.BuildingState.UNDER_CONSTRUCTION:
		self_modulate.a = 0
		var construction_site_tile_map = $ConstructionSite
		construction_site_tile_map.set_visible(true)
		for x in floor(extents.x / Constants.TILE_DIM.x) + 1:
			for y in floor(extents.y / Constants.TILE_DIM.y) + 1:
				construction_site_tile_map.set_cell(x, y, 0)
		
		construction_site_tile_map.update_bitmask_region()
	elif state == BuildingConstants.BuildingState.COMPLETE:
		var made_of_resource_info = Util.get_highest_priority_made_of_resource(made_of_array)
		modulate = made_of_resource_info.default_modulate
		self_modulate.a = 1
		$ConstructionSite.set_visible(false)


func _on_Area2D_mouse_entered():
	modulate = Color(2, 2, 2)


func _on_Area2D_mouse_exited():
	modulate = Color(1, 1, 1)
