class_name Chunk extends StaticBody3D

@export var mat: Material

@onready var collision_shape = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var biome_noise: Noise = FastNoiseLite.new()
var chunk_data: ChunkData = ChunkData.new()
var mesh_data: MeshData = MeshData.new()
var meshing_algorithm: MeshingAlgorithm


func _ready() -> void:
	if mesh_data.IsEmpty(): return
	
	mesh_instance.mesh = ArrayMesh.new()
	commit_mesh()
	

func generate_data(terrain_algorithm: TerrainAlgorithm) -> void:
	terrain_algorithm.generate_data(position, biome_noise, chunk_data)


func create_mesh() -> void:
	meshing_algorithm.GenerateMesh(chunk_data, mesh_data)
	
	
func remesh() -> void:
	mesh_data.Reset()
	create_mesh()
	
	mesh_instance.mesh = ArrayMesh.new()
	commit_mesh()
	
	
func remove_voxel(pos: Vector3i) -> void:
	chunk_data.RemoveVoxel(pos. x, pos.y, pos.z)
	
	
func commit_mesh() -> void:
	mesh_data.Commit()
	mesh_instance.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data.GetSurfaceArray())
	mesh_instance.mesh.surface_set_material(0, mat)
	
	collision_shape.shape = mesh_instance.mesh.create_trimesh_shape()
