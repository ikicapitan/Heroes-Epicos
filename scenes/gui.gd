extends CanvasModulate


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
	pass # Replace with function body.



