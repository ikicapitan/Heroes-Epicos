extends Node

export (int) var tiempo
export (PackedScene) var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Timer_timeout():
	if(tiempo > 0):
		tiempo -= 1
		gamehandler.update_time(tiempo)
	else:
		get_tree().get_nodes_in_group("main")[0].restart_level()
		var newexp = explosion.instance()
		add_child(newexp)
		newexp.global_position = $Personaje.global_position
		queue_free()


func _on_Area2D_body_exited(body):
	$Timer.stop()
	$Personaje.remove_from_group("not_saved")
	gamehandler.hostage_saved()
	queue_free()
