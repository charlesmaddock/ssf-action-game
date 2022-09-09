extends Node2D


var bodies: Array


func _ready():
	set_visible(false)
	Events.connect("one_min_left", self, "_on_one_min_left")


func _on_one_min_left() -> void:
	set_visible(true)


func _on_PlayerDetector_body_entered(body):
	bodies.append(body)


func _on_PlayerDetector_body_exited(body):
	bodies.erase(body)


func _on_AnimationPlayer_animation_finished(anim_name):
	var closest_dist = 99999
	var closest_body = null
	for body in bodies:
		if body.get("is_player") != null:
			var dist = global_position.distance_to(body.global_position) 
			if dist < closest_dist:
				closest_dist = dist
				closest_body = body
	
	if closest_body != null: 
		rotation = global_position.direction_to(closest_body.global_position).angle() + PI / 2
	
	$AnimationPlayer.play("ping")
