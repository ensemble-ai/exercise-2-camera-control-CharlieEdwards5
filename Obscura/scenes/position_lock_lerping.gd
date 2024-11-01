class_name PositionLockLerping
extends CameraControllerBase


@export var cross_size:float = 10.0
@export var follow_speed:float = target.BASE_SPEED * 4 / 5
@export var catchup_speed:float = target.BASE_SPEED * 7 / 5
@export var leash_distance:float = 20

var _speed:float


func _ready() -> void:
	super()
	global_position = target.position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	var _target_position = target.global_position
	var _camera_position = global_position
	# Calculate the planar distance
	var _distance_to_target = Vector2(_camera_position.x, _camera_position.z).distance_to(Vector2(_target_position.x, _target_position.z))

	# Set speed based on whether the player is moving
	_speed = catchup_speed if target.velocity.is_zero_approx() else follow_speed

	if _distance_to_target > leash_distance:
		# Snap within leash distance in the horizontal plane
		var _direction = (_target_position - _camera_position).normalized()
		_direction.y = 0  # Ignore vertical adjustment
		global_position = _target_position - _direction * leash_distance
	else:
		# Move camera toward target at current speed within leash distance
		var _direction = (_target_position - _camera_position).normalized()
		_direction.y = 0  # Ignore vertical adjustment
		global_position += _direction * _speed * delta
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -cross_size / 2
	var right:float = cross_size / 2
	var top:float = -cross_size / 2
	var bottom:float = cross_size / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_end()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
