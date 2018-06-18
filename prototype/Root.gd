extends Node2D

export (PackedScene) var comet_scene

var SCREEN_HEIGHT
var SCREEN_WIDTH
var comet_minimum_mass = 150
var comet_maximum_mass = 1000
var comet_minimum_height = -50
var comet_maximum_height = -300
var comet_minimum_starting_velocity = 20
var comet_maximum_starting_velocity = 200
var comet_minimum_x = -200
var comet_maximum_x = 200
var comet_spawn_time_minimum = .8
var comet_spawn_time_maximum = 1.8
var standing_buildings = 6
var score_per_second = 5
var score_multiplier_per_building = .5

var score = 0


func _ready():
	#spawn_comet(300.0, Vector2(300.0, 0.0), Vector2(100, 100))
	SCREEN_WIDTH = get_viewport().size.x
	SCREEN_HEIGHT = get_viewport().size.y
	$Gun.SCREEN_WIDTH = SCREEN_WIDTH
	comet_maximum_x += SCREEN_WIDTH
	randomize()

func _process(delta):
	score += score_per_second * (standing_buildings * score_multiplier_per_building) * delta
	$Score_UI/HBoxContainer/MarginContainer/Score.text = str(floor(score))

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


func spawn_comet(mass, position_vector, velocity_vector):
	var new_comet = comet_scene.instance()
	new_comet.position = position_vector
	new_comet.set_initial_mass(mass)
	new_comet.apply_impulse(Vector2(0.0, 0.0), velocity_vector)
	new_comet.SCREEN_HEIGHT = SCREEN_HEIGHT
	add_child(new_comet)


func _on_Spawn_timeout():
	var comet_mass = rand_range(comet_minimum_mass, comet_maximum_mass)
	var comet_x = rand_range(comet_minimum_x, comet_maximum_x)
	var comet_y = rand_range(comet_minimum_height, comet_maximum_height)
	var position_vector = Vector2(comet_x, comet_y)
	var target_vector = Vector2(SCREEN_HEIGHT, rand_range(0, SCREEN_WIDTH))
	var velocity_vector = (target_vector - position_vector).normalized() * rand_range(comet_minimum_starting_velocity, comet_maximum_starting_velocity)
	spawn_comet(comet_mass, position_vector, velocity_vector)
	$Spawn.wait_time = rand_range(comet_spawn_time_minimum, comet_spawn_time_maximum)
	$Spawn.start()


func _on_Ground_body_entered(body):
	if body.is_in_group("Comet"):
		body.hit_by_ground()


func _on_City_building_destroyed():
	standing_buildings -= 1
	if standing_buildings == 0:
		game_over()
		
func game_over():
	pass