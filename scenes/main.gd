extends CanvasModulate

export (PackedScene) var gui
export (PackedScene) var cam
export (PackedScene) var cam_obj
export (PackedScene) var sfx
export (PackedScene) var shotcol
export (PackedScene) var select

export (PackedScene) var pj_dead
export (PackedScene) var enemy_dead


var datos = {
	nivel = 0,
	}

func restart_level():
	fade_out()
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
	
	save()
	
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
	
	#Tiempo si hay bombas
	if(get_tree().get_nodes_in_group("bomba").size() > 0): #Hay un objeto tipo bomba encontrado
		get_tree().get_nodes_in_group("tiempo")[0].visible = true
	else:
		get_tree().get_nodes_in_group("tiempo")[0].visible = false
	
	if(!gamehandler.sound):
		get_tree().get_nodes_in_group("bgm")[0].stop()

func _ready():
	load_level()

func generar_sfx(num):
	if(gamehandler.sound):
		var audioSource = load("res://sfx/" +str(num)+ ".wav")
		var newSfx = sfx.instance()
		add_child(newSfx)
		newSfx.add_to_group("sfx")
		newSfx.stream = audioSource
		newSfx.play()
	

func fade_in():
	$canvas.play("fade_in")
	
func fade_out():
	$canvas.play("fade_out")
	



func _on_canvas_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		load_level()

func save():
	var guardar = File.new()
	guardar.open("user://hepicos.sav",File.WRITE)
	
	var dato_guardar = datos
	
	dato_guardar.nivel = gamehandler.nivel
	
	guardar.store_line(to_json(dato_guardar))
	
	guardar.close()