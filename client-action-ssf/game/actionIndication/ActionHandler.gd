extends Node2D


var hovering_over_entities: Array = []
var currently_hovering_over: Node2D = null
var indicator_offset: Vector2 = Vector2.ZERO

onready var animation_player = $AnimationPlayer

onready var action_indicator = $Container/ActionIndicator
onready var attack_action_icon = $Container/AttackActionIndicatorIcon
onready var mine_action_icon = $Container/MineActionIndicatorIcon


func _ready():
	Events.connect("hovered_over_entity_or_resource", self, "_on_hovered_over_entity_or_resource")
	Events.connect("left_hover_over_entity_or_resource", self, "_on_left_hover_over_entity_or_resource")
	Events.connect("touched_entity_or_resource", self, "_one_touched_entity_or_resource")


func _on_hovered_over_entity_or_resource(entity_or_resource):
	if hovering_over_entities.find(entity_or_resource) == -1:
		hovering_over_entities.append(entity_or_resource)
		animation_player.play("appear")
	
	if hovering_over_entities.size() != 0:
		visible = true


func _on_left_hover_over_entity_or_resource(entity_or_resource):
	var index = hovering_over_entities.erase(entity_or_resource)
	entity_or_resource.modulate = Color.white
	
	if hovering_over_entities.size() == 0:
		currently_hovering_over = null
		visible = false


func _one_touched_entity_or_resource(entity_or_resource):
	action_with(entity_or_resource)


func _input(event):
	if Input.is_action_just_pressed("interact_action") && is_instance_valid(currently_hovering_over) == false:
		var my_player_pos = Client.get_my_player().global_position + Vector2.ONE * 8
		var velocity = get_global_mouse_position() - my_player_pos
		Events.emit_signal("effect", Client.get_my_account().id, velocity.normalized())


func action_with(entity_or_resource):
	if is_instance_valid(entity_or_resource):
		if entity_or_resource.has_method("get_id"):
			if Util.is_entity(entity_or_resource):
				API.request_attack(entity_or_resource.global_position, entity_or_resource.get_id())
			else:
				API.request_harvest(entity_or_resource.get_id())


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
		
		if Util.is_entity(closest_entity):
			indicator_offset = Vector2(8, -8)
			attack_action_icon.visible = true
			mine_action_icon.visible = false
		else:
			indicator_offset = Vector2(24, 18)
			mine_action_icon.visible = true
			attack_action_icon.visible = false
			
	
	if is_instance_valid(currently_hovering_over): 
		global_position = currently_hovering_over.global_position + indicator_offset
