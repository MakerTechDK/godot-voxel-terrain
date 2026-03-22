class_name Terrain3D extends TerrainAlgorithm


func _init() -> void:
	name = "Terrain3D"
	
	
func create_name() -> String:
	return name + "_" + noise.name + "_" + str(max_height)
	

func generate_data(position: Vector3, biome_noise: Noise, chunk_data) -> void:
	var chunk_size = chunk_data.size
	
	for x in range(chunk_size):
		for z in range(chunk_size):
			for y in range(chunk_size):
				var pos = Vector3(x, y, z) + position
				var has_voxel = noise.has_voxel(pos)
				if !has_voxel: continue
			
				var biome_n = ((biome_noise.get_noise_2d(pos.x, pos.y) + 0.5 * biome_noise.get_noise_2d(2*pos.x, 2*pos.y)+0.25*biome_noise.get_noise_2d(4*pos.x, 4*pos.y)) / 1.75 + 1.0) / 2.0
				var biome = Voxel.SAND
				if biome_n > 0.55: biome = Voxel.GRASS
				if (y+position.y) / max_height >= 0.22: 
					biome = Voxel.MOUNTAIN
					if biome_n > 0.5 && (y+position.y) / max_height > 0.4 : biome = Voxel.SNOW
					
				chunk_data.AddVoxel(x, y, z, biome)
