extends Node2D

export (int) var nivel

export (PackedScene) var gui
export (PackedScene) var cam


func load_level():
	var lvl = load("res://niveles/nivel" +str(nivel)+ ".tscn")
	

	var newgui = gui.instance()
	add_child(newgui)
	gamehandler.puntero = $objetivo
	
	var newlvl = lvl.instance()
	newgui.add_child(newlvl)
	
	var newcam = cam.instance()
	newgui.add_child(newcam)
	newcam.global_position = get_tree().get_nodes_in_group("player")[0].get_node("Personaje").global_position
	
	

	
	

func _ready():
	load_level()


