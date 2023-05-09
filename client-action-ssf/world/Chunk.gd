extends TileMap

const CHUNK_SIZE_IN_TILES = 32
const TILE_SIZE = 32


onready var BorderLine: Line2D = $Border


var chunk_id: int 
var chunk_resources: Array = []
var loaded: bool = false

var grass_tuft = preload("res://assets/sprites/grassTuft.png")
var small_stone = preload("res://assets/environment/smallStones.png")
var small_bush = preload("res://assets/sprites/smallBush.png")
var sprout = preload("res://assets/vegetation/sprout.png")


func get_tile_map_index_from_type(tile_type: int) -> Array:
	match(tile_type):
		Constants.TileType.GRASS:
			return [16,17,18]
		Constants.TileType.SAND:
			return [3,4,5]
		Constants.TileType.GRAVEL:
			return [13,14,15]
		Constants.TileType.SNOW:
			return [6,8,9]
		Constants.TileType.WATER:
			return [10,11,12]
		Constants.TileType.FOREST:
			return [16,17,18, 19, 20, 21, 31, 32, 33]
		Constants.TileType.GLACIER:
			return [6, 8, 9, 22, 23, 24]
		Constants.TileType.TUNDRA:
			return [6, 8, 9, 25, 26, 27]
		Constants.TileType.TREACHERY:
			return [28, 29, 30]
		Constants.TileType.FLOWERS:
			return [16,17,18, 31, 32, 33]
		Constants.TileType.WASTELAND:
			return [34, 35, 36]
		Constants.TileType.CANYON:
			return [3, 4 ,5, 37, 38, 39]
		Constants.TileType.OASIS:
			return [3, 4, 5, 40, 41, 42]
		Constants.TileType.SCORCHED_EARTH:
			return [3,4,5, 43, 44, 45]
		Constants.TileType.LAVA:
			return [46, 47, 48]
		
	return [7]


func get_decorative_env_from_type(tile_type: int) -> Array:
	match(tile_type):
		Constants.TileType.GRASS, Constants.TileType.FOREST, Constants.TileType.FLOWERS:
			return [grass_tuft, small_bush, sprout]
		Constants.TileType.GRAVEL:
			return [small_stone]
	return []


func init(chunk_data: Dictionary, resource_scene: PackedScene, WorldYSort: YSort): 
	modulate = Color.white
	global_position = Vector2(chunk_data.globalPosX, chunk_data.globalPosY)
	
	chunk_id = chunk_data.id
	var iterated_tile = Vector2(0,0)
	
	for compressed_tile_data in chunk_data.tiles:
		var tile_index_options = get_tile_map_index_from_type(compressed_tile_data.type)
		var decorative_env_options = get_decorative_env_from_type(compressed_tile_data.type)
		for i in compressed_tile_data.amount:
			var tile_index = tile_index_options[randi() % tile_index_options.size()] 
			set_cell(iterated_tile.y, iterated_tile.x, tile_index)
			
			if randf() > 1 && decorative_env_options.size() > 0:
				var decorative_env_texture = decorative_env_options[randi() % decorative_env_options.size()] 
				var sprite = Sprite.new()
				sprite.texture = decorative_env_texture
				WorldYSort.add_child(sprite)
				sprite.global_position = Vector2(global_position.x + (randf() - 0.5) * 6 + iterated_tile.y * Constants.TILE_DIM.y, global_position.y + (randf() - 0.5) * 6 + iterated_tile.x * Constants.TILE_DIM.x)
			
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
