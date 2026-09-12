extends RigidBody2D

var main
var screen_size

const SPEED = 400

func _ready():
	screen_size = get_viewport().size
	main = get_tree().get_current_scene()

func _process(delta):
	position.y += SPEED * delta
	if position.y > screen_size.y:
		queue_free()

func _on_meteor_body_entered(body):
	if body.name == "Player":
		queue_free()
		body.hit = true
		
		if not body.get_node("Meteor_Explosion/Explosion_Sound").playing:
			body.get_node("Meteor_Explosion/Explosion_Sound").play()
			
		body.get_node("AnimationPlayer").play("hit")
		body.get_node("Meteor_Explosion").emitting = true
		global.shake_amount = 15
		
		if body.health > 0:
			body.health -= 20
			main.get_node("HUD").update_health(body.health)
