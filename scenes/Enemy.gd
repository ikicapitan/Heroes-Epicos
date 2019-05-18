extends KinematicBody2D

export (float) var vel_desp
export (float) var vel_rot
export (float) var vel_rot_ray
export(float) var COOLDOWN_W1 
export (int) var PRECISION

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
	for p_points in get_parent().get_node("patrol_points").get_children():
		objetivo.append(p_points.position)
	update_path()

func _physics_process(delta):
	radar(delta)
	if(path.size() > 1 && (estado_npc == estados.persiguiendo || estado_npc == estados.patrullando)):
		var angulo = get_angle_to(path[0])
		rotate(angulo * vel_rot * delta)
		var d = position.distance_to(path[0])
		if(d > 2):
			position = position.linear_interpolate(path[0], (vel_desp * delta) / d)
		else:
			path.remove(0)
	else:
		if(index < objetivo.size()):
			index+= 1
		else:
			index = 1
		update_path()

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
	
func procesar_colision():
	#Deteccion de players raycast
	if($rango.is_colliding()):
		var col = $rango.get_collider()
		if(col.is_in_group("player")):
			estado_npc = estados.disparando
			if(puede_disparar):
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

func _on_cooldown_timeout():
	puede_disparar = true
