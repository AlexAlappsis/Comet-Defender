extends RigidBody2D

export (Color) var color
export (float) var plasma_hit_heat_factor
export (float) var plasma_base_impulse
export (float) var mass_loss_per_plasma_hit
export (float) var mass_loss_extra_per_plasma_heat
export (float) var minimum_mass
export (float) var density_calculation_value
export (int) var SCREEN_HEIGHT

var size

func _draw():
	draw_circle(Vector2(0.0, 0.0), size, color)
	
func _physics_process(delta):
	if position.y > SCREEN_HEIGHT + 200:
		queue_free()

func set_initial_mass(new_mass):
	mass = new_mass
	size = mass / density_calculation_value
	var shape = CircleShape2D.new()
	shape.set_radius(size)
	shape_owner_clear_shapes(0)
	shape_owner_add_shape(0, shape)
	$"CollisionShape2D".set_shape(shape)

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
	

func hit_by_plasma(point, plasma_heat):	
	var impulse_vector = (position - point).normalized() * plasma_base_impulse * (plasma_hit_heat_factor * plasma_heat)
	apply_impulse(point, impulse_vector)
	#changing mass after impulse because impulse comes from lost mass becoming steam
	var new_mass = mass - (mass_loss_per_plasma_hit) - (mass_loss_extra_per_plasma_heat * plasma_heat)
	update_mass(new_mass)

func hit_by_gun():
	explode()
	
func hit_by_ground():
	explode()
	
func hit_by_city():
	explode()

func too_small():
	explode()

func explode():
	queue_free()