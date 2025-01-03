class_name AutoScroll
extends CameraControllerBase


@export var top_left:Vector2
@export var bottom_right:Vector2
@export var autoscroll_speed:Vector3 # y always = 0


func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()

	var _tpos = target.global_position

	global_position += autoscroll_speed * delta
	_tpos += autoscroll_speed * delta
	
	var _left_bound = global_position.x + top_left.x
	var _right_bound = global_position.x + bottom_right.x
	var _top_bound = global_position.z + top_left.y
	var _bottom_bound = global_position.z + bottom_right.y
	
	if _tpos.x < _left_bound:
		_tpos.x = _left_bound
	elif _tpos.x > _right_bound:
		_tpos.x = _right_bound
	
	if _tpos.z < _top_bound:
		_tpos.z = _top_bound
	elif _tpos.z > _bottom_bound:
		_tpos.z = _bottom_bound
	
	target.global_position = _tpos
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x
	var right:float = bottom_right.x
	var top:float = top_left.y
	var bottom:float = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
