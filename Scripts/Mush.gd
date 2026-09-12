extends Area2D

var main

func _ready():
	main = get_tree().get_current_scene()
	pass

func _on_mush_body_entered(body):
	if body.name == "Player":
		body.score += 1
		main.get_node("HUD").update_score(body.score)
		$AnimationPlayer.play("hit")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
