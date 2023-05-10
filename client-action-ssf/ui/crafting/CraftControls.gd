extends HBoxContainer


signal craft_items(amount)


onready var craft_one_button = $CraftOneButton
onready var preview_item = $PreviewItem
onready var make_amount_line_edit = $CraftManyButton/MakeAmountLineEdit


var max_result_amount: int = 0


func show_controls(serialized_item: Dictionary):
	max_result_amount = serialized_item.amount
	preview_item.init(serialized_item, true)
	make_amount_line_edit.visible = true
	make_amount_line_edit.text = str(max_result_amount)


func _on_CraftManyButton_pressed():
	var requested_amount = int(make_amount_line_edit.text)
	
	if requested_amount > max_result_amount:
		make_amount_line_edit.text = str(max_result_amount)
		Console.create_console_message("You can max make " + str(max_result_amount) + " items with these ingredients.", Constants.ConsoleMessageTypes.ERROR)
		return
	elif requested_amount < 1:
		make_amount_line_edit.text = str(1)
		Console.create_console_message("You must make at least one item.", Constants.ConsoleMessageTypes.ERROR)
		return
	
	emit_signal("craft_items", requested_amount)


func _on_CraftOneButton_pressed():
	emit_signal("craft_items", 1)
