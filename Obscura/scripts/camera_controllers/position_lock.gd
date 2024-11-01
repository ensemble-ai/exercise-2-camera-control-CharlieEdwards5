class_name PositionLock
extends CameraControllerBase


@export var cross_size: float = 10.0


func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		_draw_logic()
	
	position = target.global_position
	super(delta)

func _draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var _left: float = -cross_size / 2
	var _right: float = cross_size / 2
	var _top: float = -cross_size / 2
	var _bottom: float = cross_size / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, _top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, _bottom))
	immediate_mesh.surface_end()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(_left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(_right, 0, 0))
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process.
	await get_tree().process_frame
	mesh_instance.queue_free()
