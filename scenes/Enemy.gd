extends KinematicBody2D

export (float) var vel_desp
export (float) var vel_rot
export (float) var vel_rot_ray
export(float) var COOLDOWN_W1 
export (int) var PRECISION
export (Vector2) var radio_patrullaje
var nivel_alerta = 0

enum estados {none, patrullando, persiguiendo, disparando, vigilando}
var estado_npc = estados.patrullando

var nav = Navigation2D
var path = []
var objetivo = PoolVector2Array()
var puede_disparar = true
var index = 1 #Cual de los patrol points esta recorriendo actualmente
 
var rango_vision_a = 45 #Rango de vision en grados
var dir_ray = false #Direccion actual del Raycast

# Called when the node enters the scene tree for the first time.
func _ready():
	#Agregamos excepcion de raycast con todos los enemigos
	var all_en = get_tree().get_nodes_in_group("enemy")
	for enemy in all_en:
		$rango.add_exception(enemy)

	nav = get_tree().get_nodes_in_group("nav")[0]
	agregar_patrol_points()
	update_path()

func _physics_process(delta):
	radar(delta)
	if(path.size() > 1 && (estado_npc == estados.patrullando || estados.persiguiendo)):
		
		var angulo = get_angle_to(path[0])
		rotate(angulo * vel_rot * delta)
		var d = position.distance_to(path[0])
		if(d > 2):
			position = position.linear_interpolate(path[0], (vel_desp * delta) / d)
		else:
			path.remove(0)
			
	else:
		
		if(estado_npc == estados.patrullando):
			if(index < objetivo.size()):
				index+= 1
			else:
				index = 1
			
			update_path()
		
		if(estado_npc == estados.persiguiendo):

			if(nivel_alerta < 10): #Se enfrio el nivel de alerta
				#print("patrullando")
				estado_npc = estados.patrullando
				agregar_patrol_points()
				update_path()
			else:
				#print("persiguiendo")
				var r = radio_patrullaje.rotated(rand_range(0,360))
				objetivo = []
				objetivo.append(r + global_position) #Asigno como objetivo posicion del player)
				nivel_alerta -= 10
				update_path_enemy()
		
		#estaba aca el update_path, testear si funciona igual

func agregar_patrol_points():
	for p_points in get_parent().get_node("patrol_points").get_children():
		objetivo.append(p_points.position)

func radar(delta):
	procesar_colision()
	
	if(estado_npc == estados.persiguiendo || estado_npc == estados.patrullando):
		if($rango.rotation_degrees < -rango_vision_a): #Se alcanzo el minimo del raycast
			dir_ray = false
		elif($rango.rotation_degrees > rango_vision_a): #Supere el maximo
			dir_ray = true
		
		if(!dir_ray):
			$rango.rotation_degrees += vel_rot_ray *delta
		else:
			$rango.rotation_degrees -= vel_rot_ray *delta

func update_path():
	path = nav.get_simple_path(position, objetivo[index-1], false)
	
func update_path_enemy():
	path = nav.get_simple_path(position, objetivo[0], false)
	
func procesar_colision():
	#Deteccion de players raycast
	if($rango.is_colliding()):
		var col = $rango.get_collider()
		if(col.is_in_group("player")):
			objetivo = []
			nivel_alerta = 100 #Doy alerta maximo
			objetivo.append(col.global_position) #Asigno como objetivo posicion del player)
			update_path_enemy()
			estado_npc = estados.disparando
			get_tree().call_group("enemy", "dar_alarma", col.global_position)
			if(puede_disparar):
				var newshot = get_tree().get_nodes_in_group("main")[0].shotcol.instance()
				get_tree().get_nodes_in_group("nivel")[0].add_child(newshot)
				newshot.get_node("P2").global_position = col.global_position
				if(disparar(col)):
					col.muerte()
					estado_npc = estados.persiguiendo
	elif(estado_npc == estados.disparando):
		estado_npc = estados.persiguiendo
		
	
func disparar(col):
	puede_disparar = false
	$cooldown.start()
	get_tree().get_nodes_in_group("main")[0].generar_sfx(18)
	
	if(rand_range(0.0,100.0) <= PRECISION):
		return true
	else:
		return false

func muerte():
	if(gamehandler.nivel == 1 && gamehandler.instancias == 12):
		gamehandler.instancias = 13
		get_tree().get_nodes_in_group("gui")[0].procesar_instancias()
	var ed = get_tree().get_nodes_in_group("main")[0].enemy_dead.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(ed)
	ed.global_position = global_position
	queue_free()

func _on_cooldown_timeout():
	puede_disparar = true
	
func dar_alarma(posicion):
	var d = position.distance_to(posicion)
	if(d < 800): #Distancia respecto del enemigo al punto de alarma
		if(estado_npc != estados.disparando && estado_npc != estados.persiguiendo):
			objetivo = []
			nivel_alerta = 100 #Doy alerta maximo
			estado_npc = estados.persiguiendo
			objetivo.append(posicion) #Asigno como objetivo posicion del player)
			update_path_enemy()

func cegar(duracion):
	$rango.enabled = false
	yield(get_tree().create_timer(duracion),"timeout")
	$rango.enabled = true
	nivel_alerta = 100
	estado_npc = estados.persiguiendo
	print("aaaaa")
	
	
	
	
	
	
	
	