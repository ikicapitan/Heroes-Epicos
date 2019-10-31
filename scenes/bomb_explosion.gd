extends Node2D

func _ready():
	$P2.emitting = true
	$P3.emitting = true

func _physics_process(delta):
	if(!$P2.emitting):
		#queue_free()
		pass