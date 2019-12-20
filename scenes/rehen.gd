extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	
	if($Personaje.is_in_group("not_saved") && body.is_in_group("player")):
		$Personaje.remove_from_group("not_saved")
		gamehandler.hostage_saved()
		queue_free()
		
func muerte():
	get_tree().get_nodes_in_group("main")[0].generar_sfx(50)
	get_tree().get_nodes_in_group("sfx")[get_tree().get_nodes_in_group("sfx").size()-1].pitch_scale = 1.5
	var p_dead = get_tree().get_nodes_in_group("main")[0].pj_dead.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(p_dead)
	p_dead.global_position = $Personaje.global_position
	$Personaje/Area2D/Sprite.visible = false
	$Personaje/CollisionShape2D.disabled = true
	$Personaje/Area2D/CollisionShape2D.disabled = true
	get_tree().get_nodes_in_group("main")[0].restart_level()