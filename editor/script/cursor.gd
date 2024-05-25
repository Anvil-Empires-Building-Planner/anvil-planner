extends Node3D

class_name BuildableCursor

@export var cursor_mesh: Buildable
@export var old_mesh: Buildable

func _ready():
	place_mesh()

func _input(event):
	if (event is InputEventKey) and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			swap_mesh()
			
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if cursor_mesh != null:
				var instance = cursor_mesh.scene.instantiate()
				(instance as Node3D).position = position
				get_parent().add_child(instance)

func swap_mesh():
	var tmp = old_mesh
	old_mesh = cursor_mesh
	cursor_mesh = tmp
	
	var current = get_child(0)
	if current != null:
		current.queue_free()
	place_mesh()

func place_mesh():
	if cursor_mesh != null:
		var instance = cursor_mesh.scene.instantiate() 
		(instance as Node3D).name = "Mesh"
		add_child(instance)
