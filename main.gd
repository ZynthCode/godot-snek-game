extends Control

@export var is_debugging = false

var tick_in_seconds = 0.25
var time_passed = 0

func _ready():
	if(is_debugging):
		$PlayerPosition.show()
		
	init_game()

func init_game():
	State.apple_position = get_random_pos()
	State.head_position = get_random_pos()
	State.body_positions = []
	State.game_over = false
	time_passed = 0

func _process(delta):
	if(State.game_over):
		return
	
	time_passed += delta
	if(time_passed > tick_in_seconds):
		time_passed = 0
		
		# Debug Line
		$PlayerPosition.text = str(State.head_position)
	
		move_player()
		handle_food_collision()
		handle_other_collisions()
		
		$SnakeMovementController.tick()
	
	queue_redraw()

func move_player():
	var previous_pos = State.head_position
	State.head_position += State.current_direction * State.rectangle_size
		
	State.body_positions.push_front(previous_pos)
	if(State.body_positions.size() > State.body_count):
		State.body_positions.pop_back()

func handle_food_collision():
	var has_found_food = State.head_position.is_equal_approx(State.apple_position)
	if(has_found_food):
		State.apple_position = get_random_pos()
		State.body_count += 1
		
		increase_score()
		
		tick_in_seconds = tick_in_seconds * 0.9 

func handle_other_collisions():
	if(has_collided()):
		State.game_over = true
		$Fade.show()
		$GameOverScreen.show()
		
		
func has_collided():
	var has_collided_with_body = State.head_position in State.body_positions
	var has_hit_horizontal_side = State.head_position.x <= 0 or State.head_position.x >= State.window_size.x - (State.rectangle_size.x + 1)
	var has_hit_vertical_side = State.head_position.y <= 0 or State.head_position.y >= State.window_size.y - (State.rectangle_size.y + 1)
	return has_collided_with_body or has_hit_horizontal_side or has_hit_vertical_side

func increase_score():
	State.current_score += 100
	$ScoreValue.text = str(State.current_score)
	
func get_random_pos() -> Vector2:
	randomize()
	const SPAWN_PADDING = 3
	var random_pos = Vector2(randi_range(SPAWN_PADDING, State.GRID_SIZE - SPAWN_PADDING), randi_range(SPAWN_PADDING, State.GRID_SIZE - SPAWN_PADDING))
	return random_pos * State.rectangle_size
