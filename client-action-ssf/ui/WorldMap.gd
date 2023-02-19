extends Control


const WATER_COLOR = Color( 0.39, 0.58, 0.93, 0.5 )


onready var WorldMapSprite: TextureRect = $VBox/WorldMapSprite
onready var NorthLabel: Label = $VBox/WorldMapSprite/PosLabels/North
onready var EastLabel: Label = $VBox/WorldMapSprite/PosLabels/East
onready var ShowHeatCheckBox = $VBox/HBoxContainer/ShowHeatCheckBox
onready var ShowFertilityCheckBox = $VBox/HBoxContainer/ShowFertilityCheckBox
onready var ShowHeightCheckBox = $VBox/HBoxContainer/ShowHeightCheckBox
onready var ShowMoistureCheckBox = $VBox/HBoxContainer/ShowMoistureCheckBox


var _world_map: Dictionary = {}


func _ready():
	var get_world_map_http_req: CustomHTTPRequest = get_node("GetWorldMap")
	get_world_map_http_req.get_request("/world")


func _input(event):
	if _world_map.has("width"):
		var pos = WorldMapSprite.get_local_mouse_position()
		var x_ratio = WorldMapSprite.texture.get_width() / WorldMapSprite.rect_size.x
		var y_ratio = WorldMapSprite.texture.get_height() / WorldMapSprite.rect_size.y
		NorthLabel.text = "North: " + str(clamp(floor(pos.y * y_ratio), 0, _world_map.height))
		EastLabel.text = "East: " + str(clamp(floor(pos.x * x_ratio), 0, _world_map.width))


func _on_GetWorldMap_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code >= 200 && response_code < 300:
		_world_map = json.result
		draw_map_on_sprite(_world_map)


func draw_map_on_sprite(worldMap: Dictionary) -> void:
	var image: Image = Image.new()
	image.create(worldMap.width, worldMap.height, false, Image.FORMAT_RGBA8)
	image.lock()
	for val in worldMap.chunkData:
		var noise_map_data: Dictionary = val
		var noise_map_pos: Vector2 = Vector2(noise_map_data.x, noise_map_data.y)
		var heat_map: Array = noise_map_data.chunkNoiseMaps.heat
		var fertility_map: Array = noise_map_data.chunkNoiseMaps.fertility
		var height_map: Array = noise_map_data.chunkNoiseMaps.height
		var moisture_map: Array = noise_map_data.chunkNoiseMaps.moisture
		
		var noise_map_size = heat_map.size()
		for x in noise_map_size:
			for y in noise_map_size:
				var heat_value = heat_map[x][y]
				var heat_color: Color = Color(0.7 * heat_map[x][y], 0.3* heat_map[x][y], 1 * (0.5 - heat_map[x][y]), 0.01)
				
				var height_value = height_map[x][y]
				var height_color: Color = Color(0,0,0,0)
				if height_value == 0:
					height_color = WATER_COLOR
				
				var fertility_value = fertility_map[x][y]
				var fertility_color: Color = Color(0.7 - fertility_value, 0.8, 0, 0.1) 
				if height_value == 0:
					fertility_color = Color(0,0,0,0)
				
				var moisture_value = moisture_map[x][y]
				var moisture_color: Color = Color(0, 0, moisture_value, 0.2) 
				
				var combined_color: Color 
				if ShowHeatCheckBox.pressed:
					combined_color += heat_color
				if ShowFertilityCheckBox.pressed:
					combined_color += fertility_color
				if ShowHeightCheckBox.pressed:
					combined_color += height_color
				if ShowMoistureCheckBox.pressed:
					combined_color += moisture_color
				
				image.set_pixel(x + noise_map_pos.x, y + noise_map_pos.y, combined_color)
	
	image.unlock()
	var texture: ImageTexture = ImageTexture.new() 
	texture.create_from_image(image, 1)
	
	WorldMapSprite.texture = texture
	WorldMapSprite.stretch_mode = WorldMapSprite.STRETCH_KEEP_ASPECT
	WorldMapSprite.expand = true


func _on_ShowHeatCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_ShowFertilityCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_ShowHeightCheckBox_toggled(button_pressed):
	draw_map_on_sprite(_world_map)


func _on_ShowHeightCheckBox2_toggled(button_pressed):
	draw_map_on_sprite(_world_map)
