extends KinematicBody2D

var Velocidad = Vector2()
export (float) var vel_desp
export (float) var vel_rot
export(float) var COOLDOWN_W1 
export(float) var COOLDOWN_W2
export (int) var PRECISION
var nav = Navigation2D
var path = []
var objetivo = Vector2()
var puede_disparar = true
 


# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_tree().get_nodes_in_group("nav")[0]

func _physics_process(delta):
	if(path.size() > 1):
		var d = global_position.distance_to(path[0])
		if(d > 2):
			global_position = global_position.linear_interpolate(path[0], (vel_desp * delta) / d)
		else:
			path.remove(0)