extends Node2D


var is_high_detail_entity = true
var _id: String = ""


signal take_damage(damage, dir)
signal damage_taken(health, dir)


func _ready():
	connect("damage_taken", self, "_on_damage_taken")


func _on_damage_taken(damage, dir) -> void:
	if modulate == Color.white:
		modulate = Color(1000, 0, 0, 1)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = Color.white


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

