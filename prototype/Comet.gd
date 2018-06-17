extends RigidBody2D

export (Color) var color
export (float) var plasma_hit_heat_factor
export (float) var plasma_base_impulse
export (float) var mass_loss_per_plasma_hit
export (float) var mass_loss_extra_per_plasma_heat
export (float) var minimum_mass

var size
var densityCalculationValue = 10

func _ready():
	
	pass
	
func _draw():
	draw_circle(Vector2(0.0, 0.0), size, color)

func update_mass(new_mass):
	if new_mass < minimum_mass:
		queue_free()
	else:
		mass = new_mass
		size = mass / densityCalculationValue
		$CollisionShape2D.shape.radius = size
		update()
	

func hit_by_plasma(point, plasma_heat):	
	var impulse_vector = (position - point).normalized() * plasma_base_impulse * (plasma_hit_heat_factor * plasma_heat)
	apply_impulse(point, impulse_vector)
	#changing mass after impulse because impulse comes from lost mass becoming steam
	var new_mass = mass - (mass_loss_per_plasma_hit) - (mass_loss_extra_per_plasma_heat * plasma_heat)
	update_mass(new_mass)
