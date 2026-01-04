extends Control

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if BuildingManager.selectedBuilding != null:
		$PanelContainer.visible = true
		$PanelContainer/VBoxContainer/Debug.text = str(BuildingManager.selectedBuilding)
		$PanelContainer/VBoxContainer/Health.text = str("Health = " + str(BuildingManager.selectedBuilding.health))
	else:
		$PanelContainer.visible = false
