extends Node2D

func _ready():
	pass

func _physics_process(delta):
	calculateTurretAngle()

func _unhandled_input(event):
	if event.is_action_pressed("Fire"):
		$Gun.start_firing()
	if event.is_action_released("Fire"):
		$Gun.stop_firing()

func calculateTurretAngle():
	var mouse_position = get_viewport().get_mouse_position()
	var turretVector = mouse_position - $Gun.position
	var target_turret_angle = turretVector.angle() / PI * 180
	if target_turret_angle < 0:
		target_turret_angle += 360
	target_turret_angle += 90
	if target_turret_angle < 0:
		target_turret_angle += 360
	if target_turret_angle >= 360:
		target_turret_angle -= 360
	$Gun.target_angle_set(target_turret_angle)
