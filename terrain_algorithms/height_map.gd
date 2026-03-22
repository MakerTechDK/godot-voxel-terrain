class_name HeightMap extends TerrainNoise


func _ready() -> void:
	name = "HeightMap"


func get_height(position: Vector2, max_height: int) -> int:
	var rand = ((noise.get_noise_2d(position.x, position.y) + 0.5 * noise.get_noise_2d(position.x * 2, position.y * 2) + 0.25 * noise.get_noise_2d(position.x * 4, position.y * 4)) / 1.75 + 1.0) / 2.0
	var rand_p = pow(rand, 2.1)
	var height = max_height * rand_p
	return height
