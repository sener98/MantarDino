extends CharacterBody2D

var ball = load("res://Scenes/Ball.tscn") #ball sahnesini yükle
var can_fire = true
var fire_direction = 1

var direction = -1
var platform_end = false

var hit = false
var health = 100

const SPEED = 400
const GRAVITY = 100
const PLATFORM_LEFT = -(896 - 32)
const PLATFORM_RIGHT = 3584 - 32
const ATTACK_DISTANCE = 500
const BALL_SPEED = 1000

@onready var dino = get_node("Sprite2D")
@onready var walk = get_node("Walk_Sound")
@onready var jump = get_node("Jump_Sound")
@onready var fall = get_node("Fall_Sound")

func _ready():
	pass

func _process(_delta):
	if position.x < PLATFORM_LEFT:
		platform_end = true
		
	if position.x > PLATFORM_RIGHT:
		platform_end = true
		
	if platform_end:
		platform_end = false
		direction *= -1
	
	raycast_check()
	
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	update_animation()

func raycast_check():
	#ışın demeti için mesafe ve yön belirle.
	$RayCast2D.target_position.x = ATTACK_DISTANCE * direction
	
	#ışın demeti çarpıştıysa ve ateş edebilir durumdaysak
	if $RayCast2D.is_colliding() and can_fire:
		can_fire = false
		var ball_instance = ball.instantiate()
		ball_instance.name = "enemy_ball"
		ball_instance.set_collision_mask_value(4, false) #enemy mask = false
		ball_instance.position = $BallPoint.get_global_position()
		ball_instance.apply_impulse(Vector2(BALL_SPEED * fire_direction, 0), Vector2())
		get_tree().get_root().add_child(ball_instance)
		$FireTimer.start()

func _on_FireTimer_timeout():
	can_fire = true

func update_animation():
	if damage_and_dead_animations():
		return
	if is_on_floor():
		if direction == 1:
			dino.flip_h = false
			if not walk.playing:
				walk.play()
			dino.play("Walk")
		elif direction == -1:
			dino.flip_h = true
			if not walk.playing:
				walk.play()
			dino.play("Walk")
		else:
			dino.play("Idle")
	else:
		if direction == 1:
			dino.flip_h = false
		elif direction == -1:
			dino.flip_h = true
		
	set_sprite_offset()

#sprite dikdörtgen(kare değilse) ise buna ihtiyaç oluyor. 
func set_sprite_offset():
	if dino.flip_h == true and dino.offset.x > 0:
		dino.offset *= -1
		fire_direction = -1
		$BallPoint.position.x = -50
	
	if dino.flip_h == false and dino.offset.x < 0:
		dino.offset *= -1
		fire_direction = 1
		$BallPoint.position.x = 50
		
func damage_and_dead_animations()-> bool:
	#damage animasyon
	if hit == true:
		dino.play("Dead")
		if dino.frame == 0:
			return true
		else:
			hit = false
	#dead animasyon
	if health == 0:
		if is_on_floor():
			dino.play("Dead")
			if dino.frame == 7:
				self.queue_free()
				return true
			else:
				return true
	return false


func _on_VisibilityNotifier2D_screen_entered():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if self.name == e.name:
			e.get_node("HUD_Enemy").show_health(true)
		else:
			e.get_node("HUD_Enemy").show_health(false)


func _on_VisibilityNotifier2D_screen_exited():
	$HUD_Enemy.show_health(false)
