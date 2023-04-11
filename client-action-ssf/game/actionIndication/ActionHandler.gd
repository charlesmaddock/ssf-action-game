extends Node2D


onready var animation_player = $AnimationPlayer

onready var action_indicator = $Container/ActionIndicator
onready var attack_action_icon = $Container/AttackActionIndicatorIcon
onready var mine_action_icon = $Container/MineActionIndicatorIcon
onready var cancel_action_icon = $Container/CancelActionIndicatorIcon


var hovering_over_entities: Array = []
var currently_hovering_over: Node2D = null
var indicator_offset: Vector2 = Vector2.ZERO
var action_in_progress: bool
var currently_selected_item_id: String = ""


func _ready():
	Events.connect("hovered_over_entity_or_resource", self, "_on_hovered_over_entity_or_resource")
	Events.connect("left_hover_over_entity_or_resource", self, "_on_left_hover_over_entity_or_resource")
	Events.connect("touched_entity_or_resource", self, "_one_touched_entity_or_resource")
	Events.connect("selected_item", self, "_on_selected_item")


func _on_hovered_over_entity_or_resource(entity_or_resource):
	if hovering_over_entities.find(entity_or_resource) == -1:
		hovering_over_entities.append(entity_or_resource)
		#animation_player.play("appear")
	
	if hovering_over_entities.size() != 0:
		visible = true


func _on_left_hover_over_entity_or_resource(entity_or_resource):
	var index = hovering_over_entities.erase(entity_or_resource)
	entity_or_resource.modulate = Color.white
	hide_inidicator()


func _one_touched_entity_or_resource(entity_or_resource):
	action_with(entity_or_resource)


func _on_selected_item(entity_id: String, item_id: String, item_type: int, item_made_of: Array):
	if item_id != currently_selected_item_id && Client.is_mine(entity_id):
		currently_selected_item_id = item_id
		API.select_item(item_id)


func hide_inidicator():
	if hovering_over_entities.size() == 0:
		currently_hovering_over = null
		visible = false


func set_icon_visible(icon_to_set_visible):
	attack_action_icon.visible = false
	mine_action_icon.visible = false
	cancel_action_icon.visible = false
	
	icon_to_set_visible.visible = true


func action_with(entity_or_resource):
	if is_instance_valid(entity_or_resource):
		if entity_or_resource.has_method("get_id") && currently_hovering_over == entity_or_resource:
			if Util.is_entity(entity_or_resource):
				API.request_attack(entity_or_resource.global_position, entity_or_resource.get_id())
			elif Util.is_building(entity_or_resource):
				API.request_harvest(entity_or_resource.get_id())
			else:
				API.building_interact(entity_or_resource.get_id(), entity_or_resource.global_position)


func _process(delta):
	var closest_entity = null
	var closest_dist = 999999
	var hover_pos = get_viewport().get_mouse_position()
	var invalid_at_i = -1
	for entity_i in hovering_over_entities.size():
		var entity = hovering_over_entities[entity_i]
		if is_instance_valid(entity):
			var entity_screen_pos = entity.get_global_transform_with_canvas().origin
			var dist = entity_screen_pos.distance_to(hover_pos)
			if dist < closest_dist:
				closest_entity = entity
				closest_dist = dist
		else:
			invalid_at_i = entity_i
	
	if invalid_at_i != -1:
		hovering_over_entities.remove(invalid_at_i)
		hide_inidicator()
	
	if closest_entity != null && closest_entity != currently_hovering_over:
		
		for interactable in hovering_over_entities:
			interactable.modulate = Color.white
		
		currently_hovering_over = closest_entity
		closest_entity.modulate = Color(1.5, 1.5, 1.5)
		
		if Util.is_entity(closest_entity):
			indicator_offset = Vector2(8, -8)
			set_icon_visible(attack_action_icon)
		else:
			indicator_offset = Vector2(24, 18)
			set_icon_visible(mine_action_icon)
	
	if is_instance_valid(currently_hovering_over): 
		global_position = currently_hovering_over.global_position + indicator_offset


