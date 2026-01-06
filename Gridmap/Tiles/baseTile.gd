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

func claimTile() -> void:
	self.claimed = true
	self.dangerLevel = 0
	self.health = 10
