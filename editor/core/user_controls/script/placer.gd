extends Camera3D

@export_category("Mouse Ray")
@export var ray_length: int = 1000
@export var cursor: BuildableCursor = null

@export_category("Snapping")
signal snapped
@export var snap_threshold: float = 1.5

enum States {Free, Snapped}
var state: States = States.Free :
	get:
		return state
	set(new_state):
		state = new_state
		if state == States.Free:
			snapped.emit(false)
		elif state == States.Snapped:
			snapped.emit(true)

var target_position: Vector3 = Vector3.ZERO
var is_snapped: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	get_target_position()
	var snap_offset: Vector3 = cursor.calculate_snap()
	var distance_to_cursor: float = target_position.distance_to(cursor.global_position)
	
	if state == States.Free:
		if snap_offset != Vector3.INF and snap_offset.length() < snap_threshold:
			state = States.Snapped
			cursor.global_position = cursor.global_position - snap_offset
		else:
			cursor.global_position = target_position
	elif state == States.Snapped:
		if distance_to_cursor > snap_threshold:
			state = States.Free
			cursor.global_position = target_position
	
func get_target_position() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = project_ray_origin(mouse_pos)
	var to: Vector3 = from + project_ray_normal(mouse_pos) * ray_length
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [self]
	ray_query.from =from
	ray_query.to = to
	var raycast_result: Dictionary = space.intersect_ray(ray_query)
	if not raycast_result.is_empty():
		target_position = raycast_result.position
