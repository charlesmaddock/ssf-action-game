extends Node2D


var _id = str(randi())


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(packet: Dictionary) -> void:
	if packet.type == Constants.PacketTypes.MINE_EXPLODE:
		if packet.id == _id:
			explode()


func explode() -> void:
	$ExplosionParticles.emitting = true
	$Sprite.set_visible(false)
	$Damage.set_active(true)
	yield(get_tree().create_timer(2), "timeout")
	queue_free()


func _on_Mine_body_entered(body):
	if body.get("is_player") && Lobby.is_host:
		Server.mine_explode(_id)
