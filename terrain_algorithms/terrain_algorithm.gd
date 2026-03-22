@abstract
class_name TerrainAlgorithm extends Resource

enum Voxel{SAND, GRASS, MOUNTAIN, SNOW, AIR}

@export var max_height: int
@export var noise: TerrainNoise

var name: String = "noName"

@abstract func generate_data(position: Vector3, biome_noise: Noise, chunk_data) -> void
@abstract func create_name() -> String
