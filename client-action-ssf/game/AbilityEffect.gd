extends Node2D


export(Color) var ability_color
export(preload("res://globals/Constants.gd").AbilityEffects) var ability_key
export(Texture) var ability_texture


var rand_i: int = 0


func _ready():
	$Sprite.modulate = ability_color
	$AbilityParticles.texture = ability_texture
	global_position += Vector2.UP * 32


func _on_Area2D_body_entered(body):
	if body.get("is_player"):
		body.handle_ability_used(ability_key, rand_i)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
