extends Control


onready var WorldMapSprite: TextureRect = $HBox/VBox/WorldMapSprite
onready var NorthLabel: Label = $HBox/VBox/WorldMapSprite/PosLabels/North
onready var EastLabel: Label = $HBox/VBox/WorldMapSprite/PosLabels/East
onready var EnterWorldButton: Button = $"HBox/VBox/EnterWorldButton"
onready var TargetSpawn: Sprite = $HBox/VBox/WorldMapSprite/TargetSpawn
onready var ShowHeatCheckBox = $HBox/VBox/HBoxContainer/ShowHeatCheckBox
onready var ShowFertilityCheckBox = $HBox/VBox/HBoxContainer/ShowFertilityCheckBox
onready var ShowHeightCheckBox = $HBox/VBox/HBoxContainer/ShowHeightCheckBox
onready var ShowMoistureCheckBox = $HBox/VBox/HBoxContainer/ShowMoistureCheckBox


var _world_map: Dictionary = {}

var spawn_pos_button_scene = preload("res://ui/world/SpawnPosButton.tscn")
var selected_spawn_point = Vector2(-1, -1)


func _ready():
	var get_world_map_http_req: CustomHTTPRequest = get_node("GetWorldMap")
	get_world_map_http_req.get_request("/world")


func _input(event):
	if _world_map.has("width"):
		var mouse_pos = WorldMapSprite.get_local_mouse_position()
		var chunk_coord = get_chunk_coord_from_mouse(mouse_pos)
		NorthLabel.text = "North: " + str(chunk_coord.y)
		EastLabel.text = "East: " + str(chunk_coord.x)


func _on_GetWorldMap_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code >= 200 && response_code < 300:
		_world_map = json.result
		
		$HBox/VBox/WorldLoadedInfo/PercentExplored.text = str(stepify(_world_map.chunksExplored / (_world_map.width * _world_map.height) * 100, 0.01)) + "% of the world is explored."
		$HBox/VBox/WorldLoadedInfo/PercentLoaded.text = str(stepify(_world_map.chunksLoaded / (_world_map.width * _world_map.height) * 100, 0.01)) + "% is loaded right now."
		
		draw_map_on_sprite(_world_map)


func get_chunk_coord_from_mouse(pos: Vector2):
	var x_ratio = WorldMapSprite.texture.get_width() / WorldMapSprite.rect_size.x
	var y_ratio = WorldMapSprite.texture.get_height() / WorldMapSprite.rect_size.y
	
	return Vector2(floor(clamp(pos.x * _world_map.lod * x_ratio, 0, _world_map.width)), floor(clamp(pos.y * _world_map.lod * y_ratio, 0, _world_map.height)))


func draw_map_on_sprite(world_map: Dictionary) -> void:
	var image: Image = Image.new()
	image.create(world_map.width / world_map.lod, world_map.height / world_map.lod, false, Image.FORMAT_RGBA8)
	image.lock()
	
	for val in world_map.chunkData:
		var noise_map_data: Dictionary = val
		var noise_map_pos: Vector2 = Vector2(noise_map_data.x / world_map.lod, noise_map_data.y / world_map.lod)
		var heat_map: Array = noise_map_data.chunkNoiseMaps.heat
		var fertility_map: Array = noise_map_data.chunkNoiseMaps.fertility
		var height_map: Array = noise_map_data.chunkNoiseMaps.height
		var moisture_map: Array = noise_map_data.chunkNoiseMaps.moisture
		var tile_map: Array = noise_map_data.chunkNoiseMaps.tile
		
		var noise_map_size = heat_map.size() / world_map.lod
		for x in noise_map_size:
			for y in noise_map_size:
				
				var tile_type = tile_map[x][y]
				var tile_color = Color.black
				match(int(tile_type)):
					Constants.TileType.GRASS, Constants.TileType.FLOWERS, Constants.TileType.FOREST, Constants.TileType.OASIS:
						tile_color = Color("#6db569")
					Constants.TileType.SAND, Constants.TileType.WASTELAND:
						tile_color = Color("#dfeda6")
					Constants.TileType.GRAVEL, Constants.TileType.CANYON, Constants.TileType.GLACIER:
						tile_color = Color("#c4c4c4")
					Constants.TileType.SNOW, Constants.TileType.BOREAL, Constants.TileType.TUNDRA:
						tile_color = Color.white
					Constants.TileType.SCORCHED_EARTH:
						tile_color = Color("#f5fcd9")
					Constants.TileType.TREACHERY:
						tile_color = Color("#ae9ded")
					Constants.TileType.WATER:
						tile_color = Color("#2f799e")
				
				tile_color.a = 1
				
				var heat_value = heat_map[x][y]
				var heat_color: Color = Color(0.7 * heat_map[x][y], 0.5* heat_map[x][y], 1 * (0.5 - heat_map[x][y]), 0.01)
				
				var height_value = height_map[x][y]
				var height_color: Color = Color(height_value/2, height_value/2, height_value/2, 1)
				
				var fertility_value = fertility_map[x][y]
				var fertility_color: Color = Color((0.7 - fertility_value) / 2, 0.4, 0, 1) 
				if height_value == 0:
					fertility_color = Color(0,0,0,0)
				
				var moisture_value = moisture_map[x][y]
				
				var combined_color: Color = tile_color
				if ShowHeatCheckBox.pressed:
					combined_color += heat_color
				if ShowFertilityCheckBox.pressed:
					combined_color = fertility_color
				if ShowHeightCheckBox.pressed:
					combined_color = height_color
				if ShowMoistureCheckBox.pressed && tile_type != Constants.TileType.WATER:
					combined_color.b = moisture_value * 10
					combined_color.r /= 2
					combined_color.g /= 2
				
				image.set_pixel(x + noise_map_pos.x, y + noise_map_pos.y, combined_color)
	
	image.unlock()
	var texture: ImageTexture = ImageTexture.new() 
	texture.create_from_image(image, 1)
	
	WorldMapSprite.texture = texture
	WorldMapSprite.stretch_mode = WorldMapSprite.STRETCH_SCALE
	WorldMapSprite.expand = true


func _on_ShowHeatCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_ShowFertilityCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_ShowHeightCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_ShowMoistureCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_EnterWorldButton_pressed():
	if selected_spawn_point.x != -1 && selected_spawn_point.y != -1:
		API.request_spawn_player(selected_spawn_point)
	else:
		API.request_spawn_player(Vector2(218, 164))


func _on_WorldMapSprite_gui_input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var chunk_coord = get_chunk_coord_from_mouse(event.position)
		selected_spawn_point = chunk_coord
		TargetSpawn.position = event.position
		TargetSpawn.set_visible(true)
		EnterWorldButton.text = "Enter World at North: " + str(chunk_coord.y) + ", East: " + str(chunk_coord.x)
	if event is InputEventScreenTouch:
		if event.is_pressed():
			var chunk_coord = get_chunk_coord_from_mouse(event.position)
			selected_spawn_point = chunk_coord
			TargetSpawn.position = event.position
			TargetSpawn.set_visible(true)
			EnterWorldButton.text = "Enter World at North: " + str(chunk_coord.y) + ", East: " + str(chunk_coord.x)

