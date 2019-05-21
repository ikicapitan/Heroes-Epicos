extends Node2D

export (int) var nivel

export (PackedScene) var gui
export (PackedScene) var cam
export (PackedScene) var sfx
export (PackedScene) var shotcol


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
	
	

	
	

func _ready():
	load_level()

func generar_sfx(num):
	var audioSource = load("res://sfx/" +str(num)+ ".WAV")
	var newSfx = sfx.instance()
	add_child(newSfx)
	newSfx.stream = audioSource
	newSfx.play()
	

