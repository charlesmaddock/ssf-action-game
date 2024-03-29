extends Node2D


onready var Bar: TextureProgress = $Bar


var health: int
var entity_id: String = ""
var _is_dead: bool


func _ready():
	get_parent().connect("take_damage", self, "_on_damage_taken")
	API.connect("packet_received", self, "_on_packet_received")


func init(spawn_entity_dto: Dictionary):
	if spawn_entity_dto.has("healthComponent"):
		entity_id = spawn_entity_dto.id
		health = spawn_entity_dto.healthComponent.health
		Bar.max_value = spawn_entity_dto.healthComponent.maxHealth
		Bar.value = health
		set_visible(int(health) != int(Bar.max_value))


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.setEntityHealth:
		if data.id == entity_id:
			var lost_health = int(data.health) < health
			
			if lost_health:
				Events.emit_signal("text_effect", entity_id, str(health - data.health), Color("#f57d7d"))
			
			health = int(data.health)
			Bar.value = int(health)
			set_visible(int(health) != int(Bar.max_value))
			
			if lost_health:
				get_parent().emit_signal("damage_taken", health, Vector2.ZERO)
			
			if Client.is_mine(entity_id):
				Events.emit_signal("my_health_changed", health)
			
			if health <= 0 && _is_dead == false:
				_is_dead = true
				get_parent().get_node("SpriteContainer").get_node("Sprite").rotation_degrees = 90
