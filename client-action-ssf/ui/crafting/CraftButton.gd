extends Button


signal craft_items(amount)


onready var preview_item = $PreviewItem/Item 
onready var loading_anim_player = $AnimationPlayer
onready var make_amount_line_edit = $PreviewItem/MakeAmountLineEdit

var loading = false
var max_result_amount: int = 0

func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	
	clear_preview(false)


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.showCraftPreview:
		if data.type == -404:
			clear_preview(true, false)
		elif data.type == -426:
			clear_preview(true, true)
		else:
			set_preview(data.type, data.amount)
	if event == WsEvents.addItemInv:
		if data.crafted == true:
			clear_preview(false)


func set_preview(item_type: int, amount: int):
	disabled = false
	text = "Make "
	max_result_amount = amount
	preview_item.set_visible(true)
	var item_data = { "id": "preview " + str(randi()), "type": item_type, "amount": amount}
	preview_item.init(item_data, true)
	loading_anim_player.play("RESET")
	make_amount_line_edit.visible = true
	make_amount_line_edit.text = str(amount)
	align = ALIGN_LEFT


func clear_preview(no_result: bool, need_more: bool = false):
	disabled = true
	text = "" 
	if need_more:
		text = "Need more"
	elif no_result:
		text = "No results"
	
	preview_item.set_visible(false)
	loading_anim_player.play("RESET")
	make_amount_line_edit.visible = false
	align = ALIGN_CENTER


func _on_CraftButton_pressed():
	var requested_amount = int(make_amount_line_edit.text)
	
	if requested_amount > max_result_amount:
		make_amount_line_edit.text = str(max_result_amount)
		Console.create_console_message("You can max make " + str(max_result_amount) + " items with these ingredients.", Constants.ConsoleMessageTypes.ERROR)
		return
	elif requested_amount < 1:
		make_amount_line_edit.text = str(1)
		Console.create_console_message("You must make at least one item.", Constants.ConsoleMessageTypes.ERROR)
		return
	
	loading = true
	loading_anim_player.play("loading")
	make_amount_line_edit.visible = false
	align = ALIGN_CENTER
	
	emit_signal("craft_items", requested_amount)
