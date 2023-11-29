extends Node

var previous_direction

@onready var map_canvas = $"../MapCanvas"

func _input(event : InputEvent):
	update_direction(event)

func update_direction(event):
	if(event.is_action_pressed("move_up") and not previous_direction == Vector2.DOWN):
		State.current_direction = Vector2.UP
	if(event.is_action_pressed("move_down") and not previous_direction == Vector2.UP):
		State.current_direction = Vector2.DOWN
	if(event.is_action_pressed("move_left") and not previous_direction == Vector2.RIGHT):
		State.current_direction = Vector2.LEFT
	if(event.is_action_pressed("move_right") and not previous_direction == Vector2.LEFT):
		State.current_direction = Vector2.RIGHT

func reset():
	State.head_position = Vector2(Property.grid_size / 2, Property.grid_size / 2) * map_canvas.block_size
	State.body_positions = []
	
func move_player():
	var previous_pos = State.head_position
	State.head_position += State.current_direction * map_canvas.block_size
		
	State.body_positions.push_front(previous_pos)
	if(State.body_positions.size() > State.body_count):
		State.body_positions.pop_back()

func process_movement():
	move_player()
	previous_direction = State.current_direction

func get_random_pos() -> Vector2:
	randomize()
	const SPAWN_PADDING = 3
	var random_pos = Vector2(randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING), randi_range(SPAWN_PADDING, Property.grid_size - SPAWN_PADDING))
	return random_pos * Property.block_size

func has_collided():
	var has_collided_with_body = State.head_position in State.body_positions
	var has_hit_horizontal_side = State.head_position.x <= -1 or State.head_position.x >= map_canvas.window_size.x - (map_canvas.block_size.x)
	var has_hit_vertical_side = State.head_position.y <= -1 or State.head_position.y >= map_canvas.window_size.y - (map_canvas.block_size.y)
	
	if(has_hit_horizontal_side):
		print(str(State.head_position))
		
	return has_collided_with_body or has_hit_horizontal_side or has_hit_vertical_side

func has_found_food():
	return State.head_position.is_equal_approx(State.apple_position)

func grow():
	State.body_count += 1
