extends Panel


onready var timer: Timer = $Timer
onready var timeLabel = $Time


var final_min_played: bool
var time_over: bool


func _process(delta):
	if Input.is_key_pressed(KEY_C) && Input.is_key_pressed(KEY_P):
		timer.start(1.0)
	
	var minute = timer.time_left / 60
	var second = (int(timer.time_left) % 60)
	timeLabel.text = "%02d:%02d" % [minute, second]
	
	Events.emit_signal("time_left", timer.time_left, timer.wait_time)
	
	if timer.time_left < 1.7 * 60 && final_min_played == false:
		final_min_played = true
		$AnimationPlayer.play("shake")
		timeLabel.modulate = Color.red
		Events.emit_signal("one_min_left")
	
	if timer.time_left == 0 && time_over == false:
		time_over = true
		Events.emit_signal("game_win", "time")
