extends Node2D


export(Color) var portalColour 
export(int) var id

onready var Portal1: Area2D = $Portal1
onready var Portal2: Area2D = $Portal2


var active: bool = true
var default_scale: Vector2


func _ready():
	Portal1.modulate = portalColour
	Portal2.modulate = portalColour
	default_scale = Portal1.scale
	
	Server.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(packet: Dictionary) -> void:
	if packet.type == Constants.PacketTypes.DISABLE_PORTALS:
		deactive()


func deactive():
	active = false
	Portal1.get_node("AnimationPlayer").stop()
	Portal2.get_node("AnimationPlayer").stop()
	Portal1.modulate = Color.white
	Portal2.modulate = Color.white
	Portal1.scale = default_scale / 2
	Portal2.scale = default_scale / 2
	
	yield(get_tree().create_timer(3), "timeout")
	Portal1.get_node("AnimationPlayer").play()
	Portal2.get_node("AnimationPlayer").play()
	Portal1.modulate = portalColour
	Portal2.modulate = portalColour
	Portal1.scale = default_scale
	Portal2.scale = default_scale

	active = true


func _on_Portal1_body_entered(body):
	if active:
		body.global_position = Portal2.global_position
		Server.disable_portals(id)
		
		if body.get_id() == Lobby.my_id:
			deactive()


func _on_Portal2_body_entered(body):
	if active:
		body.global_position = Portal1.global_position
		Server.disable_portals(id)
		
		if body.get_id() == Lobby.my_id:
			deactive()
