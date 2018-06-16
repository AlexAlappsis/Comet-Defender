extends Area2D

export (int) var speed

func _ready():
	pass
	
func _physics_process(delta):
	var movement = Vector2(0.0, -speed * delta).rotated(rotation)
	position = position + movement
	
	if position.y < -20:
		queue_free()
