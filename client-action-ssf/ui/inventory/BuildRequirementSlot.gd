extends VBoxContainer


onready var item_slot = $ItemSlot 


func init(item_type: int, amount: int):
	var serialized_item = {
		"id": "",
		"type": item_type,
		"amount": amount,
		"madeOf": [],
		"desc": []
	}
	$Item.init(serialized_item, true)


func get_item():
	return item_slot.get_item()
