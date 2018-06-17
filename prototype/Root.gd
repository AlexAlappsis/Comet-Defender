extends Node2D

export (PackedScene) var comet_scene

func _ready():
	spawn_comet(1000.0, Vector2(300.0, 0.0), Vector2(100, 100))
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


func spawn_comet(mass, positionVector, velocityVector):
	var new_comet = comet_scene.instance()
	new_comet.position = positionVector
	new_comet.update_mass(mass)
	new_comet.apply_impulse(Vector2(0.0, 0.0), velocityVector)
	add_child(new_comet)
