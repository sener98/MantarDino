extends CharacterBody2D

signal game_over
var ball = load("res://Scenes/Ball.tscn") #ball sahnesini yükle
var can_fire = true
var fire_direction = 1

var direction = 0

var is_jumping = false
var fall_has_played = false

var hit = false
var score = 0
var health = 100

var jump_count = 0
const MAX_JUMPS = 2

const SPEED = 400
const GRAVITY = 2000 #100
const JUMP = 800 #2000
const BULLET_SPEED = 2000

@onready var dino = get_node("Sprite2D")
@onready var walk = get_node("Walk_Sound")
@onready var jump = get_node("Jump_Sound")
@onready var fall = get_node("Fall_Sound")

func _ready():
	pass

func _process(delta):
	if global.game_over:
		return
	if hit == false:
		global.shake_amount = 0
	$Camera2D.set_offset(Vector2(
		randf_range(-1.0, 1.0) * global.shake_amount, 
		randf_range(-1.0, 1.0) * global.shake_amount
	))

	direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Yerdeyken zıplama hakkını sıfırla
	if is_on_floor():
		jump_count = 0
	
	# Zıplama kontrolü
	if Input.is_action_just_pressed("ui_select") and jump_count < MAX_JUMPS:
		is_jumping = true
		velocity.y = -JUMP
		jump_count += 1
		if jump.playing:
			jump.stop()
		jump.play()
	
	fire_check()
	
	velocity.x = direction * SPEED
	velocity.y += GRAVITY * delta
	
	if position.y > 5000:
		emit_signal("game_over")
	
	move_and_slide()
	update_animation()

func fire_check():
	#alt tuşuna basıldıysa ve ateş edebilir durumdaysak
	if Input.is_action_pressed("ui_hit") and can_fire:
		can_fire = false
		var ball_instance = ball.instantiate()
		ball_instance.name = "player_ball"
		ball_instance.set_collision_mask_value(4, true) #enemy mask = true
		ball_instance.position = $BallPoint.get_global_position()
		ball_instance.apply_impulse(Vector2(BULLET_SPEED * fire_direction, 0), Vector2())
		get_tree().get_root().add_child(ball_instance)
		$FireTimer.start()

func _on_FireTimer_timeout():
	can_fire = true

func update_animation():
	if damage_and_dead_animations():
		return
	if is_on_floor():
		is_jumping = false
		fall_has_played = false
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
		# Havadayken zıplama ve düşme animasyonları
		if velocity.y < 0:
			dino.play("Jump")
		else:
			if not fall.playing and not fall_has_played:
					fall.play()
					fall_has_played = true
			dino.play("Fall")
			
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
	if health <= 0 and is_on_floor():
		dino.play("Dead")
		if dino.frame == 7:
			emit_signal("game_over")
			return true
		else:
			return true
	return false
