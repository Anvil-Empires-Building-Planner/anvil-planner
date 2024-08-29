extends Node3D

@export var base_cam_speed: float = 10.0
@export var base_cam_rot_speed: float = 2.0

func _process(delta: float) -> void:
	camera_movement(delta)
	camera_rotation(delta)

#Handle input for translation/movement
func camera_movement(delta: float) -> void:
	var direction: Vector3 = Vector3(
		Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left"),
		Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down"),
		Input.get_action_strength("camera_backwards") - Input.get_action_strength("camera_forward"),
	)

	if(direction != Vector3.ZERO):
		direction = direction.normalized()
		var finalSpeed: float = base_cam_speed * (Input.get_action_strength("camera_boost") +1)
		translate(direction * finalSpeed * delta)

#Handle input for rotation
func camera_rotation(delta: float) -> void:
	var rot_input: float = Input.get_action_strength("camera_rot_left") - Input.get_action_strength("camera_rot_right")
	rotate_y(rot_input * base_cam_rot_speed * delta)
