class_name ChunkManager extends Node

@export var chunk_size: int = 32
@export var meshing_algorithm: MeshingAlgorithm
@export var terrain_algorithm: TerrainAlgorithm
@export var logger: ChunkManagerLogger = ChunkManagerLogger.new()

var chunk_class = preload("res://chunk.tscn")
var chunks: Dictionary[Vector3i, Chunk] = {}


func _ready()-> void:
	logger.chunk_manager = self
	logger.enable_logging(self)
	

func add_voxel(pos: Vector3i, voxel: TerrainAlgorithm.Voxel) -> void:
	var chunk = get_chunk(pos)
	if !chunk:
		chunk = create_chunk(voxel_to_chunk_position(pos))
		add_child(chunk)
	
	var local_position = global_to_local(pos)
	chunk.chunk_data.AddVoxel(local_position.x, local_position.y, local_position.z, voxel)
	chunk.remesh()
	
	
func remove_voxel(pos: Vector3i) -> void:
	var chunk = get_chunk(pos)
	if !chunk: return
	
	var local_position = global_to_local(pos)	
	chunk.chunk_data.RemoveVoxel(local_position.x, local_position.y, local_position.z)
	
	if chunk.chunk_data.IsEmpty():
		remove_chunk(chunk.position)
		return
		
	chunk.remesh()
	#if on chunk border and neighbour chunk has voxel, remesh neighbour chunk <- if we make meshing algorithm check neighbour chunks as well!!
	
	
func get_chunk(pos: Vector3i) -> Chunk:
	var chunk_position = voxel_to_chunk_position(pos)
	if !chunks.has(chunk_position): return null
	
	return chunks[chunk_position]
	
	
func remove_chunk(chunk_position: Vector3i) -> void:
	if !chunks.has(chunk_position): return
	
	var chunk = chunks[chunk_position]
	chunks.erase(chunk_position)
	chunk.queue_free()
	
	
func create_chunk(chunk_position: Vector3i) -> Chunk:
	remove_chunk(chunk_position)
		
	var chunk = chunk_class.instantiate() as Chunk
	chunk.chunk_data.SetSize(chunk_size)
	chunk.meshing_algorithm = meshing_algorithm
	chunk.position = chunk_position
	chunks[chunk.position] = chunk
	
	return chunk
	
	
func generate_chunk(chunk_position: Vector3i) -> void:
	var chunk = create_chunk(chunk_position * chunk_size)
	chunk.generate_data(terrain_algorithm)
	if chunk.chunk_data.IsEmpty():
		remove_chunk(chunk.position)
		return
	
	logger.start_time_log()
	chunk.create_mesh()
	logger.end_time_log(chunk, chunk_position)
	call_deferred("add_child", chunk)
	
	
func global_to_local(pos: Vector3i) -> Vector3i:
	return pos % chunk_size
	
	
func voxel_to_chunk_position(pos: Vector3i) -> Vector3i:
	return pos / chunk_size * chunk_size
	
