extends KinematicBody2D

var is_player = true

var _id: String = ""
var abilities_used = [false, false, false]
var _is_bot: bool
var using_invis_ability: bool = false
var using_speed_ability: bool = false
var using_teleport_ability: bool = false

var makeInvisibleAreas: Array = []

onready var Sprite = $SpriteContainer/Sprite


signal take_damage(damage, dir)
signal damage_taken(health, dir)
signal try_use_ability(ability)


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")
	connect("damage_taken", self, "_on_damage_taken")
	Events.connect("player_dead", self, "_on_player_dead")
	Events.connect("one_min_left", self, "_on_one_min_left")
	
	if _is_bot == false:
		get_node("PlayerAI").set_physics_process(false)
	
	set_process(false)
	yield(Events, "cutscene_over")
	set_process(true)


func _on_one_min_left() -> void:
	$Ping.set_visible(true)


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


func is_hidding_in_invis_areas() -> bool:
	return makeInvisibleAreas.size() > 0


func _on_packet_received(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.ROOM_LEFT:
			if _id == packet.id:
				queue_free()


func set_players_data(id: String, name: String, pos: Vector2, className: String, is_bot: bool) -> void:
	position = pos + Vector2(rand_range(-2, 2), rand_range(-2, 2))
	_id = id
	
	_is_bot = is_bot
	$UsernameLabel.text = name
	
	get_node("SpriteContainer/Sprite").texture = Util.get_sprite_for_class(className)


func handle_ability_used(key: int, rand_i) -> void:
	if key == Constants.AbilityEffects.SYSTEM_UPDATE && using_speed_ability == false:
		using_speed_ability = true
		$FastParticles.emitting = true
		
		var prev_speed = get_node("Movement").speed
		get_node("Movement").speed = 140
		yield(get_tree().create_timer(10), "timeout")
		get_node("Movement").speed = prev_speed
		
		$FastParticles.emitting = false
		using_speed_ability = false
		
	elif key == Constants.AbilityEffects.VPN && using_teleport_ability == false:
			using_teleport_ability = true
			
			set_visible(false)
			yield(get_tree().create_timer(0.2), "timeout")
			var nav_points = Util.get_nav_points()
			var teleport_pos = nav_points[int(rand_i) % nav_points.size()].position
			
			var directionArrowPacked = load("res://game/TeleportArrow.tscn")
			var directionArrow: Node2D = directionArrowPacked.instance()
			directionArrow.global_position = global_position
			directionArrow.rotation = global_position.direction_to(teleport_pos).angle() +  PI / 2
			directionArrow.target_pos = teleport_pos
			get_parent().add_child(directionArrow)
			
			position = teleport_pos + Vector2(rand_range(-16, 16), rand_range(-16, 16))
			
			yield(get_tree().create_timer(0.1), "timeout")
			set_visible(true)
			
			yield(get_tree().create_timer(1), "timeout")
			using_teleport_ability = false
		
	elif key == Constants.AbilityEffects.INCOGNITO && using_invis_ability == false:
		disappear()
		yield(get_tree().create_timer(8), "timeout")
		appear()


func disappear() -> void:
	if is_hidding_in_invis_areas() == false:
		using_invis_ability = true
		if _id == Lobby.my_id:
			$AnimationPlayer.play("disappearMyClient")
		else:
			$AnimationPlayer.play("disappear")


func appear() -> void:
	if is_hidding_in_invis_areas() == false:
		using_invis_ability = false
		if _id == Lobby.my_id:
			$AnimationPlayer.play("reappearMyClient")
		else:
			$AnimationPlayer.play("reappear")


func _on_MakeInvisibilityDetector_area_entered(area):
	disappear()
	if makeInvisibleAreas.find(area) == -1:
		makeInvisibleAreas.append(area)


func _on_MakeInvisibilityDetector_area_exited(area):
	makeInvisibleAreas.erase(area)
	appear()
