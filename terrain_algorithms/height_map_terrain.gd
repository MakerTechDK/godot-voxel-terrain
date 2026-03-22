class_name HeightMapTerrain extends TerrainAlgorithm

func _init() -> void:
	name = "HeightMapTerrain"
	
	
func create_name() -> String:
	return name + "_" + noise.name + "_" + str(max_height)
	

func generate_data(position: Vector3, biome_noise: Noise, chunk_data) -> void:
	var chunk_size = chunk_data.size
	
	for x in range(chunk_size):
		for z in range(chunk_size):
			var global_pos_xz = Vector2(position.x + x, position.z + z)
			var height = noise.get_height(global_pos_xz, max_height)
			
			if height < position.y: continue
			
			var local_height = height - position.y
			for y in range(min(local_height, chunk_size)):
				
				var biome_n = ((biome_noise.get_noise_2d(global_pos_xz.x, global_pos_xz.y) + 0.5 * biome_noise.get_noise_2d(2*global_pos_xz.x, 2*global_pos_xz.y)+0.25*biome_noise.get_noise_2d(4*global_pos_xz.x, 4*global_pos_xz.y)) / 1.75 + 1.0) / 2.0
				var biome = Voxel.SAND
				if biome_n > 0.55: biome = Voxel.GRASS
				if (y+position.y) / max_height >= 0.22: 
					biome = Voxel.MOUNTAIN
					if biome_n > 0.5 && (y+position.y) / max_height > 0.4 : biome = Voxel.SNOW
					
				chunk_data.AddVoxel(x, y, z, biome)
