extends Node


var _parent_entity
onready var slash = $Slash
onready var text_effect = $TextEffect
onready var text_effect_anim_player = $AnimationPlayer


func _ready():
	_parent_entity = get_parent()
	Events.connect("effect", self, "_on_effect")
	Events.connect("text_effect", self, "_on_text_effect")
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.attacked:
		var attacked = Util.get_entity(data.attackedId)
		if attacked != null:
			if data.success == false:
				Events.emit_signal("text_effect", data.attackedId, "Miss!", Color.gray)
			
			# Events.emit_signal("effect", data.attackerId, attacked.global_position)


func _on_text_effect(id: String, text: String, modulate: Color):
	if is_instance_valid(_parent_entity):
		if id == _parent_entity.get_id():
			text_effect.text = text
			text_effect.modulate = modulate
			text_effect_anim_player.play("textEffect")


func _on_effect(id: String, effect_target_pos: Vector2):
	if is_instance_valid(_parent_entity):
		if id == _parent_entity.get_id():
			slash.init(effect_target_pos)
			slash.position += Vector2.ONE * 8
