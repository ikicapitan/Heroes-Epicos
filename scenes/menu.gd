extends Node2D

export (PackedScene) var juego


var instancia = 0 #Pantalla carga

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
	gamehandler.estado_j_actual = gamehandler.estados_juego.juego
	get_tree().change_scene_to(juego)


func _on_continue_pressed():
	pass # Replace with function body.


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
