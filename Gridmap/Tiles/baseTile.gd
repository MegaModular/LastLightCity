extends Node3D

var mouseInArea = false

#set via building manager
var cell
var buildingType

var selected = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('lmb') && mouseInArea:
		Globals.selectedTile = self
	if Globals.selectedTile == self:
		$SpotLight3D.visible = true
	else:
		$SpotLight3D.visible = false

func _on_static_body_3d_mouse_entered() -> void:
	mouseInArea = true

func _on_static_body_3d_mouse_exited() -> void:
	mouseInArea = false
