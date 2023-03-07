extends Node2D
class_name SpriteContainer


onready var MovementAnimator = $MovementAnimator
onready var Water = $Water
var water_colliders = []
var in_water = false


func init(spawn_entity_dto: Dictionary):
	get_node("Sprite").texture = Constants.entity_info[int(spawn_entity_dto.type)].image


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	get_parent().connect("damage_taken", self, "_on_damage_taken")


func _on_damage_taken(damage, dir) -> void:
	if modulate == Color.white:
		modulate = Color(1000, 1000, 1000, 1)
		yield(get_tree().create_timer(0.3), "timeout")
		modulate = Color.white


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == "harvestedItem":
		if get_parent().get_id() == Client.get_my_account().id:
			MovementAnimator.play("itemSlash")


func check_if_in_water():
	in_water = water_colliders.size() > 0
	Water.visible = in_water


func play_idle():
	if MovementAnimator.current_animation != "idle" && MovementAnimator.current_animation != "itemSlash":
		MovementAnimator.play("idle")


func play_move_anim():
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
