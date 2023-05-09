extends Node2D
class_name SpriteContainer


onready var MovementAnimator = $MovementAnimator
onready var Water = $Water
onready var Item = $Item
onready var Slash = $Item/Slash


var water_colliders = []
var in_water = false
var hand_sprite = preload("res://assets/sprites/hand.png")
var top_priority_animations = ["itemSlash", "attack"]
var item_target_rot = 0


func init(spawn_entity_dto: Dictionary):
	get_node("Sprite").texture = Constants.entity_info[int(spawn_entity_dto.type)].image
	modulate = Constants.entity_info[int(spawn_entity_dto.type)].modulate
	scale = Constants.entity_info[int(spawn_entity_dto.type)].scale * Vector2.ONE
	
	if spawn_entity_dto.has("itemHolderComponent"):
		if spawn_entity_dto.itemHolderComponent.has("item"):
			var holding_serialized_item = spawn_entity_dto.itemHolderComponent.item
			_on_selected_item(spawn_entity_dto.id, holding_serialized_item.id, holding_serialized_item.type, holding_serialized_item.madeOf)


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	get_parent().connect("damage_taken", self, "_on_damage_taken")
	Events.connect("selected_item", self, "_on_selected_item")


func _on_damage_taken(damage, dir) -> void:
	if modulate == Color.white:
		modulate = Color(1000, 1000, 1000, 1)
		yield(get_tree().create_timer(0.3), "timeout")
		modulate = Color.white


func _on_selected_item(entity_id: String, item_id: String, item_type: int, item_made_of: Array):
	if get_parent().get_id() != entity_id:
		 return
	
	Item.visible = item_id != ""
	
	if item_id != "":
		var made_of_resource_info = Util.get_highest_priority_made_of_resource(item_made_of)
		Item.texture = Constants.item_info[item_type].image
		Item.self_modulate = made_of_resource_info.default_modulate


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.isHarvesting:
		if get_parent().get_id() == data.id:
			if data.val == true:
				MovementAnimator.play("itemSlash")
				if Item.visible == false:
					Item.texture = hand_sprite
					Item.visible = true
			else:
				MovementAnimator.play("idle")
				if Item.texture == hand_sprite:
					Item.visible = false
	elif event == WsEvents.attacked:
		if data.attackerId == get_parent().get_id():
			MovementAnimator.play("attack")
	elif event == WsEvents.itemSelected:
		_on_selected_item(data.id, data.item.id, data.item.type, data.item.madeOf)


func _process(delta: float):
	Item.rotation = lerp(Item.rotation, item_target_rot, delta * 10) 


func swing_item(target_pos: Vector2):
	var centre_of_entity = (global_position + Constants.TILE_DIM / 2)
	var radians_to_target = centre_of_entity.angle_to_point(target_pos) + 1.5 * PI
	item_target_rot = radians_to_target + 0.5 * PI
	Item.rotation = radians_to_target - 0.5 * PI
	Slash.play()
	Slash.set_visible(true)


func check_if_in_water():
	in_water = water_colliders.size() > 0
	Water.visible = in_water


func play_idle():
	if MovementAnimator.current_animation != "idle" && !(MovementAnimator.current_animation in top_priority_animations):
		MovementAnimator.play("idle")


func play_move_anim():
	if !(MovementAnimator.current_animation in top_priority_animations):
		if in_water:
			if MovementAnimator.current_animation != "swim":
				MovementAnimator.play("swim")
		else:
			if MovementAnimator.current_animation != "jump":
				MovementAnimator.play("jump")


func _on_WorldDetector_body_entered(body):
	if water_colliders.find(body) == -1:
		water_colliders.append(body)
	check_if_in_water()


func _on_WorldDetector_body_exited(body):
	water_colliders.erase(body)
	check_if_in_water()


func _on_Slash_animation_finished():
	Slash.stop()
	Slash.set_visible(false)
