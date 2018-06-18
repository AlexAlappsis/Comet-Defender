extends RigidBody2D

export (Color) var color
export (float) var plasma_hit_heat_factor
export (float) var plasma_base_impulse
export (float) var mass_loss_per_plasma_hit
export (float) var mass_loss_extra_per_plasma_heat
export (float) var minimum_mass
export (float) var density_calculation_value
export (float) var partical_density_per_mass
export (PackedScene) var comet_trail_scene
export (PackedScene) var plasma_hit_scene
export (PackedScene) var comet_explosion_scene
export (int) var SCREEN_HEIGHT

var size
var current_comet_trail

func _ready():
	create_comet_trail()

func _draw():
	draw_circle(Vector2(0.0, 0.0), size, color)
	
func _physics_process(delta):
	if position.y > SCREEN_HEIGHT + 200:
		queue_free()
	if current_comet_trail != null:
		current_comet_trail.position = position

func update_particle_density():
	leave_comet_trail()
	create_comet_trail()

func set_initial_mass(new_mass):
	mass = new_mass
	size = mass / density_calculation_value
	var shape = CircleShape2D.new()
	shape.set_radius(size)
	shape_owner_clear_shapes(0)
	shape_owner_add_shape(0, shape)
	$"CollisionShape2D".set_shape(shape)

func create_comet_trail():
	var comet_trail = comet_trail_scene.instance()
	comet_trail.process_material = comet_trail.process_material.duplicate(true)
	comet_trail.amount = partical_density_per_mass * mass
	comet_trail.process_material.emission_sphere_radius = size
	current_comet_trail = comet_trail
	current_comet_trail.position = position
	get_parent().add_child(comet_trail)
	
func leave_comet_trail():
	if current_comet_trail != null:
		current_comet_trail.start_kill_countdown()
		current_comet_trail.emitting = false
		current_comet_trail = null

func update_mass(new_mass):
	if new_mass < minimum_mass:
		too_small()
	else:
		mass = new_mass
		size = mass / density_calculation_value
		var shape = shape_owner_get_shape(0, 0)
		shape.set_radius(size)
		$CollisionShape2D.shape.radius = size
		update()
		update_particle_density()
	

func hit_by_plasma(point, plasma_heat):	
	var impulse_vector = (position - point).normalized() * plasma_base_impulse * (plasma_hit_heat_factor * plasma_heat)
	apply_impulse(point, impulse_vector)
	#changing mass after impulse because impulse comes from lost mass becoming steam
	var new_mass = mass - (mass_loss_per_plasma_hit) - (mass_loss_extra_per_plasma_heat * plasma_heat)
	update_mass(new_mass)
	var plasma_hit_particles = plasma_hit_scene.instance()
	plasma_hit_particles.amount = plasma_hit_particles.amount * (1 + (plasma_heat / 6))
	plasma_hit_particles.position = (point - position).rotated(-rotation)
	add_child(plasma_hit_particles)
	plasma_hit_particles.emitting = true

func hit_by_gun():
	explode()
	
func hit_by_ground():
	explode()
	
func hit_by_city():
	explode()

func too_small():
	explode()

func explode():
	leave_comet_trail()
	var comet_explosion = comet_explosion_scene.instance()
	comet_explosion.process_material = comet_explosion.process_material.duplicate(true)
	comet_explosion.amount = partical_density_per_mass * mass * 20
	comet_explosion.process_material.emission_sphere_radius = size
	comet_explosion.position = position
	get_parent().add_child(comet_explosion)
	comet_explosion.emitting = true
	queue_free()