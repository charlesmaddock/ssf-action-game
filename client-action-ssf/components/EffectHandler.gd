extends Node


var _parent_entity
var slash_scene = preload("res://effects/Slash.tscn")


func _ready():
	_parent_entity = get_parent()
	Events.connect("effect", self, "_on_effect")
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.attacked:
		var attacker = Util.get_entity(data.attackerId)
		var attacked = Util.get_entity(data.attackedId)
		if attacker != null && attacked != null:
			var dir: Vector2 = attacked.global_position - attacker.global_position 
			Events.emit_signal("effect", data.attackerId, dir)


func _on_effect(id: String, direction: Vector2):
	if is_instance_valid(_parent_entity):
		if id == _parent_entity.get_id():
			var slash = slash_scene.instance()
			_parent_entity.add_child(slash)
			slash.init(direction.normalized())
			slash.position += Vector2.ONE * 8
