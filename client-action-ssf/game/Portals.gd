extends Node2D


export(Color) var portalColour 


onready var Portal1: Area2D = $Portal1
onready var Portal2: Area2D = $Portal2


var active: bool = true


func _ready():
	Portal1.modulate = portalColour
	Portal2.modulate = portalColour


func deactive():
	active = false
	Portal1.get_node("AnimationPlayer").stop()
	Portal2.get_node("AnimationPlayer").stop()
	Portal1.modulate = Color.white
	Portal2.modulate = Color.white
	
	yield(get_tree().create_timer(3), "timeout")
	Portal1.get_node("AnimationPlayer").play()
	Portal2.get_node("AnimationPlayer").play()
	Portal1.modulate = portalColour
	Portal2.modulate = portalColour

	active = true


func _on_Portal1_body_entered(body):
	if active:
		body.global_position = Portal2.global_position
		deactive()


func _on_Portal2_body_entered(body):
	if active:
		body.global_position = Portal1.global_position
		deactive()
