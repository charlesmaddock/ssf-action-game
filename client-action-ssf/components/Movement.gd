extends Node2D


export(float) var speed: float = 80.0


onready var JoyStick = $CanvasLayer/CanvasModulate/Control/JoyStick
onready var entity_id = get_parent().get_id()
onready var spriteContainer = get_parent().get_node("SpriteContainer")


var sprite_scale_mult: float = 1
var target_position: Vector2 = Vector2.ZERO
var _send_pos_iteration = 0
var _velocity = Vector2.ZERO
var _force: Vector2 = Vector2.ZERO
var _prev_input: Vector2 = Vector2.ZERO
var _move_dir: Vector2


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")
	if get_parent().has_signal("damage_taken"):
		get_parent().connect("damage_taken", self, "_on_take_damage")
	
	yield(get_tree().create_timer(0.1), "timeout")
	set_physics_process(false)
	yield(Events, "cutscene_over")
	set_physics_process(true)


func _on_take_damage(health, dir) -> void:
	_force += dir 


func set_speed(speed: float) -> void:
	speed = speed 


func set_velocity(dir: Vector2) -> void:
	_velocity = dir


func _on_packet_received(packet: Dictionary) -> void:
	match(packet.type):
		Constants.PacketTypes.SET_INPUT:
			if entity_id == packet.id:
				_velocity = Vector2(packet.x, packet.y).normalized()
		Constants.PacketTypes.SET_PLAYER_POS:
			if entity_id == packet.id:
				# Don't move the host's player if we are the host
				if Lobby.is_host == true && entity_id == Lobby.my_id:
					return
				target_position = Vector2(packet.x, packet.y)


func get_input():
	var velocity = Vector2.ZERO
	var joy_stick_velocity = JoyStick.get_velocity()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	return velocity.normalized() + joy_stick_velocity


func _physics_process(delta):
	_send_pos_iteration += 1
	if get_parent().get_is_bot() == false:
		var input = get_input()
		if input != _prev_input:
			Server.send_input(input)
		_prev_input = input
	
	if Lobby.is_host == true:
		_move_dir = _velocity
		var vel = get_parent().move_and_slide(_velocity * speed + _force)
		var entity_id = get_parent().get_id()
		if _send_pos_iteration % 4 == 0:
			Server.send_pos(entity_id, global_position + (vel * delta))
	else:
		get_parent().global_position = get_parent().global_position.linear_interpolate(target_position, delta * 9)
		_move_dir = get_parent().global_position.direction_to(target_position)
		
		if get_parent().global_position.distance_squared_to(target_position) < 20:
			_move_dir = Vector2.ZERO
	
	if _move_dir != Vector2.ZERO:
		sprite_scale_mult = -1 if _move_dir.x < 0 else 1
	
	spriteContainer.scale = Vector2(sprite_scale_mult, 1)
	
	_force /= 1.1
