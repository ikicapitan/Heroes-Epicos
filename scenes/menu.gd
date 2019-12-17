extends Node2D

export (PackedScene) var juego
export (PackedScene) var mision


var instancia = 0 #Pantalla carga

var datos = {
	nivel = 0
	}

func _ready():
	pass # Replace with function body.

func procesar_instancia():
	instancia += 1
	match(instancia):
		1: 
			$CanvasLayer/bckg.visible = false
			$CanvasLayer/bckg2.visible = true
			$CanvasLayer/title.visible = true
			$CanvasLayer/touch_start.visible = false
			$CanvasLayer/menu2.visible = true


func _on_start_pressed():
	gamehandler.estado_j_actual = gamehandler.estados_juego.mision
	get_tree().change_scene_to(mision)


func _on_continue_pressed():
	load_data()
	gamehandler.estado_j_actual = gamehandler.estados_juego.mision
	get_tree().change_scene_to(mision)


func _on_creditos_pressed():
	$CanvasLayer/title.visible = false
	$CanvasLayer/menu2.visible = false
	$CanvasLayer/menu3.visible = true


func _on_salir_pressed():
	get_tree().quit()


func _on_atras_pressed():
	$CanvasLayer/menu3.visible = false
	$CanvasLayer/menu2.visible = true
	$CanvasLayer/title.visible = true

func load_data():
	var cargar = File.new()
	if(cargar.file_exists("user://hepicos.sav")):
		cargar.open("user://hepicos.sav",File.READ)
		var dato_cargar = datos
		if(!cargar.eof_reached()):
			dato_cargar.nivel = parse_json(cargar.get_line())
		cargar.close()
		
		gamehandler.nivel = dato_cargar.nivel