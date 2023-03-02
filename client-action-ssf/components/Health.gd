extends Node2D


onready var Bar: TextureProgress = $Bar


var health: float
var entity_id: String = ""
var _is_dead: bool


func _ready():
	get_parent().connect("take_damage", self, "_on_damage_taken")
	API.connect("packet_received", self, "_on_packet_received")


func init(spawn_entity_dto: Dictionary):
	if spawn_entity_dto.has("healthComponent"):
		entity_id = spawn_entity_dto.id
		Bar.max_value = spawn_entity_dto.healthComponent.maxHealth
		Bar.value = spawn_entity_dto.healthComponent.health
		
		set_visible(health == Bar.max_value)


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.setEntityHealth:
		if data.id == entity_id:
			health = data.health
			Bar.value = health
			get_parent().emit_signal("damage_taken", health)
			if health <= 0 && _is_dead == false:
				_is_dead = true
				get_parent().rotation_degrees = 90
				get_parent().collision_layer = 0
				
				set_visible(health == Bar.max_value)
				
				Events.emit_signal("player_dead", get_parent().get_id())
