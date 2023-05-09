extends Node2D


var resource_sprite = preload("res://resources/ResourceSprite.gd").new()


onready var TallGrass: AnimatedSprite = $TallGrass
onready var TallGrassVariations: AnimatedSprite = $Variations


func init(x: float, y: float, percent_drops_left: float, resource_type: int):
	var rand_displacement = Vector2((randf() - 0.5) * 16, (randf() - 0.5) * 16)
	position = Vector2((x + 1) * 16 - 8, (y + 1) * 16 - 8) + rand_displacement
	
	TallGrass.flip_h = randi() % 2 == 0
	TallGrass.modulate = ResourceConstants.resource_info[int(resource_type)].default_modulate
	
	TallGrassVariations.modulate = ResourceConstants.resource_info[int(resource_type)].default_modulate
	TallGrassVariations.frame = randi() % 4
	TallGrassVariations.visible = TallGrass.frame == 0
	
	var frame = resource_sprite.get_init_status(percent_drops_left)
	TallGrass.frame = frame


func update_resource_status(percent_drops_left: float):
	var frame = resource_sprite.get_resource_status(percent_drops_left, TallGrass.frame)
	TallGrass.frame = frame
	
	TallGrassVariations.visible = TallGrass.frame == 0
