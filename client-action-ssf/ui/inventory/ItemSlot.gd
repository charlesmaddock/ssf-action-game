extends TextureButton
class_name ItemSlot


signal placed_item(item)
signal removed_item(item)


export(bool) var is_crafting_slot = false
export(bool) var is_building_slot = false


onready var collision_shape = $Area2D/CollisionShape2D
onready var selected = $Selected


var item_scene = load("res://item/Item.tscn")
var holding_item = null
var locked = false


var hotbar_index = -1 


func _ready():
	$CraftingSlotPlusSign.set_visible(is_crafting_slot)
	Events.connect("hotbar_slot_pressed", self, "_on_hotbar_slot_pressed")


func _input(event):
	for key in range(KEY_1, KEY_9 + 1):
		if Input.is_key_pressed(key):
			set_selected(key - KEY_1  == hotbar_index)


func _on_hotbar_slot_pressed(index: int):
	set_selected(index  == hotbar_index)


func get_is_available():
	return is_visible_in_tree() && locked == false


func get_item():
	return holding_item


func get_extents() -> Vector2:
	return collision_shape.shape.extents


func get_is_selected() -> bool:
	return selected.visible 


func get_item_id() -> String:
	if holding_item != null:
		return holding_item.id
	else:
		return ""


func set_selected(val: bool):
	selected.visible = val
	
	if val == true:
		if holding_item != null:
			Events.emit_signal("selected_item", Client.get_my_account().id, holding_item.get_id(), holding_item.get_type(), holding_item.get_made_of())
		else:
			Events.emit_signal("selected_item", Client.get_my_account().id, "", 0, [])


func set_hotbar(index: int):
	hotbar_index = index
	$HotBarNumber.set_visible(true)
	$HotBarNumber.text = str(index + 1)
	
	if index == 0:
		set_selected(true)


func create_item(inventory_serialized_item: Dictionary, is_preview = false):
	if holding_item == null:
		# Create new item
		var item = item_scene.instance()
		item.init(inventory_serialized_item, is_preview)
		place_item(item)
	else:
		# Increase stack of existing item
		holding_item.init(inventory_serialized_item)
	
	if get_is_selected() == true:
		yield(get_tree(), "idle_frame")
		set_selected(true)


func place_item(item: Item):
	emit_signal("placed_item", item)
	holding_item = item
	add_child(item)
	item.rect_position = Vector2(0,0)
	item.set_current_item_slot(self)


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


func _on_ItemSlot_button_down():
	if hotbar_index != -1:
		Events.emit_signal("hotbar_slot_pressed", hotbar_index)
