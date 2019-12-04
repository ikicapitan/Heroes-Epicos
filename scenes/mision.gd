extends CanvasLayer
export (PackedScene) var juego

var procesando_i = false

var dat = {
	texto = ""
	}

var instancia = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mostrar_instancia()

func procesar_instancia():
	if(!procesando_i):
		procesando_i = true
		instancia+= 1
		mostrar_instancia()
		yield(get_tree().create_timer(0.5),"timeout")
		procesando_i = false
	
	
func mostrar_instancia():
	cargar_texto()
			
func cargar_texto():
	var file = File.new()
	
	if(!file.file_exists("res://data/mision/" + String(gamehandler.nivel) + "/" + String(instancia) + ".txt")):
		gamehandler.estado_j_actual = gamehandler.estados_juego.juego
		get_tree().change_scene_to(juego)
	else:
		file.open("res://data/mision/" + String(gamehandler.nivel) + "/" + String(instancia) + ".txt", File.READ)
		
		var data = dat
		
		if(!file.eof_reached()):
			data = parse_json(file.get_line())
		
		$newgame.text = file.get_as_text()
		
		file.close()