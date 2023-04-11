extends Node2D


var resource_sprite = preload("res://resources/ResourceSprite.gd").new()


onready var Stone: AnimatedSprite = $Stone


func init(x: float, y: float, percent_drops_left: float, resource_type: int):
	var rand_displacement = Vector2((randf() - 0.5) * 32, (randf() - 0.5) * 32)
	position = Vector2((x + 1) * 16 - 8, (y + 1) * 16 - 8) + rand_displacement
	
	Stone.flip_h = randi() % 2 == 0
	Stone.modulate = ResourceConstants.resource_info[int(resource_type)].default_modulate
	
	var frame = resource_sprite.get_init_status(percent_drops_left)
	Stone.frame = frame


func update_resource_status(percent_drops_left: float):
	var frame = resource_sprite.get_resource_status(percent_drops_left, Stone.frame)
	Stone.frame = frame
