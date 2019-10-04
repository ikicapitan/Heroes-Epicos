extends Node2D

export (float) var duracion

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()



func _on_Area2D_body_entered(body):
	if(body.is_in_group("enemy")):
		look_at(body.global_position) #Miro al enemigo (para rotar el raycast)
		if($RayCast2D.is_colliding()):
			var col = $RayCast2D.get_collider()
			if(col.is_in_group("npc")):
				body.cegar(duracion)
				body.path = []
				body.dar_alarma(body.global_position)
				
		


func _on_Timer_timeout():
	queue_free()
