extends Area2D

export (Color) var color
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var radio = $CollisionShape2D.shape.get_radius()
	var pos = Vector2(0,0)
	draw_circle(pos, radio, color)