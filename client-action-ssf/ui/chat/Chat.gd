extends Control


onready var chatInput: LineEdit = $LineEdit
onready var sendChatMsg: Button = $LineEdit/SendChatMsg
onready var chatContainer: VBoxContainer = $ScrollContainer/ChatContainer
onready var scrollbar = $ScrollContainer.get_v_scrollbar()
onready var scrollContainer = $ScrollContainer
onready var InGameMessages = $InGameMessages


var _focused: bool = true
var _sent_bad_connection: bool
var _messages_amount_sent_short_period: int
var _open: bool = false

var chat_message: PackedScene = preload("res://ui/chat/ChatMessage.tscn")
var profanity_filter = preload("res://ui/chat/ProfanityFilter.gd").new()


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	Events.connect("chat_button_pressed", self, "_on_chat_button_pressed")
	
	close_chat()
	
	scrollContainer.scroll_vertical = scrollbar.max_value


func _on_packet_received(event: String, data: Dictionary) -> void:
	if event == WsEvents.chatMessage:
		_on_display_chat(data.name, data.text)


func _on_chat_button_pressed():
	if _open == true:
		close_chat()
	else:
		open_chat()


func _input(event) -> void:
	if Input.is_action_just_pressed("ui_accept"): 
		send_chat_message()
	
	if Input.is_action_just_pressed("ui_cancel"): 
		close_chat()
	
	if Input.is_action_just_pressed("open_chat") && _open == false: 
		open_chat()
	
	if chatInput.text.length() >= 300:
		sendChatMsg.disabled = true
	else:
		sendChatMsg.disabled = false


func open_chat():
	_open = true
	yield(get_tree(), "idle_frame")
	
	Client.set_ui_interaction_mode(Client.UIInteractionModes.UI)
	scrollContainer.visible = true
	InGameMessages.visible = false
	_focused = true
	chatInput.grab_focus()
	chatInput.visible = true
	
	yield(get_tree(), "idle_frame")
	scrollContainer.scroll_vertical = scrollbar.max_value


func close_chat():
	_open = false
	
	Client.set_ui_interaction_mode(Client.UIInteractionModes.GAMEPLAY)
	InGameMessages.visible = true
	_focused = false
	chatInput.visible = false
	scrollContainer.visible = false


func clear_chat():
	for message in chatContainer.get_children():
		message.queue_free()


func send_chat_message() -> void:
	var message: String = chatInput.text
	var is_command = false
	
	if _messages_amount_sent_short_period > 3:
		Events.emit_signal("console_message", "You are sending messages too fast. Please slow down.", Constants.ConsoleMessageTypes.LOG)
	elif message.length() > 300:
		Events.emit_signal("console_message", "The message is too long.", Constants.ConsoleMessageTypes.LOG)
	elif message != "" && is_command == false:
		_messages_amount_sent_short_period += 1
		API.send_chat(message)
	
	chatInput.text = ""
	
	close_chat()


func _on_display_chat(sender: String, message: String) -> void:
	_display(message, sender)


func _display(message, sender = "") -> void:
	var censored_message = profanity_filter.filter(message)
	
	# Create the open chat message
	var chat_message_instance = chat_message.instance()
	chat_message_instance.create_chat_message(str(censored_message), sender, false)
	chatContainer.add_child(chat_message_instance)
	
	# Create the ingame chat message that disappears after a few secs
	var ingame_chat_message_inst = chat_message.instance()
	ingame_chat_message_inst.create_chat_message(str(censored_message), sender, true)
	InGameMessages.add_child(ingame_chat_message_inst)
	
	# Scroll to the latest message
	yield(get_tree(), "idle_frame")
	scrollContainer.scroll_vertical = scrollbar.max_value


func _on_input_focus_entered():
	_focused = true


func _on_SpamLimitTimer_timeout():
	if _messages_amount_sent_short_period > 0:
		_messages_amount_sent_short_period -= 1


func _on_SendChatMsg_pressed():
	send_chat_message()
