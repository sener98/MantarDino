extends RigidBody2D

var main

func _ready():
	#ana sahneyi değişkene atadık
	main = get_tree().get_current_scene()

func _draw():
	#top çizimini yaptık
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.WHITE)


func _on_ball_body_entered(body):
	print(body.name)
	var is_enemy_ball = self.name.find("enemy_ball", 0) > -1
	var is_player_ball = self.name.find("player_ball", 0) > -1
	var is_enemy = body.name.find("Enemy", 0) > -1
	var is_player = body.name.find("Player", 0) > -1
	
	#print(enemy_ball)
	#top oyuncuya çarptığında yapılacaklar.
	if is_enemy_ball or is_player_ball:
		queue_free() #topu hafızadan sil
		
		#patlama sesi çalmıyorsa çal.
		var sound = body.get_node("Ball_Explosion/Explosion_Sound")
		if not sound.playing:
			sound.play()
			
		#oyuncu, için çarpma animasyonunu çalıştır. (kızarmak)
		body.get_node("AnimationPlayer").play("hit")
		
		#top patlama parçacık efektini çalıştır.
		body.get_node("Ball_Explosion").emitting = true
		
		if is_player:
			body.hit = true
			if body.health > 0: #sağlık 0 değilse 5 azalt.
				body.health -= 5
				#göstergeyi güncelle
				main.get_node("HUD").update_health(body.health) 
		
		if is_enemy:
			body.hit = true
			if body.health > 0: #sağlık 0 değilse 5 azalt.
				body.health -= 25
				#göstergeyi güncelle
				body.get_node("HUD_Enemy").update_health(body.health) 
				
				var enemies = get_tree().get_nodes_in_group("enemy")
				for e in enemies:
					if body.name == e.name:
						e.get_node("HUD_Enemy").show_health(true)
					else:
						e.get_node("HUD_Enemy").show_health(false)
