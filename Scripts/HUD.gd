extends CanvasLayer

signal start_game
signal resume_game
signal restart_game
signal exit_game
signal options_game
signal ok_options
signal music_game(value)
signal sound_game(value)

func _ready():
	$Menu3/MusicCheckBox.button_pressed = not global.music_mute
	$Menu3/SoundCheckBox.button_pressed = not global.sound_mute

func show_message(text):
	$Msg.text = text
	$Msg.show()
	$MsgTimer.start()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_health(health):
	$ProgressBar.value = health

func _on_MsgTimer_timeout():
	$Msg.hide()

func _on_StartButton_pressed():
	emit_signal("start_game")

func _on_ResumeButton_pressed():
	emit_signal("resume_game")

func _on_RestartButton_pressed():
	emit_signal("restart_game")

func _on_ExitButton_pressed():
	emit_signal("exit_game")

func _on_OptionsButton_pressed():
	emit_signal("options_game")

func _on_OkButton_pressed():
	emit_signal("ok_options")

func _on_MusicCheckBox_toggled(button_pressed):
	emit_signal("music_game", button_pressed)

func _on_SoundCheckBox_toggled(button_pressed):
	emit_signal("sound_game", button_pressed)
