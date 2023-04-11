extends Node2D


var resource_sprite = preload("res://resources/ResourceSprite.gd").new()


onready var Trunk: AnimatedSprite = $Trunk
onready var Leaves: AnimatedSprite = $Leaves


func init(x: int, y: int, percent_drops_left: float, resource_type: int):
	var frame = resource_sprite.get_init_status(percent_drops_left)
	
	var rand_displacement = Vector2((randf() - 0.5) * 32, (randf() - 0.5) * 32)
	position = Vector2((x + 1) * 16 - 8, (y + 1) * 16 - 8) + rand_displacement
	
	var flip_h = randi() % 2 == 0
	Trunk.flip_h = flip_h
	Leaves.flip_h = flip_h
	
	Leaves.set_visible(frame == 0)
	
	Leaves.frame = randi() % (Leaves.frames.get_frame_count("default") + 1)
	Trunk.frame = frame
	
	Trunk.modulate = ResourceConstants.resource_info[int(resource_type)].default_modulate
	Leaves.modulate = ResourceConstants.resource_info[int(resource_type)].item_modulate[int(Constants.ItemType.LEAF)]


func update_resource_status(percent_drops_left: float):
	var frame = resource_sprite.get_resource_status(percent_drops_left, Trunk.frame)
	
	Trunk.frame = frame
	Leaves.set_visible(frame == 0)
