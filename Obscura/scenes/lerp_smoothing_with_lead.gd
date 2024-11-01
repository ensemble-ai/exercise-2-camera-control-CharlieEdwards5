class_name LerpSmoothingWithLead
extends CameraControllerBase


@export var cross_size:float = 5.0  # 5x5 cross size
@export var lead_speed:float = target.BASE_SPEED * 6 / 5  # Change this as needed for faster than vessel speed
@export var catchup_delay_duration:float = 0.25  # Delay before catching up
@export var catchup_speed:float = target.BASE_SPEED * 4 / 5  # Speed to catch up when target stops
@export var leash_distance:float = 10.0  # Max distance from target

var _speed:float
var _catchup_timer:float = 0.0


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
	#  Calculate planar distance
	var _distance_to_target = Vector2(_camera_position.x, _camera_position.z).distance_to(Vector2(_target_position.x, _target_position.z))

	# Check if the player is moving
	if !target.velocity.is_zero_approx():
		# Reset the catchup timer as the player is actively moving
		_catchup_timer = 0.0
		
		# Determine the lead direction based on player's movement direction
		var _direction = target.velocity.normalized()
		_direction.y = 0  # Ignore vertical adjustment

		# Move camera toward the lead position at lead speed
		if _distance_to_target < leash_distance:
			global_position += _direction * lead_speed * delta
		else:
			# Keep the camera exactly at leash_distance if it exceeds it
			global_position = _target_position + _direction * leash_distance

	else:
		# Increment the catchup timer when the player stops moving
		_catchup_timer += delta
		
		# Only apply catchup movement after the delay has passed
		if _catchup_timer >= catchup_delay_duration:
			# Calculate direction to move camera back towards player
			var _catchup_direction = (_target_position - _camera_position).normalized()
			_catchup_direction.y = 0  # Ignore vertical adjustment
			
			# Move camera toward player with catchup speed, but stay within leash_distance
			if _distance_to_target > leash_distance:
				global_position = _target_position - _catchup_direction * leash_distance
			else:
				global_position += _catchup_direction * catchup_speed * delta

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
