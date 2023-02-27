extends Node2D


var hovering_over_entities: Array = []
var currently_hovering_over: Node2D = null
var indicator_offset: Vector2 = Vector2.ZERO

onready var animation_player = $AnimationPlayer

onready var action_indicator = $Container/ActionIndicator
onready var attack_action_icon = $Container/AttackActionIndicatorIcon
onready var mine_action_icon = $Container/MineActionIndicatorIcon


func _ready():
	Events.connect("hovered_over_entity", self, "_on_hovered_over_entity")
	Events.connect("left_hover_over_entity", self, "_on_left_hover_over_entity")


func _on_hovered_over_entity(entity):
	if hovering_over_entities.find(entity) == -1:
		hovering_over_entities.append(entity)
		animation_player.play("appear")
	
	if hovering_over_entities.size() != 0:
		visible = true


func _on_left_hover_over_entity(entity):
	var index = hovering_over_entities.erase(entity)
	entity.modulate = Color.white
	
	if hovering_over_entities.size() == 0:
		currently_hovering_over = null
		visible = false


func _input(event):
	if is_instance_valid(currently_hovering_over):
		if Input.is_action_just_pressed("interact_action") && currently_hovering_over.has_method("get_id"):
			API.request_harvest(currently_hovering_over.get_id())


func _process(delta):
	var closest_entity = null
	var closest_dist = 999999
	var hover_pos = get_viewport().get_mouse_position()
	for entity in hovering_over_entities:
		if is_instance_valid(entity):
			var entity_screen_pos = entity.get_global_transform_with_canvas().origin
			var dist = entity_screen_pos.distance_to(hover_pos)
			if dist < closest_dist:
				closest_entity = entity
				closest_dist = dist
	
	
	if closest_entity != null && closest_entity != currently_hovering_over:
		currently_hovering_over = closest_entity
		closest_entity.modulate = Color(1.2, 1.2, 1.2)
		
		if closest_entity.get("is_high_detail_entity") != null:
			indicator_offset = Vector2(8, -8)
			attack_action_icon.visible = true
			mine_action_icon.visible = false
		else:
			indicator_offset = Vector2(24, 18)
			mine_action_icon.visible = true
			attack_action_icon.visible = false
			
	
	if is_instance_valid(currently_hovering_over): 
		global_position = currently_hovering_over.global_position + indicator_offset
