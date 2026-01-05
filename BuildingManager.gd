extends Node

@onready var wallScene = preload('res://Gridmap/wallNode.tscn')
@onready var wallConnectorScene = preload('res://Gridmap/wall_face.tscn')

#Variables
enum BUILDINGTYPE{HQ, BUILDING, EMPTY}
var tileSize = 4.0

#Building Data
var buildings := {}
var claimedBuildings := {}
var selectedBuilding

#Wall Data
var walls := {}
var wallConnections := {}

#Helper functions used throughout scripts.
#returns real world position based on grid coordinates
func gridToWorld(cell : Vector2i) -> Vector3:
	return Vector3(cell.x * tileSize, 0, cell.y * tileSize)

func gridToWorldFloat(cell : Vector2) -> Vector3:
	return Vector3(cell.x * tileSize, 0, cell.y * tileSize)

#returns grid position based on real world input
func worldToGrid(position : Vector3) -> Vector2i:
	position += Vector3(tileSize/2, 0, tileSize / 2)
	return Vector2i(floor(position.x / tileSize), floor(position.z / tileSize))

#Constructor for data model
func registerBuilding(cell : Vector2i, building: Node3D):
	buildings[cell] = building

func registerWall(cell : Vector2i, wall : Node3D):
	walls[cell] = wall

func registerConnection(cell : Vector2, connection : Node3D):
	wallConnections[cell] = connection

func getBuildingAtCell(cell : Vector2i):
	return buildings.get(cell)

func getWallAtCell(cell : Vector2i):
	return walls.get(cell)

func selectBuildingAtCell(cell : Vector2i):
	selectedBuilding = getBuildingAtCell(cell)

func clearSelection():
	selectedBuilding = null

#Claims building and creates walls
func claimBuilding(cell : Vector2i):
	if !claimedBuildings.has(cell):
		claimedBuildings[cell] = buildings.get(cell)
		buildings.get(cell).claimTile()
		calculateWalls()

#recalculates wall nodes based on claimed buildings and draws them too
func calculateWalls():
	print('Draw Walls called')
	walls.clear()
	
	for x in get_tree().current_scene.get_node("Walls").get_children():
		x.queue_free()
	
	for cell in claimedBuildings.keys():
		#claim adjacent
		for i in range(0, 2):
			for j in range(0, 2):
				var wallCell = cell - Vector2i(i, j)
				if !walls.has(wallCell):
					var wallNode = wallScene.instantiate() 
					registerWall(wallCell, wallNode)
					wallNode.position = gridToWorld(wallCell) + Vector3(tileSize / 2, 0, tileSize / 2)
					get_tree().current_scene.get_node("Walls").add_child(wallNode)
	removeRedundantWalls()
	drawConnectingWalls()
	removeInvalidWalls()

#Helper methods
func removeRedundantWalls():
	var redundantWalls = []
	for cell in walls:
		if isWallRedundant(cell):
			redundantWalls.append(cell)
	
	if !redundantWalls.is_empty():
		for cell in redundantWalls:
			walls.get(cell).queue_free()
			walls.erase(cell)

#Check surrounding tiles. If they are all owned, don't spawn wall.
# x | x
# -----  (x = owned) - return true, else false
# x | x 
func isWallRedundant(cell) -> bool:
	if claimedBuildings.has(cell + Vector2i(0, 1)) && claimedBuildings.has(cell + Vector2i(1, 0)) && claimedBuildings.has(cell + Vector2i(1, 1)) && claimedBuildings.has(cell):
		return true
	return false

#Efficient code, totally.
func drawConnectingWalls() -> void:
	wallConnections.clear()
	for i in get_tree().current_scene.get_node("Connections").get_children():
		i.queue_free()
	
	for cell in walls:
		var cellOffset = cell + Vector2i(1, 0)
		var wallGridPos = Vector2(cell).lerp(cellOffset, 0.50)
		if walls.has(cell) && walls.has(cellOffset) && !wallConnections.has(wallGridPos):
			var wallConnection = wallConnectorScene.instantiate()
			registerConnection(wallGridPos, wallConnection)
			get_tree().current_scene.get_node("Connections").add_child(wallConnection)
			wallConnection.position = gridToWorldFloat(wallGridPos) + Vector3(tileSize / 2,0, tileSize / 2)
			wallConnection.rotation = Vector3(0, deg_to_rad(90), 0)
		
		cellOffset = cell + Vector2i(0, 1)
		wallGridPos = Vector2(cell).lerp(cellOffset, 0.50)
		
		if walls.has(cell) && walls.has(cellOffset) && !wallConnections.has(wallGridPos):
			var wallConnection = wallConnectorScene.instantiate()
			registerConnection(wallGridPos, wallConnection)
			get_tree().current_scene.get_node("Connections").add_child(wallConnection)
			wallConnection.position = gridToWorldFloat(wallGridPos) + Vector3(tileSize / 2,0, tileSize / 2)

#Figure out which walls have an error
func removeInvalidWalls() -> void:
	for cell in claimedBuildings:
		if claimedBuildings.has(cell + Vector2i(0, 1)):
			removeWall(cell, 1)
		elif claimedBuildings.has(cell + Vector2i(0, 2)) && (claimedBuildings.has(cell + Vector2i(-1, 1))):
			removeWall(cell, 3)
		elif claimedBuildings.has(cell + Vector2i(0, 2)) && (claimedBuildings.has(cell + Vector2i(1, 1))):
			removeWall(cell, 4)
		if claimedBuildings.has(cell + Vector2i(1, 0)):
			removeWall(cell, 2)
		elif claimedBuildings.has(cell + Vector2i(2, 0)) && (claimedBuildings.has(cell + Vector2i(1, -1))):
			removeWall(cell, 5)
		elif claimedBuildings.has(cell + Vector2i(2, 0)) && (claimedBuildings.has(cell + Vector2i(1, 1))):
			removeWall(cell, 6)

#Remove the walls
func removeWall(cell, dir):
	var pos
	#Wall between two 
	if dir == 1:
		pos = Vector2(cell.x, cell.y).lerp(Vector2(cell.x, cell.y) + Vector2(-1, 0), 0.5)
	if dir == 2:
		pos = Vector2(cell.x, cell.y).lerp(Vector2(cell.x, cell.y) + Vector2(0, -1), 0.5)
	#Edge Cases, stops walls from spawning outside claimed territory in specific scenarios
	if dir == 3:
		pos = Vector2(cell.x, cell.y).lerp(Vector2(cell.x, cell.y) + Vector2(0, 1), 0.5)
	if dir == 4:
		pos = Vector2(cell.x - 1, cell.y).lerp(Vector2(cell.x - 1, cell.y) + Vector2(0, 1), 0.5)
	if dir == 5:
		pos = Vector2(cell.x, cell.y).lerp(Vector2(cell.x, cell.y) + Vector2(1, 0), 0.5)
	if dir == 6:
		pos = Vector2(cell.x, cell.y - 1).lerp(Vector2(cell.x, cell.y - 1) + Vector2(1, 0), 0.5)
	
	if wallConnections.has(pos):
		var x = wallConnections.get(pos)
		x.queue_free()
		wallConnections.erase(pos)
	
