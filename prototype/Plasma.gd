extends KinematicBody2D

export (int) var speed
export (float) var heat = 1
export (int) var SCREEN_WIDTH

func _ready():
	pass
	
func _physics_process(delta):
	var movementVector = Vector2(0.0, -speed * delta).rotated(rotation)
	var collision = move_and_collide(movementVector)
	if collision != null:
		var collider = collision.collider
		if collider.is_in_group("Comet"):
			collider.hit_by_plasma(collision.position, heat)
		queue_free()
	if position.y < -20 or position.x < -20 or position.x > SCREEN_WIDTH + 20:
		queue_free()
