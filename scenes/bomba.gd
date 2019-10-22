extends Node

export (int) var tiempo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Timer_timeout():
	if(tiempo > 0):
		tiempo -= 1
		gamehandler.update_time(tiempo)
	else:
		pass
