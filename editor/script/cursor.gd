extends Node3D

class_name BuildableCursor

@export var overlap_label: Label

var overlap_area: Area3D = null :
	get:
		return overlap_area
	set(new_area):
		# Remove the previous overlap_area signal connections
		if overlap_area != null:
			overlap_area.disconnect("area_entered", _on_overlap_begin)
			overlap_area.disconnect("area_exited", _on_overlap_stop)
			
		overlap_area = new_area
		
		# The curosr does not need to be detectable by other areas
		overlap_area.monitorable = false
		# The cursor must be able to detect other areas
		overlap_area.monitoring = true
		
		# Reset the collision mask and layer
		overlap_area.collision_layer = 0
		overlap_area.collision_mask = 0
		
		# The cursor must look for areas on layer 2 
		overlap_area.set_collision_mask_value(2, true)
		
		# Connect colision signals to the appropriate functions
		overlap_area.connect("area_entered", _on_overlap_begin)
		overlap_area.connect("area_exited", _on_overlap_stop)

@export var cursor_mesh: Buildable
@export var old_mesh: Buildable

var is_placable: bool = false :
	get:
		return is_placable
	set(new_status):
		is_placable = new_status
		if !is_placable:
			overlap_label.text = "Piece Overlapping: Yes"
			overlap_label.label_settings.font_color = Color.RED
		else:
			overlap_label.text = "Piece Overlapping: No"
			overlap_label.label_settings.font_color = Color.GREEN

func _ready():
	is_placable = true
	place_mesh()
	pass

func _input(event):
	if (event is InputEventKey) and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			swap_mesh()
			
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			if is_placable && cursor_mesh != null:
				var instance = cursor_mesh.instance.instantiate()
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
		var instance = cursor_mesh.instance.instantiate() 
		(instance as Node3D).name = "Mesh"
		
		overlap_area = (instance as Area3D)
		
		add_child(instance)

# Called when another object begins overlapping
func _on_overlap_begin(_area):
	is_placable = false

# Called when another object is no longer overlapping
func _on_overlap_stop(_area):
	# Check if there are any other objects that still overlap
	if !overlap_area.has_overlapping_areas():
		is_placable = true
