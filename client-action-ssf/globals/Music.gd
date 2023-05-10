extends AudioStreamPlayer


var songs = [load("res://assets/music/backstepper.mp3"), load("res://assets/music/gloobertssonata.mp3")]
var time_since_last_song = 0
var wait_time_until_next_song = randf() * 60 * 4 + 60 * 5


func _ready():
	randomize()


func _process(delta):
	time_since_last_song += delta
	
	if time_since_last_song >= wait_time_until_next_song:
		time_since_last_song = 0
		wait_time_until_next_song = randf() * 60 * 4 + 60 * 2
		var song = songs[randi() % songs.size()]
		stream = song
		play()
