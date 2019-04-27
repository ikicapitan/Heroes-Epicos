extends Node

var target #Unidad seleccionada
var puntero #Hacia donde apunta el mouse

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if(target != null):
		#ANRDOID
		if(event is InputEventScreenTouch):
			puntero.position = event.position
			target.get_node("Personaje").update_path()
		#PC
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_RIGHT):
				puntero.position = puntero.get_global_mouse_position()
				target.get_node("Personaje").update_path()