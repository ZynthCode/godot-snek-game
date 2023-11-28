extends Node

var previous_direction

func _input(event : InputEvent):
	if(event.is_action_pressed("move_up") and not previous_direction == Direction.DOWN):
		State.current_direction = Direction.UP
	if(event.is_action_pressed("move_down") and not previous_direction == Direction.UP):
		State.current_direction = Direction.DOWN
	if(event.is_action_pressed("move_left") and not previous_direction == Direction.RIGHT):
		State.current_direction = Direction.LEFT
	if(event.is_action_pressed("move_right") and not previous_direction == Direction.LEFT):
		State.current_direction = Direction.RIGHT

func tick():
	previous_direction = State.current_direction
