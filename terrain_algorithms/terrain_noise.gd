@abstract
class_name TerrainNoise extends Resource

@export var noise = FastNoiseLite.new()
var name: String = "noName"


func get_height(position: Vector2, max_height: int) -> int:
	return 0
	
	
func has_voxel(position: Vector3) -> bool:
	return false
