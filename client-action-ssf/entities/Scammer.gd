extends KinematicBody2D


onready var Sprite = $SpriteContainer/Sprite
onready var anim = $AnimationPlayer
onready var AI = $AI


var _id = "scammer_ai"
var _is_bot: bool = true
var cooldown: float 
var _prev_pos: Vector2
var _attack_dir: Vector2


func _ready():
	AI.set_physics_process(_is_bot)


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


func try_attack() -> void:
	if cooldown > 1:
		var closest_enemy = AI.get_closest_player()
		if closest_enemy != null:
			Server.shoot_projectile(global_position + Vector2.UP * 10, global_position.direction_to(closest_enemy.global_position).normalized())
		else:
			Server.shoot_projectile(global_position + Vector2.UP * 10, _attack_dir.normalized())
		
		anim.play("attack")
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

