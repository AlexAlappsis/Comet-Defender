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
var comet_spawn_time_minimum = 1.3
var comet_spawn_time_maximum = 2.6
var comet_spawn_time_reduction_per_thousand_score = .4
var standing_buildings = 12
var max_standing_buildings = 12
var score_per_second = 10
var max_score_multiplier = 10

var score = 0


func _ready():
	#spawn_comet(300.0, Vector2(300.0, 0.0), Vector2(100, 100))
	SCREEN_WIDTH = get_viewport().size.x
	SCREEN_HEIGHT = get_viewport().size.y
	$Gun.SCREEN_WIDTH = SCREEN_WIDTH
	comet_maximum_x += SCREEN_WIDTH
	randomize()
	if get_tree().paused:
		get_tree().paused = false
	else:
		game_start()

func _process(delta):
	var score_multiplier = max(1, standing_buildings / float(max_standing_buildings) * max_score_multiplier)
	score += score_per_second * score_multiplier * delta
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
	var next_spawn_time = rand_range(comet_spawn_time_minimum, comet_spawn_time_maximum)
	next_spawn_time -= score / 1000 * comet_spawn_time_reduction_per_thousand_score
	if next_spawn_time < 0:
		next_spawn_time = .05
	$Spawn.wait_time = next_spawn_time	
	$Spawn.start()


func _on_Ground_body_entered(body):
	if body.is_in_group("Comet"):
		body.hit_by_ground()


func _on_City_building_destroyed():
	standing_buildings -= 1
	if standing_buildings == 0:
		game_over()
		
func game_over():
	$Game_Over_Popup.popup_centered(Vector2(150, 100))
	$Game_Over_Popup/CenterContainer/VBoxContainer/Score.text = "Final Score: "+str(floor(score))	
	get_tree().paused = true
	
func game_start():
	$Game_Start_Popup.popup_centered(Vector2(200, 100))
	get_tree().paused = true

func _on_Restart_pressed():
	get_tree().reload_current_scene()

func _on_Help_pressed():
	$Help.popup_centered(Vector2(500, 400))

func _on_Start_pressed():
	$Game_Start_Popup.hide()
	get_tree().paused = false
