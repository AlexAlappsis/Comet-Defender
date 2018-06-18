extends KinematicBody2D

export (int) var speed
export (float) var heat = 1
export (int) var SCREEN_WIDTH

func _ready():
	var color_red_mod = 230 + ((heat - 1) * 5)
	var color_blue_green_mod = 155 + ((heat - 1) * 20)
	$AnimatedSprite.modulate = Color(color_red_mod / 255, color_blue_green_mod / 255, color_blue_green_mod / 255, 1.0)
	
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
