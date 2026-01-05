extends Control

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if BuildingManager.selectedBuilding != null:
		var b = BuildingManager.selectedBuilding
		$PanelContainer.visible = true
		$PanelContainer/VBoxContainer/Debug.text = "Type = " + str(b.buildingType) + ", Cell = " + str(b.cell) + " " + str(b)
		$PanelContainer/VBoxContainer/Health.text = str("Health = " + str(b.health))
		$PanelContainer/VBoxContainer/IsClaimed.text = "Claimed = " + str(b.claimed)
	else:
		$PanelContainer.visible = false


func _on_claim_building_pressed() -> void:
	BuildingManager.claimBuilding(BuildingManager.selectedBuilding.cell)


func _on_panel_container_mouse_entered() -> void:
	Globals.disableClickRaycast = true

func _on_panel_container_mouse_exited() -> void:
	Globals.disableClickRaycast = false

#Idk why this is even needed but it is
func _on_claim_building_mouse_entered() -> void:
	Globals.disableClickRaycast = true


func _on_check_button_toggled(toggled_on: bool) -> void:
	if Globals.state == Globals.GameState.DAY && !toggled_on:
		Globals.changeToNight()
	if Globals.state == Globals.GameState.NIGHT && toggled_on:
		Globals.changeToDay()
