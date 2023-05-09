extends VBoxContainer


signal frequency_changed(freq, index)


onready var label = $Control/Label 
onready var slider = $MusicFrequencySlider 


var index: int
var notes = {
	"--": -1,
	"C": pow(1.059463094359, 3),
	"C#": pow(1.059463094359, 4),
	"D": pow(1.059463094359, 5),
	"D#": pow(1.059463094359, 6),
	"E": pow(1.059463094359, 7),
	"F": pow(1.059463094359, 8),
	"F#": pow(1.059463094359, 9),
	"G": pow(1.059463094359, 10),
	"G#": pow(1.059463094359, 11),
	"A": pow(1.059463094359, 12),
	"A#": pow(1.059463094359, 13),
	"B": pow(1.059463094359, 14),
	"C^": pow(1.059463094359, 15),
}
var advanced_notes = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
var simple_notes = [0,1,3,5,6,8,10,12,13]
var super_simple_notes = [0,1,6,9,12,13]

var selected_notes = simple_notes
var base_octave = 4


func init(i: int, octave: int):
	index = i
	base_octave = octave
	
	$MusicFrequencySlider.max_value = selected_notes.size() - 1
	_on_MusicFrequencySlider_value_changed(slider.value)


func _ready():
	_on_MusicFrequencySlider_value_changed(slider.value)


func set_active(val: bool):
	modulate = Color(3,3,3) if val == true else Color.white


func _on_MusicFrequencySlider_value_changed(value):
	var adjusted_index_for_no_tone = selected_notes[value]
	
	var name = notes.keys()[adjusted_index_for_no_tone]
	label.text = name 
	
	var pitch = notes.values()[adjusted_index_for_no_tone]
	if pitch == -1:
		emit_signal("frequency_changed", pitch, index)
		return
		
	var octave_adjust = pow(1.059463094359, 12 * float(base_octave - 4))
	print("octave_adjust: ", octave_adjust)
	pitch *= octave_adjust
	
	var octave = base_octave
	emit_signal("frequency_changed", pitch, index)


