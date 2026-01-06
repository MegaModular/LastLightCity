extends Node3D

@onready var hqScene = preload('res://Gridmap/Tiles/HQ.tscn')
@onready var defaultScene = preload('res://Gridmap/Tiles/DefaultBuilding.tscn')
@onready var emptyScene = preload('res://Gridmap/Tiles/Empty.tscn')
@onready var parkingLotScene = preload('res://Gridmap/Tiles/Finished Tiles/parkingLot.tscn')

var gridSize : int = 50

func _ready() -> void:
	randomize()
	generateMap()

func generateMap():
	for i in range(-gridSize, gridSize):
		for j in range(-gridSize, gridSize):
			createBuilding(Vector2i(i,j))

func createBuilding(cell):
	var rng = decideBuilding()

	var scene
	var enumType
	if rng == 0:
		scene = defaultScene.instantiate()
		enumType = BuildingManager.BUILDINGTYPE.BUILDING
	if rng == 1:
		scene = emptyScene.instantiate()
		enumType = BuildingManager.BUILDINGTYPE.EMPTY
	if rng == 2:
		scene = parkingLotScene.instantiate()
		enumType = BuildingManager.BUILDINGTYPE.PARKINGLOT
	if cell == Vector2i(0, 0):
		scene = hqScene.instantiate()
		enumType = BuildingManager.BUILDINGTYPE.HQ
	
	scene.position = BuildingManager.gridToWorld(cell)
	scene.buildingType = enumType
	scene.cell = cell
	self.add_child(scene)
	BuildingManager.registerBuilding(cell, scene)
	if enumType == BuildingManager.BUILDINGTYPE.HQ:
		BuildingManager.claimBuilding(cell)

func decideBuilding():
	return randi_range(0, 2)
