extends Node2D

var heat_level_max = 6
var overheat_capacity = 1
var overheat_level = 0.0
var heat_level = 0.0
var heat_gain_rate = 2
var heat_loss_rate = 4
var firing = false
var shot_loaded = true
var heat_indicator_level = 0
var shutdown = false

export (PackedScene) var shot_scene
export (Color) var gun_base_color

func _ready():
	firing = true
	
func _process(delta):
	if firing:
		firing(delta)
	else:
		cooling(delta)
	
func firing(delta):
	if shot_loaded == true:
		spawn_shot()
		shot_loaded = false
		$Reload.start()
	heat_gain(delta)
	
func cooling(delta):
	heat_loss(delta)

func on_reload():
	shot_loaded = true
	
func heat_gain(delta):
	var added_heat = heat_gain_rate * delta
	heat_level += added_heat
	if heat_level > heat_level_max:
		overheat_level += heat_level - heat_level_max
		heat_level = heat_level_max
	if overheat_level > overheat_capacity:
		shutdown()
	update_heat_indicator_level()
	update_overheat_display()
	
func heat_loss(delta):
	var removed_heat = heat_loss_rate * delta
	overheat_level -= removed_heat
	if overheat_level < 0:
		heat_level += overheat_level
		overheat_level = 0
	if heat_level < 0:
		heat_level = 0
	update_heat_indicator_level()
	update_overheat_display()
	
func update_heat_indicator_level():
	var updated_heat_indicator_level = floor(heat_level)
	if updated_heat_indicator_level != heat_indicator_level:
		heat_indicator_level = updated_heat_indicator_level
		if heat_indicator_level == 0:
			$Heat_Level.texture = null
		else:
			$Heat_Level.texture = load("res://Gun_Heat_"+str(heat_indicator_level)+".png")#should probably do this differently
		
func update_overheat_display():
	if overheat_level > 0:
		var minimum_red = gun_base_color.r
		var maximum_red = 1.0
		var red = (maximum_red - minimum_red) * overheat_level / overheat_capacity + minimum_red
		var color = Color(red, gun_base_color.g, gun_base_color.b, gun_base_color.a)
		$Bottom.self_modulate = color
		$Top.self_modulate = color
	else:
		$Bottom.self_modulate = gun_base_color
		$Top.self_modulate = gun_base_color

func shutdown():
	firing = false
	shutdown = true

func restart():
	shutdown = false

func start_firing():
	if shutdown == false:
		firing = true
	
func stop_firing():
	firing = false
	
func spawn_shot():
	pass