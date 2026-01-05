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

func _process(_delta: float) -> void:
	if claimed:
		$SpotLight3D.visible = true
	else:
		$SpotLight3D.visible = false

func claimTile() -> void:
	self.claimed = true
	self.dangerLevel = 0
	self.health = 10
