tool
extends Control


enum UseAmounts {
	ONCE,
	THREE_TIMES,
	INFINITE
}


onready var name_label = $AbilityName


var input_action: String = "" 
var panel_input_action: String 

var used_ability: bool
var use_amount: int = UseAmounts.ONCE

var ability: int
var ability_info: Dictionary = {
	Constants.AbilityEffects.SYSTEM_UPDATE: {
		"texture": load("res://assets/sprites/buttonTextSystemUpdate.png"),
		"title": "System Update",
		"use_amount": UseAmounts.ONCE,
		"input_action": ""
	},
	Constants.AbilityEffects.INCOGNITO: {
		"texture": load("res://assets/sprites/buttonText2fa.png"),
		"title": "Incognito Mode",
		"use_amount": UseAmounts.ONCE,
		"input_action": ""
	},
	Constants.AbilityEffects.VPN: {
		"texture": load("res://assets/sprites/buttonTextVPN.png"),
		"title": "VPN",
		"use_amount": UseAmounts.ONCE,
		"input_action": ""
	},
	Constants.AbilityEffects.SLACK_ATTACK: {
		"texture": load("res://assets/sprites/attackButton.png"),
		"title": "Slash",
		"use_amount": UseAmounts.INFINITE,
		"input_action": "attack"
	},
	Constants.AbilityEffects.MINE: {
		"texture": load("res://assets/sprites/attackButton.png"),
		"title": "Virus Mine",
		"use_amount": UseAmounts.ONCE,
		"input_action": ""
	},
	Constants.AbilityEffects.DISGUISE: {
		"texture": load("res://assets/sprites/attackButton.png"),
		"title": "Disguise",
		"use_amount": UseAmounts.ONCE,
		"input_action": ""
	},
}


func init(ability_type: int, action: String):
	#$ButtonText.texture = ability_info[ability_type].texture
	#$ButtonTextPressed.texture = ability_info[ability_type].texture
	$AbilityName.text = ability_info[ability_type].title
	input_action = ability_info[ability_type].input_action
	use_amount = ability_info[ability_type].use_amount
	ability = ability_type
	panel_input_action = action
	
	if(use_amount == UseAmounts.ONCE):
		$AbilityName/AmountTip.text = "(one use)"
	elif(use_amount == UseAmounts.THREE_TIMES):
		$AbilityName/AmountTip.text = "(three uses)"
	elif(use_amount == UseAmounts.INFINITE):
		$AbilityName/AmountTip.text = "(infinite)"


func _ready():
	Server.connect("packet_received", self, "_on_packet_received")
	
	$ButtonPressed.set_visible(false)
	$ButtonTextPressed.set_visible(false)


func get_ability_user_pos() -> Vector2:
	return get_parent().get_parent().get_parent().global_position


func get_panel_input_action() -> String:
	return panel_input_action


func get_ability_used() -> bool:
	return used_ability


func get_ability() -> int:
	return ability


func try_use_ability(id: String) -> void:
	if used_ability == false:
		Server.use_ability(ability, id, get_ability_user_pos())
		
		if input_action != "":
			Input.action_press(input_action)


func stop_using_ability() -> void:
	if input_action != "":
		Input.action_release(input_action)


func _on_packet_received(packet: Dictionary) -> void:
	if(packet.type == Constants.PacketTypes.ABILITY_USED):
		if packet.ability == ability && packet.id == Lobby.my_id:
			if use_amount == UseAmounts.ONCE:
				_set_used()


func _set_used() -> void:
	$TouchScreenButton.set_visible(false)
	$Button.set_visible(false)
	$ButtonText.set_visible(false)
	$ButtonPressed.set_visible(true)
	$ButtonTextPressed.set_visible(true)
	modulate = Color(0.5,0.5,0.5,0.6)
	name_label.rect_position = Vector2.DOWN * 6
	used_ability = true


func _on_TouchScreenButton_pressed():
	try_use_ability(Lobby.my_id)


func _on_TouchScreenButton_released():
	name_label.rect_position = Vector2.ZERO
	stop_using_ability()
