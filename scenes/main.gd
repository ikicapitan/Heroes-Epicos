extends CanvasModulate

export (PackedScene) var gui
export (PackedScene) var cam
export (PackedScene) var cam_obj
export (PackedScene) var sfx
export (PackedScene) var shotcol
export (PackedScene) var select

export (PackedScene) var pj_dead
export (PackedScene) var enemy_dead




func restart_level():
	yield(get_tree().create_timer(2.0),"timeout")
	clear_data_level()
	get_tree().reload_current_scene()
	
func clear_data_level():
	gamehandler.instancias = 0
	gamehandler.estado_actual = gamehandler.estados.none
	gamehandler.target = null
	gamehandler.puntero = null

func load_level():
	fade_in()
	
	var lvl = load("res://niveles/nivel" +str(gamehandler.nivel)+ ".tscn")
	

	var newgui = gui.instance()
	add_child(newgui)
	newgui.procesar_instancias()
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
	
	gamehandler.instancias = 0

func _ready():
	load_level()

func generar_sfx(num):
	var audioSource = load("res://sfx/" +str(num)+ ".WAV")
	var newSfx = sfx.instance()
	add_child(newSfx)
	newSfx.stream = audioSource
	newSfx.play()
	

func fade_in():
	$canvas.play("fade_in")
	
func fade_out():
	$canvas.play("fade_out")
	



func _on_canvas_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		load_level()

