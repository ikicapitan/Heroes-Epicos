extends KinematicBody2D

export (float) var vel_desp
export (float) var vel_rot
export (int) var PRECISION
var nav = Navigation2D
var path = []
var objetivo = Vector2()
var puede_disparar = true
export (float) var wait_w1
export (float) var wait_w2



# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_tree().get_nodes_in_group("nav")[0]

func _physics_process(delta):
	if(path.size() > 1):
		var angulo = get_angle_to(path[0])
		rotate(angulo * vel_rot * delta)
		var d = position.distance_to(path[0])
		if(!$AnimationPlayer.is_playing()):
			pass
			#$AnimationPlayer.play("walk")
		if(d > 2):
			position = position.linear_interpolate(path[0], (vel_desp * delta) / d)
		else:
			path.remove(0)
			
	else:
		$AnimationPlayer.play("idle")
		
			
func update_path():
	objetivo = gamehandler.puntero
	path = nav.get_simple_path(position, objetivo.position, false)
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if(gamehandler.estado_actual == gamehandler.estados.select && !gamehandler.select_wait):
		if(event is InputEventScreenTouch || (event is InputEventMouseButton && event.button_index == BUTTON_LEFT)):
			gamehandler.target = get_parent()
			var cam = get_tree().get_nodes_in_group("cam")[0]
			cam.get_parent().remove_child(cam) #Remuevo la camara como hijo
			get_node("Area2D").add_child(cam) 
			cam.position = position
			cam.position = position - cam.position
			var s_select
			
			if(get_tree().get_nodes_in_group("select").size() == 0):
			 	s_select = get_tree().get_nodes_in_group("main")[0].select.instance()
			else:
				s_select = get_tree().get_nodes_in_group("select")[0]
				s_select.get_parent().remove_child(s_select)
				
			
			add_child(s_select)
			s_select.global_position = global_position
			gamehandler.select_wait = true
			yield(get_tree().create_timer(1.0),"timeout")
			gamehandler.select_wait = false
			
			#Tutorial
			if(gamehandler.nivel == 1 && gamehandler.instancias == 4):
				gamehandler.instancias = 5
				get_tree().get_nodes_in_group("gui")[0].procesar_instancias()
			
func muerte():
	get_parent().morir()
	
func disparar():
	if(puede_disparar):
		puede_disparar = false
		look_at(get_global_mouse_position()) #Volteamos hacia el disparo
		match(gamehandler.estado_actual):
			gamehandler.estados.weapon1: #Arma Primaria
				$rango_w1.force_raycast_update() #Actualizo Angulo Raycast
				$cooldown.wait_time = wait_w1
				$cooldown.start()
				get_tree().get_nodes_in_group("main")[0].generar_sfx(1)
				if($rango_w1.is_colliding()):
					var col = $rango_w1.get_collider()
					var main = get_tree().get_nodes_in_group("main")[0]
					var nivel = get_tree().get_nodes_in_group("nivel")[0]
					if(col.is_in_group("npc")):
						var newshot = main.shotcol.instance()
						newshot.get_node("P2").global_position = $rango_w1.get_collision_point()
						nivel.add_child(newshot)
						if(rand_range(0,100) <= PRECISION):
							col.muerte()
					else:
						var newshot = main.shotcol.instance()
						newshot.get_node("P2").global_position = $rango_w1.get_collision_point()
						nivel.add_child(newshot)

			gamehandler.estados.weapon2: #Pistola
				$rango_w2.force_raycast_update()
				$cooldown.wait_time = wait_w2
				$cooldown.start()
				get_tree().get_nodes_in_group("main")[0].generar_sfx(2)
				if($rango_w1.is_colliding()):
					var col = $rango_w2.get_collider()
					var main = get_tree().get_nodes_in_group("main")[0]
					var nivel = get_tree().get_nodes_in_group("nivel")[0]
					if(col.is_in_group("npc")):
						var newshot = main.shotcol.instance()
						newshot.get_node("P2").global_position = $rango_w2.get_collision_point()
						nivel.add_child(newshot)
						if(rand_range(0,100) <= PRECISION):
							col.muerte()
					else:
						var newshot = main.shotcol.instance()
						newshot.get_node("P2").global_position = $rango_w2.get_collision_point()
						nivel.add_child(newshot)


func _on_cooldown_timeout():
	puede_disparar = true
	get_tree().get_nodes_in_group("main")[0].generar_sfx(5)
