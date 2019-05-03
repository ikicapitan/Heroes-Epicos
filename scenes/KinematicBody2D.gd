extends KinematicBody2D

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
		var angulo = get_angle_to(path[0])
		rotate(angulo * vel_rot * delta)
		var d = position.distance_to(path[0])
		if(d > 2):
			position = position.linear_interpolate(path[0], (vel_desp * delta) / d)
		else:
			path.remove(0)
			
func update_path():
	objetivo = gamehandler.puntero
	path = nav.get_simple_path(position, objetivo.position, false)
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if(gamehandler.estado_actual == gamehandler.estados.select):
		if(event is InputEventScreenTouch || (event is InputEventMouseButton && event.button_index == BUTTON_LEFT)):
			gamehandler.target = get_parent()
			var cam = get_tree().get_nodes_in_group("cam")[0]
			cam.get_parent().remove_child(cam) #Remuevo la camara como hijo
			get_node("Area2D").add_child(cam) 
			cam.position = position
			cam.position = position - cam.position
			
