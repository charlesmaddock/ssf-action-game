extends Node2D


signal take_damage(damage, dir)
signal damage_taken(health, dir)


onready var harvested_item = $HarvestedItem


var is_high_detail_entity = true
var _id: String = ""


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	var action_indication_area = get_node("ActionIndicationArea")
	action_indication_area.init_indication_area(Vector2(24, 24), Vector2(12, 12)) 


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.harvestedItem:
		if data.harvestedFromId == _id:
			var harvester = Util.get_entity(data.harvesterId)
			if harvester != null:
				harvested_item.fly_to(global_position + Vector2(8, 8), harvester.global_position, data.type)


func get_id() -> String:
	return _id


func set_entity_data(spawn_entity_dto: Dictionary, pos: Vector2) -> void:
	_id = spawn_entity_dto.id
	
	if spawn_entity_dto.has("client"):
		$UsernameLabel.text = spawn_entity_dto.client.username
	
	get_node("Movement").init(spawn_entity_dto, pos)
	get_node("Health").init(spawn_entity_dto)
	get_node("SpriteContainer").init(spawn_entity_dto)

