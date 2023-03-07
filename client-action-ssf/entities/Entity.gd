extends Node2D


signal take_damage(damage, dir)
signal damage_taken(health, dir)


var is_high_detail_entity = true
var _id: String = ""


func _on_player_dead(id) -> void:
	if id == _id:
		$CollisionShape2D.disabled = true


func get_id() -> String:
	return _id


func set_entity_data(spawn_entity_dto: Dictionary, pos: Vector2) -> void:
	_id = spawn_entity_dto.id
	
	if spawn_entity_dto.has("client"):
		$UsernameLabel.text = spawn_entity_dto.client.username
	
	get_node("Movement").init(spawn_entity_dto, pos)
	get_node("Health").init(spawn_entity_dto)
	get_node("SpriteContainer").init(spawn_entity_dto)

