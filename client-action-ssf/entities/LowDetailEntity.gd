extends Sprite


var _id: String
var target_position: Vector2
var is_high_detail_entity = false


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func set_entity_data(spawn_entity_dto: Dictionary, spawn_pos: Vector2):
	_id = spawn_entity_dto.id
	
	texture = Constants.entity_info[int(spawn_entity_dto.type)].image
	
	if spawn_entity_dto.has("movementComponent"):
		global_position = spawn_pos
		target_position = spawn_pos


func get_id():
	return _id


func _on_packet_received(event: String, data: Dictionary) -> void:
	match(event):
		WsEvents.setEntityPos:
			if _id == data.id:
				target_position = Vector2(data.x, data.y)


func _process(delta):
		global_position = global_position.linear_interpolate(target_position, delta * 9)

