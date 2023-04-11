extends Node2D
class_name SpriteContainer


onready var MovementAnimator = $MovementAnimator
onready var Water = $Water
onready var Item = $Item


var water_colliders = []
var in_water = false
var hand_sprite = preload("res://assets/sprites/hand.png")
var top_priority_animations = ["itemSlash", "attack"]


func init(spawn_entity_dto: Dictionary):
	get_node("Sprite").texture = Constants.entity_info[int(spawn_entity_dto.type)].image
	modulate = Constants.entity_info[int(spawn_entity_dto.type)].modulate


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
		Item.modulate = made_of_resource_info.default_modulate


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
