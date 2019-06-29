extends Node2D

export (int) var nivel

export (PackedScene) var gui
export (PackedScene) var cam
export (PackedScene) var cam_obj
export (PackedScene) var sfx
export (PackedScene) var shotcol
export (PackedScene) var select


func load_level():
	var lvl = load("res://niveles/nivel" +str(nivel)+ ".tscn")
	

	var newgui = gui.instance()
	add_child(newgui)
	gamehandler.puntero = $objetivo
	
	var newlvl = lvl.instance()
	newgui.add_child(newlvl)
	
	var newcam = cam.instance()
	newgui.add_child(newcam)
	newcam.global_position = get_tree().get_nodes_in_group("player")[0].global_position
	
	var maximo = get_tree().get_nodes_in_group("max")[0].position
	var minimo = get_tree().get_nodes_in_group("min")[0].position
	
	newcam.limit_left = minimo.x
	newcam.limit_right = maximo.x
	newcam.limit_top = minimo.y
	newcam.limit_bottom = maximo.y
	
	
	#Cam objetivo
	var newcamo = cam_obj.instance()
	newcamo.name = "Camaraaaaa"
	newgui.add_child(newcamo)

func _ready():
	load_level()

func generar_sfx(num):
	var audioSource = load("res://sfx/" +str(num)+ ".WAV")
	var newSfx = sfx.instance()
	add_child(newSfx)
	newSfx.stream = audioSource
	newSfx.play()
	

