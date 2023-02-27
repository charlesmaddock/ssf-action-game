extends TileMap

const CHUNK_SIZE_IN_TILES = 32
const TILE_SIZE = 32

enum TileType {
  VOID = -1,
  GRASS,
  SAND,
  GRAVEL,
  SNOW,
  WATER,
}


onready var BorderLine: Line2D = $Border


var chunk_id: int 
var chunk_resources: Array = []


func get_tile_map_index_from_type(tile_type: int) -> Array:
	match(tile_type):
		TileType.GRASS:
			return [0,1,2]
		TileType.SAND:
			return [3,4,5]
		TileType.GRAVEL:
			return [13,14,15]
		TileType.SNOW:
			return [6,8,9]
		TileType.WATER:
			return [10,11,12]
	return [7]


func init(chunk_data: Dictionary, resource_scene: PackedScene, WorldYSort: YSort): 
	modulate = Color.white
	global_position = Vector2(chunk_data.globalPosX, chunk_data.globalPosY)
	
	chunk_id = chunk_data.id
	var iterated_tile = Vector2(0,0)
	
	for compressed_tile_data in chunk_data.tiles:
		var tile_index_options = get_tile_map_index_from_type(compressed_tile_data.type)
		for i in compressed_tile_data.amount:
			var tile_index = tile_index_options[randi() % tile_index_options.size()] 
			set_cell(iterated_tile.y, iterated_tile.x, tile_index)
			
			iterated_tile.x += 1
			if(iterated_tile.x >= CHUNK_SIZE_IN_TILES):
				iterated_tile.x = 0
				iterated_tile.y += 1
	
	for resource_data in chunk_data.resources:
		var resource = resource_scene.instance()
		chunk_resources.append(resource)
		WorldYSort.add_child(resource)
		resource.init(resource_data)
	
	show_borders(Client.dev_tools_on)


func _input(event):
	if Input.is_key_pressed(KEY_F3):
		Client.dev_tools_on = !Client.dev_tools_on 
		show_borders(Client.dev_tools_on)


func show_borders(show: bool):
	BorderLine.visible = show


func deactive():
	for resource in chunk_resources:
		resource.queue_free()
	
	chunk_resources.clear()
