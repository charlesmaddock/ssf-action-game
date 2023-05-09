extends PanelContainer


export(Curve) var show_anim_curve 


onready var building_HUD = $MarginContainer/BuildingHUD
onready var music_HUD = $MarginContainer/Music
onready var margin_container = $MarginContainer


var current_hud = null
var target_x = 0


func _ready():
	Events.connect("music_button_pressed", self, "_on_music_button_pressed")
	Events.connect("build_button_pressed", self, "_on_build_button_pressed")


func _on_build_button_pressed():
	show_HUD(building_HUD)


func _on_music_button_pressed():
	show_HUD(music_HUD)


func _process(delta):
	rect_position.x = lerp(rect_position.x, target_x, delta * 10)


func _input(event):
	if Input.is_action_just_pressed("open_building_HUD") && Client.ui_interaction_mode != Client.UIInteractionModes.CHAT:
		show_HUD(building_HUD)


func show_HUD(hud):
	if current_hud == hud:
		current_hud = null
		target_x = 0
		for child in margin_container.get_children():
			child.set_visible(false)
	else:
		print("haa")
		current_hud = hud
		target_x = -300
		for child in margin_container.get_children():
			child.set_visible(child == hud)
