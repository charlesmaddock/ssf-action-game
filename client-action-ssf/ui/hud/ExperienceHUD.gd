extends Control


onready var experience_bar: TextureProgress = $ExperienceBar
onready var star_particles: CPUParticles2D = $StarParticles
onready var level_label = $Label


var prev_level = 1
var time_till_fade_away = 0
var time_since_packet = 0
var target_opacity = 0


func _ready():
	API.connect("packet_received", self, "_on_packet_received")
	


func _on_packet_received(event, data):
	if event == WsEvents.experiencePoints:
		time_till_fade_away = 5
		time_since_packet = 0
		target_opacity = 1
		
		level_label.text = "Level " + str(data.level)
		if data.level != prev_level:
			prev_level = data.level
			star_particles.emitting = true
		
		experience_bar.set_max(float(data.expUntilNext))
		experience_bar.set_value(float(data.exp))


func _process(delta: float):
	time_since_packet += delta
	if time_since_packet > time_till_fade_away && target_opacity != 0:
		target_opacity = 0
	
	modulate.a = lerp(modulate.a, target_opacity, delta * 4)
