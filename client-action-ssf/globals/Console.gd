extends CanvasLayer


var console_message_scene: PackedScene = preload("res://ui/ConsoleMessagePanel.tscn")
onready var ConsoleContainer = $ConsoleContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	Events.connect("console_message", self, "_on_console_message")


func _on_packet_received(event: String, data: Dictionary):
	match(event):
		WsEvents.serverMessage:
			if data.message is Array:
				data.message = PoolStringArray(data.message).join(", ")
			
			create_console_message(data.message, data.type)


func _on_console_message(msg: String, type: int):
	create_console_message(msg, type)


func create_console_message(message: String, type: int = Constants.ConsoleMessageTypes.ERROR) -> void:
		var msg_s = console_message_scene.instance()
		msg_s.set_text(message, type)
		ConsoleContainer.add_child(msg_s)
