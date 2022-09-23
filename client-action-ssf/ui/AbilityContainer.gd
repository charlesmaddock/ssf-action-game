extends HBoxContainer


var ability_panel_scene = preload("res://ui/AbilityPanel.tscn")

func _ready():
	get_parent().get_parent().get_parent().connect("try_use_ability", self, "_on_try_use_ability")
	
	rect_scale = Vector2(1.5, 1.5) if Util.is_mobile() else Vector2.ONE
	
	var abilities: Array = []
	if Lobby.my_client_data.class == "Romance Scammer":
		abilities = [Constants.AbilityEffects.SLACK_ATTACK, Constants.AbilityEffects.MINE, Constants.AbilityEffects.DISGUISE]
	else:
		abilities = [Constants.AbilityEffects.SYSTEM_UPDATE, Constants.AbilityEffects.INCOGNITO, Constants.AbilityEffects.VPN]
	
	
	if get_entity_id() != Lobby.my_id:
		get_parent().queue_free()
	else:
		var key = 0
		for ability in abilities:
			key += 1
			var ability_button = ability_panel_scene.instance()
			ability_button.init(ability, "ability_" + str(key))
			add_child(ability_button)


func get_entity_id() -> String:
	 return get_parent().get_parent().get_id()


func _process(delta):
	if Lobby.my_id == get_entity_id():
		for child in get_children():
			if Input.is_action_pressed(child.get_panel_input_action()):
				_on_try_use_ability(child.get_ability())
			elif Input.is_action_just_released(child.get_panel_input_action()):
				child.stop_using_ability()


func _on_try_use_ability(ability: int) -> void:
	if ability == -1:
		var unused_ability_panels = []
		for child in get_children():
			if child.get_ability_used() == false:
				unused_ability_panels.append(child)
		
		unused_ability_panels.shuffle()
		
		if unused_ability_panels.size() > 0:
			unused_ability_panels[0].try_use_ability(get_entity_id())
	else:
		for child in get_children():
			if child.get_ability() == ability:
				child.try_use_ability(get_entity_id())
