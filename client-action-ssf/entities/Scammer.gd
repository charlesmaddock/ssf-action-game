extends KinematicBody2D


onready var Sprite = $Sprite


var _id = "scammer_ai" + str(randi())
var _is_bot: bool


func get_id() -> String:
	return _id


func _ready() -> void:
	get_node("AI").set_physics_process(_is_bot)


func set_scammer_data(id: String, pos: Dictionary, className: String, has_ai: bool) -> void:
	var spawn_pos = Vector2(pos.x, pos.y)
	position = spawn_pos
	_id = id
	_is_bot = has_ai
	
	get_node("Sprite").texture = Util.get_sprite_for_class(className)


func _on_Damage_body_entered(body):
	if body.get("is_player"):
		body.emit_signal("take_damage", 30, global_position.direction_to(body.global_position))

