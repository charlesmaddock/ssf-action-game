extends KinematicBody2D

var is_player = true

var _id: String = ""
var abilities_used = [false, false, false]
var _is_bot: bool
var using_invis_ability: bool = false


onready var Sprite = $SpriteContainer/Sprite


signal take_damage(damage, dir)
signal damage_taken(health, dir)


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")
	connect("damage_taken", self, "_on_damage_taken")
	Events.connect("player_dead", self, "_on_player_dead")
	
	if _is_bot == false:
		get_node("PlayerAI").set_physics_process(false)
	
	set_process(false)
	yield(Events, "cutscene_over")
	set_process(true)


func _on_damage_taken(damage, dir) -> void:
	if modulate == Color.white:
		modulate = Color(1000, 0, 0, 1)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = Color.white


func _on_player_dead(id) -> void:
	if id == _id:
		$CollisionShape2D.disabled = true


func get_id() -> String:
	return _id


func get_is_bot() -> bool:
	return _is_bot


func _on_packet_received(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.ROOM_LEFT:
			if _id == packet.id:
				queue_free()
		Constants.PacketTypes.ABILITY_USED:
			if _id == packet.id:
				var scene = null
				if packet.key == "1":
					scene = Constants.ability_effects[Constants.AbilityEffects.SYSTEM_UPDATE]
				elif packet.key == "2":
					scene = Constants.ability_effects[Constants.AbilityEffects.TWO_FACTOR_AUTH]
				elif packet.key == "3":
					scene = Constants.ability_effects[Constants.AbilityEffects.VPN]
				
				if scene != null:
					var ability_effect = scene.instance()
					ability_effect.rand_i = packet.randi
					ability_effect.global_position = global_position
					get_parent().add_child(ability_effect)


func set_players_data(id: String, name: String, pos: Vector2, className: String, is_bot: bool) -> void:
	position = pos + Vector2(rand_range(-2, 2), rand_range(-2, 2))
	_id = id
	
	_is_bot = is_bot
	$UsernameLabel.text = name
	
	get_node("SpriteContainer/Sprite").texture = Util.get_sprite_for_class(className)


func _input(event):
	if Lobby.my_id == _id:
		if Input.is_action_just_pressed("ability_1"):
			try_use_ability("1")
		elif Input.is_action_just_pressed("ability_2"):
			try_use_ability("2")
		elif Input.is_action_just_pressed("ability_3"):
			try_use_ability("3")


func try_use_ability(key = "") -> void:
	if key == "":
		var available_key_index = abilities_used.find(false)
		if available_key_index != -1:
			Server.use_ability(str(available_key_index + 1), _id)
	elif abilities_used[int(key) - 1] == false:
		Server.use_ability(key, _id)
	


func handle_ability_used(key, rand_i) -> void:
	if key == "1" && abilities_used[0] == false:
		if Lobby.is_host:
			abilities_used[0] = true
			var prev_speed = get_node("Movement").speed
			get_node("Movement").speed = 140
			$FastParticles.emitting = true
			yield(get_tree().create_timer(10), "timeout")
			$FastParticles.emitting = false
			get_node("Movement").speed = prev_speed
			
	elif key == "2" && abilities_used[1] == false:
		if Lobby.is_host:
			set_visible(false)
			yield(get_tree().create_timer(0.2), "timeout")
			abilities_used[1] = true
			var nav_points = Util.get_nav_points()
			var teleport_pos = nav_points[int(rand_i) % nav_points.size()].position
			
			var directionArrowPacked = load("res://game/TeleportArrow.tscn")
			var directionArrow: Sprite = directionArrowPacked.instance()
			directionArrow.position = global_position
			directionArrow.rotation = global_position.direction_to(teleport_pos).angle() +  PI / 2
			get_parent().add_child(directionArrow)
			
			position = teleport_pos + Vector2(rand_range(-16, 16), rand_range(-16, 16))

			yield(get_tree().create_timer(0.1), "timeout")
			set_visible(true)
			
	elif key == "3":
		abilities_used[2] = true
		if _id == Lobby.my_id:
			$AnimationPlayer.play("disappearMyClient")
		else:
			$AnimationPlayer.play("disappear")
		using_invis_ability = true
		yield(get_tree().create_timer(8), "timeout")
		if _id == Lobby.my_id:
			$AnimationPlayer.play("reappearMyClient")
		else:
			$AnimationPlayer.play("reappear")
		
		using_invis_ability = false
