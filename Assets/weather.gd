extends Node3D

func _ready():
	$AnimationPlayer.play('dayStart')
	Globals.changingState.connect(transition_to_night)

func transition_to_night(state):
	if state == Globals.GameState.NIGHT:
		$AnimationPlayer.play('dayEnd')
	if state == Globals.GameState.DAY:
		$AnimationPlayer.play('dayStart')
