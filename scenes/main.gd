extends Node2D

export (PackedScene) var lvl_1
export (PackedScene) var lvl_2
export (PackedScene) var lvl_3
export (PackedScene) var lvl_4
export (PackedScene) var lvl_5

export (PackedScene) var gui


func _ready():
	var newlvl = lvl_1.instance()
	add_child(newlvl)
	var newgui = gui.instance()
	add_child(newgui)
	gamehandler.puntero = $objetivo

