class_name BlockModification extends RayCast3D


class RayHit:
	var remove_position: Vector3i
	var add_position: Vector3i
	
	func _init(rem: Vector3i, add: Vector3i):
		remove_position = rem
		add_position = add


func get_ray_hit() -> RayHit:
	var collider = get_collider()
	if collider is not Chunk: return null
	
	var chunk = collider as Chunk
	var point = get_collision_point()
	var normal = get_collision_normal()
	var pos = (point - normal / 2).floor()
	
	return RayHit.new(pos, pos + normal)
