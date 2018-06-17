extends RigidBody2D

export (Color) var color
var size
var densityCalculationValue = 10

func _ready():
	
	pass
	
func _draw():
	draw_circle(Vector2(0.0, 0.0), size, color)


func update_mass(newMass):
	mass = newMass
	size = mass / densityCalculationValue
	update()
