extends Node3D

#Cell Data
@export var health : int = 0
@export var dangerLevel : int = 1
@export var claimed : bool = false

var mouseInArea = false

#set via building manager
var cell
var buildingType

var selected = false

func _process(delta: float) -> void:
	if BuildingManager.selectedBuilding == self:
		$SpotLight3D.visible = true
	else:
		$SpotLight3D.visible = false
