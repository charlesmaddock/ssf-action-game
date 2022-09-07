extends AnimationPlayer





func _on_OpeningCutsceneAnim_animation_finished(anim_name):
	Events.emit_signal("cutscene_over")
