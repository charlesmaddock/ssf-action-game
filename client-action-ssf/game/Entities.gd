extends Node2D


export(NodePath) var worldYSortPath
onready var WorldYSort = get_node(worldYSortPath)


func _ready():
	API.connect("packet_received", self, "_on_packet_received")


func _on_packet_received(event: String, data: Dictionary) -> void:
	match event:
		WsEvents.spawnEntity:
			var player_scene = preload("res://entities/Player.tscn")
			var player = player_scene.instance()
			add_entity(player)
			player.set_players_data(data)
			
			if data.id == Client.get_my_account().id:
				Events.emit_signal("follow_w_camera", player)
			
		WsEvents.despawnEntity:
			remove_entity_w_id(data.id)
		
		WsEvents.shootProjectile:
			var spawn_pos = Vector2(data.x, data.y)
			var dir = Vector2(data.dirX, data.dirY)
			var projectile_scene = preload("res://entities/Projectile.tscn")
			var projectile = projectile_scene.instance()
			add_entity(projectile)
			projectile.fire(spawn_pos, dir)


func add_entity(entity: Node) -> void:
	WorldYSort.add_child(entity)


func remove_entity_w_id(id: String) -> void:
	for entity in WorldYSort.get_children():
		if entity.has_method("get_id"):
			if entity.get_id() == id:
				entity.queue_free()
