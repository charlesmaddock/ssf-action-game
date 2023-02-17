extends TileMap

enum TileType {
  VOID = -1,
  GRASS,
  SAND,
  GRAVEL,
  SNOW,
  WATER,
}

func get_tile_map_index_from_type(tile_type: int) -> Array:
	match(tile_type):
		TileType.GRASS:
			return [1,2,3]
		TileType.SAND:
			return [6]
		TileType.GRAVEL:
			return [5]
		TileType.SNOW:
			return [4]
		TileType.WATER:
			return [7]
	return [0]

func init(chunk_data: Dictionary, resource_scene: PackedScene, WorldYSort: YSort): 
	global_position = Vector2(chunk_data.globalPosX, chunk_data.globalPosY)
	
	var iterated_tile = Vector2(0,0)
	
	for compressed_tile_data in chunk_data.tiles:
		var tile_index_options = get_tile_map_index_from_type(compressed_tile_data.type)
		for i in compressed_tile_data.amount:
			var tile_index = tile_index_options[randi() % tile_index_options.size()] 
			set_cell(iterated_tile.x, iterated_tile.y, tile_index)
			
			iterated_tile.x += 1
			if(iterated_tile.x >= 32):
				iterated_tile.x = 0
				iterated_tile.y += 1
	
	for resource_data in chunk_data.resources:
		var resource = resource_scene.instance()
		WorldYSort.add_child(resource)
		resource.init(resource_data)
