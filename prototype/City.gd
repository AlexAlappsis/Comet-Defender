extends Area2D

signal building_destroyed

func _on_City_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Comet"):
		var owner_id = shape_find_owner(area_shape)
		var shape = shape_owner_get_shape(owner_id, 0)
		shape_owner_set_disabled(owner_id, true)
		get_child(area_shape).hide()
		emit_signal("building_destroyed")
		body.hit_by_city()
