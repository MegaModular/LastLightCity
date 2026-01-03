extends Node

enum BUILDINGTYPE{HQ, BUILDING, EMPTY}

var buildings := {}

var tileSize = 2

func gridToWorld(cell : Vector2i) -> Vector3:
	return Vector3(cell.x * tileSize, 0, cell.y * tileSize)

func worldToGrid(position : Vector3) -> Vector2i:
	return Vector2i(floor(position.x / tileSize), floor(position.z / tileSize))

func registerBuilding(cell : Vector2i, building: Node3D):
	buildings[cell] = building

func getBuildingAtCell(cell : Vector2i):
	return buildings.get(cell)
