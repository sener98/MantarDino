extends Node2D

#meteor sahnesini yükle
var meteor = load("res://Scenes/Meteor.tscn")

const WORLD_TOP = -1024 #platformun en üst noktası
const WORLD_LENGTH = 4096 #toplam platform genişliği

func _ready():
	global.game_over = false
	if get_tree().get_current_scene().name == "World":
		get_tree().paused = true #Ders11
	else:
		#World2,World3...
		$HUD/Menu1.hide()
		#sahnenin ismini ekrana yazdırıyoruz.
		$HUD.show_message(self.name)

func _process(_delta):
	#Ders11
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		$HUD/Menu2.show()
	if get_tree().paused == true: 
		$HUD/Menu1.hide()

func _on_meteorTimer_timeout():
	var meteor_instance = meteor.instantiate() #meteor sahnesini örnekledik.
	meteor_instance.position.y = WORLD_TOP
	meteor_instance.position.x = randi() % WORLD_LENGTH #platform üzerinde random x ekseninde bir yer.
	add_child(meteor_instance)#meteor sahnesini mevcut sahneye (world) çocuk nesne olarak ekledik.

func _on_HUD_start_game():
	$HUD/Menu1.hide()
	#sahnenin ismini ekrana yazdırıyoruz.
	global.game_over = false
	$HUD.show_message(self.name)
	get_tree().paused = false #Ders11
	randomize() #random değerleri oluşturur.
	$MeteorTimer.start() #yeni bir meteor için zaman ayarlıyoruz.(1sn)

func _on_HUD_options_game():
	$HUD/Menu3.show()

func _on_HUD_exit_game():
	get_tree().quit()

func _on_HUD_resume_game():
	$HUD/Menu2.hide()
	get_tree().paused = false

func _on_HUD_restart_game():
	$HUD/Menu2.hide()
	var _error = get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_HUD_music_game(value):
	global.music_mute = not value
	var idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(idx,global.music_mute)

func _on_HUD_sound_game(value):
	global.sound_mute = not value
	var idx = AudioServer.get_bus_index("FX")
	AudioServer.set_bus_mute(idx,global.sound_mute)

func _on_HUD_ok_options():
	$HUD/Menu3.hide()

func _on_Player_game_over():
	global.game_over = true
	$HUD.show_message("Game Over!")
	$GameOverTimer.start()

func _on_GameOverTimer_timeout():
	var _error = get_tree().reload_current_scene()
