extends YSort


var mine_scene = preload("res://entities/Mine.tscn")


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(packet: Dictionary) -> void:
	if packet.type == Constants.PacketTypes.SHOOT_PROJECTILE:
		var spawn_pos = Vector2(packet.posX, packet.posY)
		var dir = Vector2(packet.dirX, packet.dirY)
		var projectile_scene = preload("res://entities/Projectile.tscn")
		var projectile = projectile_scene.instance()
		add_child(projectile)
		projectile.fire(spawn_pos, dir)
	if packet.type == Constants.PacketTypes.ABILITY_USED:
		var ability: int = int(packet.ability)
		
		if ability == Constants.AbilityEffects.MINE:
			var mine = mine_scene.instance()
			mine.global_position = Vector2(float(packet.x), float(packet.y)) 
			add_child(mine)
		
		if Constants.ability_effects.has(ability):
			var scene = Constants.ability_effects[ability]
			if scene != null:
				var ability_effect = scene.instance()
				ability_effect.rand_i = int(packet.randi)
				ability_effect.global_position = Vector2(float(packet.x), float(packet.y))
				add_child(ability_effect)

