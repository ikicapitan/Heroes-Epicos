extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if(is_in_group("not_saved") && body.is_in_group("player")):
		remove_from_group("not_saved")
		gamehandler.hostage_saved()