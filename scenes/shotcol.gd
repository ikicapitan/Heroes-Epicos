extends Node

func _ready():
	$P2.emitting = true

func _physics_process(delta):
	if(!$P2.emitting):
		#queue_free()
		pass