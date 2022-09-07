extends Node2D


onready var DoorAnimator = $AnimationPlayer


var door_open = true


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(packet: Dictionary) -> void:
	if(packet.type == Constants.PacketTypes.START_DOORS):
		if door_open == true:
			DoorAnimator.play("close")
		else:
			DoorAnimator.play("open")
		
		door_open = !door_open
