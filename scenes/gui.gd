extends CanvasModulate


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_btn_select_button_down():
	gamehandler.estado_actual = gamehandler.estados.select

func _on_btn_move_button_down():
	gamehandler.estado_actual = gamehandler.estados.move

func _on_btn_w1_button_down():
	gamehandler.estado_actual = gamehandler.estados.weapon1

func _on_btn_w2_button_down():
	gamehandler.estado_actual = gamehandler.estados.weapon2

func _on_btn_cam_button_down():
	gamehandler.estado_actual = gamehandler.estados.camera
	gamehandler.free_camera()


func _on_btn_exit_button_down():
	pass # Replace with function body.



