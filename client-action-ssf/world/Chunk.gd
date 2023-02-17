extends TileMap


func init(chunk_data: Dictionary, resource_scene: PackedScene, WorldYSort: YSort): 
	global_position = Vector2(chunk_data.globalPosX, chunk_data.globalPosY)
	for x in 20:
		for y in 20:
			set_cell(x, y, randi() % 3)
	
	for resource_data in chunk_data.resources:
		var resource = resource_scene.instance()
		WorldYSort.add_child(resource)
		resource.init(resource_data)
