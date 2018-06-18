extends Particles2D

func _on_Timer_timeout():
	queue_free()
	
func get_left_behind():
	$Kill_Timer.start()
	emitting = false