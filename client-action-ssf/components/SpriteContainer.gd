extends Node2D
class_name SpriteContainer


onready var MovementAnimator = $MovementAnimator
onready var Water = $Water
var water_colliders = []
var in_water = false


func check_if_in_water():
	in_water = water_colliders.size() > 0
	Water.visible = in_water


func play_idle():
	if MovementAnimator.current_animation != "idle":
		MovementAnimator.play("idle")


func play_move_anim():
	if in_water:
		if MovementAnimator.current_animation != "swim":
			MovementAnimator.play("swim")
	else:
		if MovementAnimator.current_animation != "jump":
			MovementAnimator.play("jump")


func _on_WorldDetector_body_entered(body):
	if water_colliders.find(body) == -1:
		water_colliders.append(body)
	check_if_in_water()


func _on_WorldDetector_body_exited(body):
	water_colliders.erase(body)
	check_if_in_water()
