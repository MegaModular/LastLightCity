extends Control

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if BuildingManager.selectedBuilding != null:
		var b = BuildingManager.selectedBuilding
		$PanelContainer.visible = true
		$PanelContainer/VBoxContainer/Debug.text = "Type = " + str(b.buildingType) + ", Cell = " + str(b.cell) + " " + str(b)
		$PanelContainer/VBoxContainer/Health.text = str("Health = " + str(b.health))
	else:
		$PanelContainer.visible = false
