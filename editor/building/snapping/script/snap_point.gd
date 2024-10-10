class_name SnapPoint

extends Area3D

enum State {Cursor, Instance}

var state: State = State.Instance

@export var snap_detector_collider: CollisionShape3D

func snap_detection_active(active: bool) -> void:
	if active:
		state = State.Cursor
		snap_detector_collider.disabled = false
	else:
		state = State.Instance
		snap_detector_collider.disabled = true

func calculate_best_snap_point() -> SnapOffset:
	var collided_areas: Array[Area3D] = get_overlapping_areas()
	if collided_areas.is_empty():
		return SnapOffset.new()
		
	var closest_snap_offset: SnapOffset = SnapOffset.new()
	for instance in collided_areas:
		if instance is BuildableInstance:
			var instnce_snap_offset: SnapOffset = _check_snapping_of_buildable(instance as BuildableInstance)
			if instnce_snap_offset.offset_distance < closest_snap_offset.offset_distance:
				closest_snap_offset = instnce_snap_offset
	
	return closest_snap_offset
		

func _check_snapping_of_buildable(buildable: BuildableInstance) -> SnapOffset:
	var snap_points: Array[SnapPoint] = buildable.get_snap_points()
	
	var closest_snap_offset: SnapOffset = SnapOffset.new()
	
	for snap_point in snap_points:
		var snap_points_aligned: bool = (-transform.basis.z).dot(snap_point.transform.basis.z) == 1
		if snap_points_aligned:
			var calculated_distance: float = global_position.distance_to(snap_point.global_position)
			if calculated_distance < closest_snap_offset.offset_distance and calculated_distance > 0:
				assert((global_position - (global_position - snap_point.global_position)).is_equal_approx(snap_point.global_position))
				closest_snap_offset.offset_vec = global_position - snap_point.global_position
				closest_snap_offset.offset_distance = calculated_distance
	
	return closest_snap_offset
