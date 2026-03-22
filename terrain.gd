class_name Terrain extends Node3D

@export var wireframe: bool = false: set = set_wireframe
@export var dimensions: Vector3 = Vector3i(128, 64, 128)
@export var color_array: Dictionary[TerrainAlgorithm.Voxel, Color]

@onready var chunk_manager: ChunkManager = $ChunkManager

var loading_threads: Array[Thread] = [Thread.new()]


func _ready() -> void:
	if wireframe: 
		get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
		
	chunk_manager.terrain_algorithm.max_height = dimensions.y
	chunk_manager.meshing_algorithm.SetColors(color_array)
	loading_threads[0].start(generate_chunks.bind(Vector3(0,0,0)))

	
func set_wireframe(enabled: bool) -> void:
	wireframe = enabled
	if wireframe: 
		get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	else:
		get_viewport().debug_draw = Viewport.DEBUG_DRAW_DISABLED
	
	
func generate_chunks(pos: Vector3i) -> void:
	var number_of_chunks = dimensions / chunk_manager.chunk_size
	
	for x in range(number_of_chunks.x):
		for z in range(number_of_chunks.z):
			for y in range(number_of_chunks.y):
				var chunk_position = Vector3i(x, y, z) + pos
				chunk_manager.generate_chunk(chunk_position)

	
func _exit_tree() -> void:
	for thread in loading_threads:
		thread.wait_to_finish()
		
		
func _unhandled_key_input(event) -> void:
	if event.is_action_pressed("wireframe"):
		wireframe = !wireframe
