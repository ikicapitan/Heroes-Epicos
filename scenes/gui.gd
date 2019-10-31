extends CanvasModulate

var dat = {
	texto = ""
	}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_btn_select_button_down():
	gamehandler.estado_actual = gamehandler.estados.select
	button_press()

func _on_btn_move_button_down():
	gamehandler.estado_actual = gamehandler.estados.move
	button_press()

func _on_btn_w1_button_down():
	if(gamehandler.target != null):
		if(gamehandler.target.id == 2):
			gamehandler.target.get_node("Personaje").vestir()
		else:
			gamehandler.estado_actual = gamehandler.estados.weapon1
			button_press()

func _on_btn_w2_button_down():
	gamehandler.estado_actual = gamehandler.estados.weapon2
	button_press()

func _on_btn_cam_button_down():
	gamehandler.estado_actual = gamehandler.estados.camera
	gamehandler.free_camera()
	button_press()


func button_press():
	gamehandler.boton_presionado = true
	yield(get_tree().create_timer(0.5),"timeout")
	gamehandler.boton_presionado = false

func _on_btn_exit_button_down():
	get_tree().quit()


func procesar_instancias():
		
	leer_tuto()
	#match(gamehandler.instancias):
	#	0:
	#		$GUI/Dialogo.visible = true
	#		
	#	1:
	#		$GUI/Dialogo.visible = false
	#	2:
	#		$GUI/Dialogo.visible = true

func leer_tuto():
	var file = File.new()
	
	if(!file.file_exists("res://data/tutorial/" + String(gamehandler.nivel) + "/" + String(gamehandler.instancias) + ".txt")):
		$GUI/Dialogo.visible = false
		get_tree().get_nodes_in_group("botones")[0].visible = true
	else:
		$GUI/Dialogo.visible = true
		file.open("res://data/tutorial/" + String(gamehandler.nivel) + "/" + String(gamehandler.instancias) + ".txt", File.READ)
		
		var data = dat
		
		if(!file.eof_reached()):
			data = parse_json(file.get_line())
		
		$GUI/Dialogo/tuto_text.text = file.get_as_text()
		
		file.close()

func _on_TextureButton_pressed():
	gamehandler.instancias += 1
	$GUI/Dialogo.visible = false
	procesar_instancias()
	