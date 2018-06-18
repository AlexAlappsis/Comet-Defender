extends Particles2D

func _ready():
	$Explosion.play()

func _on_Kill_Timer_timeout():
	queue_free()
