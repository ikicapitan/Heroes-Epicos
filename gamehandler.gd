extends Node

var target #Unidad seleccionada
var puntero #Hacia donde apunta el mouse

var sound = true

enum estados_juego {menu,juego, mision}
var estado_j_actual = estados_juego.menu

enum estados {none,select,move,weapon1,weapon2, camera}
var estado_actual = estados.none

var nivel = 5

var instancias = 0 #0 intro, 1 cam, 2 intro


var select_wait = false

#Android
var drag_ant = false
var primer_drag = Vector2()
var boton_presionado = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	pass #Amor y paz 
	
func _unhandled_input(event):
	match(estado_j_actual):
		estados_juego.menu:
			if(event is InputEventMouseButton || event is InputEventScreenTouch):
				#Pasamos a otra instancia del menu
				if(get_tree().get_nodes_in_group("menu")[0].instancia == 0):
					get_tree().get_nodes_in_group("menu")[0].procesar_instancia()
		estados_juego.mision:
			if(event is InputEventMouseButton || event is InputEventScreenTouch):
				get_tree().get_nodes_in_group("mision")[0].procesar_instancia()
		estados_juego.juego:
			if(target != null):
				#ANRDOID
				if(estado_actual == estados.move && !boton_presionado):
					if(event is InputEventScreenTouch):
						puntero.position = puntero.get_global_mouse_position()
						target.get_node("Personaje").update_path()
						if(gamehandler.nivel == 1 && gamehandler.instancias == 6):
							gamehandler.instancias = 7
							get_tree().get_nodes_in_group("gui")[0].procesar_instancias()
				elif((estado_actual == estados.weapon1 || estado_actual == estados.weapon2) && !boton_presionado):
					if(event is InputEventScreenTouch):
						puntero.position = puntero.get_global_mouse_position()
						target.get_node("Personaje").disparar()
			
				#PC
				if(event is InputEventMouseButton):
					if(event.button_index == BUTTON_RIGHT):
						if(estado_actual == estados.move):
							puntero.position = puntero.get_global_mouse_position()
							target.get_node("Personaje").update_path()
							if(gamehandler.nivel == 1 && gamehandler.instancias == 6):
								gamehandler.instancias = 7
								get_tree().get_nodes_in_group("gui")[0].procesar_instancias()
					if(event.button_index == BUTTON_LEFT):
						if((estado_actual == estados.weapon1 || estado_actual == estados.weapon2) && !boton_presionado):
							puntero.position = puntero.get_global_mouse_position()
							target.get_node("Personaje").disparar()
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
		
func hostage_saved():
	if(get_tree().get_nodes_in_group("not_saved").size() == 0):
		nivel += 1
		estado_j_actual = estados_juego.mision
		get_tree().get_nodes_in_group("main")[0].clear_data_level()
		get_tree().change_scene("res://scenes/mision.tscn")
		
		#animacion + change level
		
func update_time(t):
	get_tree().get_nodes_in_group("tiempo")[0].get_node("time").text = String(int(t/60)) + " " + String(int(t%60))