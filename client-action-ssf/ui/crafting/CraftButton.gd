extends Button


onready var preview_item = $PreviewItem/Item 
onready var loading_anim_player = $AnimationPlayer

var loading = false

func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	
	clear_preview()


func _on_packet_received(event: String, data: Dictionary):
	if event == WsEvents.showCraftPreview:
		if data.type == -1:
			clear_preview()
		else:
			set_preview(data.type, data.amount)
	if event == WsEvents.addItemInv:
		if data.crafted == true:
			clear_preview()


func set_preview(item_type: int, amount: int):
	disabled = false
	text = "Make "
	preview_item.set_visible(true)
	var item_data = { "id": "preview " + str(randi()), "type": item_type, "amount": amount}
	preview_item.init(item_data, true)
	loading_anim_player.play("RESET")
	align = ALIGN_LEFT


func clear_preview():
	disabled = true
	text = "No results"
	preview_item.set_visible(false)
	loading_anim_player.play("RESET")
	align = ALIGN_CENTER


func _on_CraftButton_pressed():
	loading = true
	loading_anim_player.play("loading")
	align = ALIGN_CENTER
