extends CharacterBody3D

signal add_voxel()
signal remove_voxel()

@export var mouse_sensitivity: float = 0.005
@export var speed: int = 10
@export var jump_velocity: float = 4.5
@onready var head: Node3D = $Head
@onready var eye_camera: Camera3D = $Head/EyeCamera
@onready var block_modification: BlockModification = $Head/EyeCamera/BlockModification

var flying: bool = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if flying:
			velocity = Vector3.ZERO
		else:
			velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("flying"):
		flying = !flying
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (eye_camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if flying:
			velocity = direction * speed
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative = event.relative * mouse_sensitivity
		head.rotate_y(-relative.x)
		eye_camera.rotate_x(relative.y)
		eye_camera.rotation.x = clamp(eye_camera.rotation.x, deg_to_rad(-65), deg_to_rad(65))
	
	if event.is_action_pressed("add_block"):
		var hit = block_modification.get_ray_hit()
		if !hit: return
		
		add_voxel.emit(hit.add_position, TerrainAlgorithm.Voxel.GRASS)
		
	if event.is_action_pressed("remove_block"):
		var hit = block_modification.get_ray_hit()
		if !hit: return
		
		remove_voxel.emit(hit.remove_position)
