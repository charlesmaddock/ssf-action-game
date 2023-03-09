extends TextureButton
class_name ItemSlot


signal placed_item(item)
signal removed_item(item)


export(bool) var is_crafting_slot = false


onready var collision_shape = $Area2D/CollisionShape2D


var item_scene = load("res://item/Item.tscn")
var holding_item = null
var locked = false


func _ready():
	$CraftingSlotPlusSign.set_visible(is_crafting_slot)


func get_item():
	return holding_item


func get_extents() -> Vector2:
	return collision_shape.shape.extents


func get_item_id() -> String:
	if holding_item != null:
		return holding_item.id
	else:
		return ""


func set_item(inventory_item_data: Dictionary, is_preview = false):
	if holding_item == null:
		# Create new item
		var item = item_scene.instance()
		item.init(inventory_item_data, is_preview)
		place_item(item)
	else:
		# Increase stack of existing item
		holding_item.init(inventory_item_data)


func place_item(item: Item):
	emit_signal("placed_item", item)
	holding_item = item
	add_child(item)
	item.rect_position = Vector2(0,0)


func remove_item(item):
	if item == holding_item:
		emit_signal("removed_item", item)
		holding_item = null
		remove_child(item)


func free_item():
	if is_instance_valid(holding_item):
		emit_signal("removed_item", holding_item)
		holding_item.queue_free()
		holding_item = null


func lock():
	modulate = Color.gray
	locked = true


func unlock():
	modulate = Color.white
	locked = false


