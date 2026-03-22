class_name RemoveBox extends CSGBox3D

@export var ray: RayCast3D

func _physics_process(delta) -> void:
	if ray.is_colliding():
		visible = true
		var collision_normal = ray.get_collision_normal()
		var collision_pos = (ray.get_collision_point() - collision_normal / 2).floor() + Vector3(0.5, 0.5, 0.5)
		if collision_pos != global_position:
			global_position = collision_pos
	else:
		visible = false
