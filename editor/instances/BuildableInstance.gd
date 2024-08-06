class_name BuildableInstance
extends Area3D

@export var mesh: MeshInstance3D

var placable_material: Material = preload("res://editor/PlacableMaterial.tres")
var overlapped_material: Material = preload("res://editor/OverlappedMaterial.tres")

func set_overlap_material(overlapping: bool):
	if overlapping:
		for id in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(id, overlapped_material)
	else:
		for id in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(id, placable_material)
