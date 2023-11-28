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

func reset():
	State.head_position = get_random_pos()
	State.body_positions = []
	
func move_player():
	var previous_pos = State.head_position
	State.head_position += State.current_direction * Property.block_size
		
	State.body_positions.push_front(previous_pos)
	if(State.body_positions.size() > State.body_count):
		State.body_positions.pop_back()

func tick():
	move_player()
	previous_direction = State.current_direction

func get_random_pos() -> Vector2:
	randomize()
	const SPAWN_PADDING = 3
	var random_pos = Vector2(randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING), randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING))
	return random_pos * Property.block_size

