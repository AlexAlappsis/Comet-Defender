extends Particles2D

func _ready():
	pass


func _on_Kill_Timer_timeout():
	queue_free()
