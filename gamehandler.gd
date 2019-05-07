extends Node

var target #Unidad seleccionada
var puntero #Hacia donde apunta el mouse

enum estados {none,select,move,weapon1,weapon2, camera}
var estado_actual = estados.none

#Android
var drag_ant = false
var primer_drag = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if(target != null):
		#ANRDOID
		if(estado_actual == estados.move):
			if(event is InputEventScreenTouch):
				puntero.position = event.position
				target.get_node("Personaje").update_path()
	
		#PC
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_RIGHT):
				if(estado_actual == estados.move):
					puntero.position = puntero.get_global_mouse_position()
					target.get_node("Personaje").update_path()
	
	#Android
	if(estado_actual == estados.camera):
		if(event is InputEventScreenDrag):
			if(drag_ant):
				primer_drag = event.relative*3 - primer_drag
				get_tree().get_nodes_in_group("cam")[0].position += primer_drag
				drag_ant = false
			else:
				drag_ant = true
				primer_drag = event.relative
		elif(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT):
				if(event.is_pressed()):
					primer_drag = true
				else:
					primer_drag = false
			
		elif(event is InputEventMouseMotion && primer_drag):
				var cam = get_tree().get_nodes_in_group("cam")[0]
				cam.global_position += -event.speed/10
	
		
func free_camera(): #Deja la camara libre para mover
	if(target != null):
		var cam = get_tree().get_nodes_in_group("cam")[0]
		cam.get_parent().remove_child(cam)
		get_tree().get_nodes_in_group("gui")[0].add_child(cam)
		cam.position = target.get_node("Personaje").position