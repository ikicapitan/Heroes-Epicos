extends Node

export (int) var id
export (int) var vidas = 1

var dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func morir():
	vidas -= 1
	if(!dead && vidas <= 0):
		get_tree().get_nodes_in_group("main")[0].generar_sfx(50)
		get_tree().get_nodes_in_group("sfx")[get_tree().get_nodes_in_group("sfx").size()-1].pitch_scale = 2.0
		dead = true
		var p_dead = get_tree().get_nodes_in_group("main")[0].pj_dead.instance()
		get_tree().get_nodes_in_group("nivel")[0].add_child(p_dead)
		p_dead.global_position = $Personaje.global_position
		$Personaje/Area2D/Sprite.visible = false
		$Personaje.path = []
		$Personaje/Area2D/CollisionShape2D.disabled = true
		$Personaje/CollisionShape2D.disabled = true
		if(get_tree().get_nodes_in_group("select").size() > 0):
			get_tree().get_nodes_in_group("select")[0].visible = false
		get_tree().get_nodes_in_group("main")[0].restart_level()
	
