extends MarginContainer

@onready var snap_status_label: Label = $"VBoxContainer/Statuses Panel/Snapped Status"

func update_snap_status(is_snapped: bool) -> void:
	if is_snapped:
		snap_status_label.text = "Piece Snapped: Yes"
	else:
		snap_status_label.text = "Piece Snapped: No"
