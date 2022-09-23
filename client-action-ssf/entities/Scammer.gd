extends KinematicBody2D


onready var Sprite = $SpriteContainer/Sprite
onready var anim = $AnimationPlayer
onready var AI = $AI


var _id = "scammer_ai"
var _is_bot: bool = true
var cooldown: float 
var _prev_pos: Vector2
var _attack_dir: Vector2

var _disguise_nodes: Array = []
var _disguised: bool = false


func _ready():
	AI.set_physics_process(_is_bot)
	Server.connect("packet_received", self, "_on_packet_received")


func get_is_disguised() -> bool:
	return _disguised


func _on_packet_received(packet: Dictionary) -> void:
	if packet.type == Constants.PacketTypes.SHOOT_PROJECTILE:
		if packet.id == _id:
			anim.play("attack")
			undisguise()
	if packet.type == Constants.PacketTypes.ABILITY_USED:
		if packet.ability == Constants.AbilityEffects.DISGUISE:
			disguise(int(packet.randi))


func get_id() -> String:
	return _id


func get_is_bot() -> bool:
	return _is_bot


func _physics_process(delta):
	cooldown += delta
	
	if global_position.distance_squared_to(_prev_pos) > 0.5:
		_attack_dir = _prev_pos.direction_to(global_position)
	
	if Input.is_action_pressed("attack") && _id == Lobby.my_id:
		try_attack()
	
	_prev_pos = global_position


func disguise(rand_int: int) -> void:
	_disguised = true
	
	var players = Util.get_living_players()
	var rand_player = players[rand_int % players.size()]
	
	var username_node = rand_player.get_node("UsernameLabel").duplicate(true)
	add_child(username_node)
	_disguise_nodes.append(username_node)
	
	for child in get_node("SpriteContainer").get_children():
		child.set_visible(false)
	
	var sprite_container_node = rand_player.get_node("SpriteContainer")
	for child in sprite_container_node.get_children():
		if child.name == "Sprite":
			var duplicated_node = child.duplicate(true)
			duplicated_node.position.y = get_node("SpriteContainer").get_child(0).position.y + 6
			get_node("SpriteContainer").add_child(duplicated_node)
			_disguise_nodes.append(duplicated_node)


func undisguise() -> void:
	if _disguised == true:
		_disguised = false
		
		for node in _disguise_nodes:
			node.queue_free()
		
		for child in get_node("SpriteContainer").get_children():
			child.set_visible(true)


func try_attack() -> void:
	if cooldown > 1:
		var closest_enemy = AI.get_closest_player()
		if closest_enemy != null:
			Server.shoot_projectile(global_position + Vector2.UP * 10, global_position.direction_to(closest_enemy.global_position).normalized(), _id)
		else:
			Server.shoot_projectile(global_position + Vector2.UP * 10, _attack_dir.normalized(), _id)
		
		cooldown = 0


func set_scammer_data(id: String, pos: Vector2, className: String, has_ai: bool, scammer_i: int) -> void:
	var spawn_pos = pos + scammer_i * Vector2.RIGHT * 30
	position = spawn_pos
	_id = id
	_is_bot = has_ai
	
	get_node("SpriteContainer/Sprite").texture = Util.get_sprite_for_class(className)


func _on_Damage_body_entered(body):
	if body.get("is_player"):
		body.emit_signal("take_damage", 30, global_position.direction_to(body.global_position))

