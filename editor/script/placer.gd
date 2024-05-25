extends Camera3D

@export var ray_length: int = 1000
@export var cursor: BuildableCursor = null

var target_position: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_target_position()
	cursor.position = target_position
	
func get_target_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [self]
	ray_query.from =from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if not raycast_result.is_empty():
		target_position = raycast_result.position
