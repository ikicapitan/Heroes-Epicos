extends Path2D

export (float) var vel_cam

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_nodes_in_group("botones")[0].visible = false
	$PathFollow2D/Camera2D.make_current()
	var curva = Curve2D.new()
	curva.add_point(get_tree().get_nodes_in_group("objetivo")[0].global_position)
	curva.add_point(get_tree().get_nodes_in_group("player")[0].global_position)
	curve = curva
	


func _physics_process(delta):
	if($PathFollow2D.unit_offset >= 1):
		$PathFollow2D/Camera2D.clear_current()
		get_tree().get_nodes_in_group("cam")[0].make_current()
		get_tree().get_nodes_in_group("botones")[0].visible = true
		queue_free()
	else:
		$PathFollow2D.offset += delta * vel_cam
	