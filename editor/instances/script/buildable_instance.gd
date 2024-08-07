class_name BuildableInstance
extends Area3D

@export var snap_points: Array[SnapPoint] = []
@export var mesh: MeshInstance3D

@onready var overlapped_material: Material = preload("res://editor/materials/overlapped.tres")
@onready var not_overlapped_material: Material = preload("res://editor/materials/not_overlapped.tres")

func set_overlapped_material(overlapped: bool) -> void:
	if overlapped:
		for id in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(id, overlapped_material)
	else:
		for id in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(id, not_overlapped_material)

func get_snap_points() -> Array[SnapPoint]:
	return snap_points

func is_cursor(yes: bool):
	for snap_point in snap_points:
		snap_point.snap_detection_active(yes)

