extends Node3D
class_name BuildableCursor

var _overlap_area: BuildableInstance = null :
	get:
		return _overlap_area
	set(new_area):
		# Remove the previous overlap_area signal connections
		if _overlap_area != null:
			_overlap_area.disconnect("area_entered", _on_overlap_begin)
			_overlap_area.disconnect("area_exited", _on_overlap_stop)
			
		_overlap_area = new_area
		
		if _overlap_area != null:
			# The curosr does not need to be detectable by other areas
			_overlap_area.monitorable = false
			# The cursor must be able to detect other areas
			_overlap_area.monitoring = true
			
			# Reset the collision mask and layer
			_overlap_area.collision_layer = 0
			_overlap_area.collision_mask = 0
			
			# The cursor must look for areas on layer 2 
			_overlap_area.set_collision_mask_value(2, true)
			
			# Connect colision signals to the appropriate functions
			_overlap_area.connect("area_entered", _on_overlap_begin)
			_overlap_area.connect("area_exited", _on_overlap_stop)
			
			
			(_overlap_area as BuildableInstance).is_cursor(true)

@export var cursor_mesh: Buildable
@export var old_mesh: Buildable

var _cursor_snap_points: Array[SnapPoint] = []

var overlapping: bool = false :
	get:
		return overlapping
	set(new_status):
		overlapping = new_status
		if _overlap_area != null:
			_overlap_area.set_overlapped_material(overlapping)

func _ready():
	overlapping = false
	place_mesh()
	pass

func _input(event):
	if (event is InputEventKey) and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			swap_mesh()
			
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if !overlapping && cursor_mesh != null:
				var instance = cursor_mesh.instance.instantiate()
				(instance as Node3D).position = position
				print("Placed at " + str(position))
				get_parent().add_child(instance)

func swap_mesh():
	var tmp = old_mesh
	old_mesh = cursor_mesh
	cursor_mesh = tmp
	
	var current = get_child(0)
	if current != null:
		current.queue_free()
	place_mesh()
	check_if_still_overlapping()

func place_mesh():
	if cursor_mesh != null:
		var instance = cursor_mesh.instance.instantiate() 
		(instance as Node3D).name = "Mesh"
		
		_overlap_area = (instance as BuildableInstance)
		
		_cursor_snap_points = _overlap_area.get_snap_points()
		_overlap_area.is_cursor(true)
		
		add_child(instance)
		(_overlap_area as BuildableInstance).set_overlapped_material(overlapping)
	else:
		_overlap_area = null
		_cursor_snap_points.clear()

func calculate_snap() -> Vector3:
	if _cursor_snap_points.is_empty():
		return Vector3.INF
	
	var best_snap_point: SnapOffset = SnapOffset.new()
	for snap_point in _cursor_snap_points:
		var snap_point_calculatedd = snap_point.calculate_best_snap_point()
		if snap_point_calculatedd.offset_distance < best_snap_point.offset_distance:
			best_snap_point = snap_point_calculatedd

	return best_snap_point.offset_vec
	

# Called when another object begins overlapping
func _on_overlap_begin(_area):
	overlapping = true

# Called when another object is no longer overlapping
func _on_overlap_stop(_area):
	# Check if there are any other objects that still overlap
	check_if_still_overlapping()

func check_if_still_overlapping():
	if !_overlap_area.has_overlapping_areas():
		overlapping = false
