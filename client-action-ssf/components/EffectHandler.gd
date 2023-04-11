extends Node


var _parent_entity
onready var hitEffect = $HitEffect
onready var text_effect = $TextEffect
onready var text_effect_anim_player = $AnimationPlayer


func _ready():
	_parent_entity = get_parent()
	Events.connect("text_effect", self, "_on_text_effect")
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.attacked:
		if data.attackedId == _parent_entity.get_id():
			if data.success == false:
				_on_text_effect(data.attackedId, "Miss!", Color.gray)
			else:
				hitEffect.position = Vector2(8, 8)
				var dir = Vector2(randf() - 0.5, randf() - 0.5).normalized()
				hitEffect.position -= dir * 8
				hitEffect.rotation = dir.angle() - PI / 2
				hitEffect.play("default")


func _on_text_effect(id: String, text: String, modulate: Color):
	if is_instance_valid(_parent_entity):
		if id == _parent_entity.get_id():
			text_effect.text = text
			text_effect.modulate = modulate
			text_effect_anim_player.play("textEffect")


func _on_HitEffect_animation_finished():
	hitEffect.stop()
	hitEffect.frame = 0
