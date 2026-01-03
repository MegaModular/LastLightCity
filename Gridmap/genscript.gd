extends Node3D

@onready var hqScene = preload('res://Gridmap/Tiles/HQ.tscn')
@onready var defaultScene = preload('res://Gridmap/Tiles/DefaultBuilding.tscn')
@onready var emptyScene = preload('res://Gridmap/Tiles/Empty.tscn')

var gridSize : int = 4

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
	if rng == 0:
		scene = defaultScene.instantiate()
	if rng == 1:
		scene = emptyScene.instantiate()
	if cell == Vector2i(0, 0):
		scene = hqScene.instantiate()
	
	scene.position = BuildingManager.gridToWorld(cell)
	self.add_child(scene)
	BuildingManager.registerBuilding(cell, scene)

func decideBuilding():
	return randi_range(0, 1)
