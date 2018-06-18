extends Particles2D

func start_kill_countdown():
	$KIll_Timer.start()

func _on_Timer_timeout():
	queue_free()