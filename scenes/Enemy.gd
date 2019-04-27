extends KinematicBody2D

export (float) var vel_desp
export (float) var vel_rot
export(float) var COOLDOWN_W1 
export(float) var COOLDOWN_W2
export (int) var PRECISION
var nav = Navigation2D
var path = []
var objetivo = PoolVector2Array()
var puede_disparar = true
var index = 1 #Cual de los patrol points esta recorriendo actualmente
 


# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_tree().get_nodes_in_group("nav")[0]
	for p_points in get_parent().get_node("patrol_points").get_children():
		objetivo.append(p_points.position)
	update_path()

func _physics_process(delta):
	if(path.size() > 1):
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
			
func update_path():
	path = nav.get_simple_path(position, objetivo[index-1], false)
	