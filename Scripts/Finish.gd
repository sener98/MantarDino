extends Area2D

var main
var error
var is_finish

func _ready():
	main = get_tree().get_current_scene()
	pass

func _on_mush_body_entered(body):
	if body.name == "Player":
		if body.score == 5:
			is_finish = true
			$AnimationPlayer.play("hit")
		else:
			$AnimationPlayer.play("red")

func _on_AnimationPlayer_animation_finished(_anim_name):
	if is_finish:
		queue_free()
		if main.name == "World":
			error = get_tree().change_scene_to_file("res://Scenes/World2.tscn")
		else:
			error = get_tree().change_scene_to_file("res://Scenes/World.tscn")
