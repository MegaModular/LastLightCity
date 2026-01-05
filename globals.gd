extends Node

enum GameState{DAY, NIGHT}
var state = GameState.DAY

signal changingState

var disableClickRaycast : bool = false

func changeToNight() -> void:
	if state == GameState.DAY:
		state = GameState.NIGHT
		emit_signal("changingState", state)

func changeToDay() -> void:
	if state == GameState.NIGHT:
		state = GameState.DAY
		emit_signal("changingState", state)
