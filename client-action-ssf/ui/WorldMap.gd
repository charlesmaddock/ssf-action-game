extends Control


onready var sprite: Sprite = $WorldMapSprite


func _ready():
	var get_world_map_http_req: CustomHTTPRequest = get_node("GetWorldMap")
	get_world_map_http_req.get_request("/world")


func _on_GetWorldMap_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code >= 200 && response_code < 300:
		draw_map_on_sprite(json.result)


func draw_map_on_sprite(worldMap: Array) -> void:
	var image: Image = Image.new()
	image.create(1000, 1000, false, Image.FORMAT_RGBA8)
	image.lock()
	for val in worldMap:
		var noise_map_data: Dictionary = val
		var noise_map_pos: Vector2 = Vector2(noise_map_data.x, noise_map_data.y)
		var heat_map: Array = noise_map_data.chunkNoiseMaps.heat
		for x in heat_map.size():
			for y in heat_map.size():
				var heat_color: Color = Color(1,0,0,0.1)
				var fertility_color: Color = Color(0,1,0,0.1) 
				image.set_pixel(x + noise_map_pos.x, y + noise_map_pos.y, heat_color + fertility_color)
	
	image.unlock()
	var texture: ImageTexture = ImageTexture.new() 
	texture.create_from_image(image)
	sprite.texture = texture
	print("texture: ", texture.get_size())
