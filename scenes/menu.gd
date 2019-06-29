extends Node2D

export (PackedScene) var juego


var instancia = 0 #Pantalla carga

func _ready():
	pass # Replace with function body.

func procesar_instancia():
	instancia += 1
	match(instancia):
		1: 
			gamehandler.estado_j_actual = gamehandler.estados_juego.juego
			get_tree().change_scene_to(juego)