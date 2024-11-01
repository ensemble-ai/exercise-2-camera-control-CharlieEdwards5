class_name FourWaySpeedupPushZone
extends CameraControllerBase


@export var push_ratio: float = target.BASE_SPEED * 2 / 5
@export var pushbox_top_left: Vector2
@export var pushbox_bottom_right: Vector2
@export var speedup_zone_top_left: Vector2
@export var speedup_zone_bottom_right: Vector2


func _ready() -> void:
	super()
	global_position = target.global_position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()

	var _target_position = target.global_position

	# Convert pushbox and speedup zone to global coordinates
	var _global_pushbox_top_left = global_position + Vector3(pushbox_top_left.x, 0, pushbox_top_left.y)
	var _global_pushbox_bottom_right = global_position + Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y)
	var _global_speedup_zone_top_left = global_position + Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y)
	var _global_speedup_zone_bottom_right = global_position + Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y)

	# Determine if the player is in the speedup zone (inner area)
	var in_speedup_zone = (
		_target_position.x > _global_speedup_zone_top_left.x and _target_position.x < _global_speedup_zone_bottom_right.x
		and _target_position.z > _global_speedup_zone_top_left.z and _target_position.z < _global_speedup_zone_bottom_right.z
	)
	if in_speedup_zone:
		super(delta)
		return

	# Determine if the player is touching the outer pushbox boundaries
	var _touching_top = _target_position.z < _global_pushbox_top_left.z
	var _touching_bottom = _target_position.z > _global_pushbox_bottom_right.z
	var _touching_left = _target_position.x < _global_pushbox_top_left.x
	var _touching_right = _target_position.x > _global_pushbox_bottom_right.x

	# Determine if the player is in the outer region but not touching boundaries
	var in_outer_region = (
		!in_speedup_zone and
		!(_touching_top or _touching_bottom or _touching_left or _touching_right)
	)

	# Get the normalized movement direction of the target
	var _move_direction = target.velocity.normalized()
	var _camera_movement = Vector3()

	# Movement logic based on the region the player is in
	if in_outer_region:
		# Calculate the direction vector from the camera to the player
		var _direction_to_player = (_target_position - global_position).normalized()
		
		# Move the camera toward the player at `push_ratio`
		_camera_movement = _direction_to_player * push_ratio * delta
	elif _touching_top or _touching_bottom or _touching_left or _touching_right:
		# Player is touching the boundary edges
		if (_touching_top or _touching_bottom) and (_touching_left or _touching_right):
			# Player is in a corner
			_camera_movement.x = _move_direction.x * target.velocity.length() * delta  # Full speed in X
			_camera_movement.z = _move_direction.z * target.velocity.length() * delta  # Full speed in Z
		else:
			# Player is touching a single boundary
			if _touching_top or _touching_bottom:
				_camera_movement.z = _move_direction.z * target.velocity.length() * delta  # Full speed in Z
				_camera_movement.x = _move_direction.x * target.velocity.length() * push_ratio * delta  # Scaled by push_ratio in X
			if _touching_left or _touching_right:
				_camera_movement.x = _move_direction.x * target.velocity.length() * delta  # Full speed in X
				_camera_movement.z = _move_direction.z * target.velocity.length() * push_ratio * delta  # Scaled by push_ratio in Z
	else:
		# Player is in the middle speedup zone, so no movement for the camera
		_camera_movement = Vector3(0, 0, 0)

	global_position += _camera_movement

	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Left side of pushbox
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	# Bottom of pushbox
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	# Right side of pushbox
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	# Top of pushbox
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_end()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Left side of speedup zone
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	# Bottom of speedup zone
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	# Right side of speedup zone
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	# Top of speedup zone
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
