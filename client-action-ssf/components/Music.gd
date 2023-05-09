extends Control


export(int) var octave = 4


onready var audio_stream_player_2D = $AudioStreamPlayer2D
onready var sliders = $VBox/Sliders
onready var ocatave_button = $VBox/Settings/OctaveButton
onready var play_button = $VBox/Settings/PlayButton


var time_signature = [
	3,4,6
]
var speeds = [
	{"name": "Adagio", "bpm": 76},
	{"name": "Moderato", "bpm": 76 * 1.5},
	{"name": "Allegro", "bpm": 76 * 2},
]
var stacatto = false

var beat_per_second = 0
var music_frequency_slider = preload("res://ui/music/MusicFrequencySlider.tscn")
var pitches = []
var pitch_index = 0
var time_since_last_tone = 0
var prev_pitch = -1 
var target_pitch = 0.01
var target_volume = -80
var past_half_tone = false
var playing = true
var playing_slider_tone = false


func _ready():
	for i in 8 * 2:
		pitches.append(0)
		var slider = music_frequency_slider.instance()
		slider.connect("frequency_changed", self, "_on_frequency_slider_changed")
		sliders.add_child(slider)
	
	_on_PlayButton_pressed()
	init_sliders()


func init_sliders():
	var i = 0
	for child in sliders.get_children():
		child.init(i, octave)
		i += 1


func _on_frequency_slider_changed(pitch: float, index: int):
	pitches[index] = pitch
	if pitch != -1:
		play_tone(pitch)


func _process(delta):
	time_since_last_tone += delta
	
	if stacatto && past_half_tone == false && time_since_last_tone * speeds[0].bpm > (60 / 2.5) :
		past_half_tone = true
		target_volume = -80
	
	if time_since_last_tone * speeds[0].bpm > 60 / 2:
		time_since_last_tone = 0
		past_half_tone = false
		
		for i in sliders.get_child_count():
			sliders.get_child(i).set_active(i == pitch_index && playing)
		
		var pitch = pitches[pitch_index]
		
		if pitch != prev_pitch || stacatto == true:
			target_volume = -80 if pitch == -1 else 1
		
		prev_pitch = pitch
		target_pitch = pitch 
		
		pitch_index += 1
		if pitch_index >= pitches.size():
			pitch_index = 0
	
	if playing_slider_tone == true:
		return
	
	var speed = 24 if stacatto else 12
	audio_stream_player_2D.volume_db = lerp(audio_stream_player_2D.volume_db, target_volume, delta * speed)
	if target_pitch > 0:
		audio_stream_player_2D.pitch_scale = lerp(audio_stream_player_2D.pitch_scale, target_pitch, delta * speed)
	
	if playing == false:
		target_volume = -80
		return


func play_tone(pitch: float):
	audio_stream_player_2D.volume_db = 1
	audio_stream_player_2D.pitch_scale = pitch
	playing_slider_tone = true
	yield(get_tree().create_timer(0.2), "timeout")
	playing_slider_tone = false


func _on_AudioStreamPlayer2D_finished():
	audio_stream_player_2D.play()


func _on_OctaveButton_pressed():
	octave += 1
	if octave > 5:
		octave = 3
	
	ocatave_button.text = "Octave " + str(octave)
	init_sliders()


func _on_StaccatoCheckBox_toggled(button_pressed):
	stacatto = button_pressed


func _on_PlayButton_pressed():
	playing = !playing
	play_button.text = "Play" if playing == false else "Stop"
