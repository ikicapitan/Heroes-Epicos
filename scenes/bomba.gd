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
		get_tree().get_nodes_in_group("main")[0].generar_sfx(47)
		var newexp = explosion.instance()
		newexp.global_position = $Personaje.global_position
		get_tree().get_nodes_in_group("nivel")[0].add_child(newexp)
		
		queue_free()


func _on_Area2D_body_exited(body):
	pass

func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")):
		$Timer.stop()
		$Personaje/Area2D/CollisionShape2D.disabled = true
		$Personaje.remove_from_group("not_saved")
		gamehandler.hostage_saved()
		queue_free()
